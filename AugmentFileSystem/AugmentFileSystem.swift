import Foundation

/// The main class for the Augment file system
public class AugmentFileSystem {
    /// Singleton instance - DEPRECATED: Use dependency injection instead
    @available(*, deprecated, message: "Use dependency injection instead of singleton pattern")
    public static let shared = AugmentFileSystem()

    /// The list of registered Augment spaces
    private var spaces: [AugmentSpace] = []

    /// CRITICAL FIX #3: Store monitor references to prevent race conditions and memory leaks
    private var spaceMonitors: [UUID: FileSystemMonitor] = [:]

    /// Queue for thread-safe access to monitors and spaces
    private let monitorQueue = DispatchQueue(
        label: "com.augment.filesystem.monitors", attributes: .concurrent)

    /// Dependencies
    private let versionControl: VersionControl

    /// Public initializer for dependency injection
    public init(versionControl: VersionControl = VersionControl()) {
        self.versionControl = versionControl

        // Load spaces from persistent storage
        loadSpaces()

        // Start monitoring existing spaces
        startMonitoringExistingSpaces()
    }

    /// Creates a new Augment space
    /// - Parameters:
    ///   - name: The name of the space
    ///   - path: The path to the space
    /// - Returns: The created space if successful, nil otherwise
    public func createSpace(name: String, path: URL) -> AugmentSpace? {
        guard path.isFileURL else { return nil }

        // Check if the space already exists
        if spaces.contains(where: { $0.path == path }) {
            return nil
        }

        // Create the space directory if it doesn't exist
        do {
            try FileManager.default.createDirectory(at: path, withIntermediateDirectories: true)
        } catch {
            print("Error creating space directory: \(error)")
            return nil
        }

        // Create the space metadata directory structure
        let metadataPath = path.appendingPathComponent(".augment", isDirectory: true)
        let versionsPath = metadataPath.appendingPathComponent("versions", isDirectory: true)
        let fileVersionsPath = metadataPath.appendingPathComponent(
            "file_versions", isDirectory: true)
        let fileMetadataPath = metadataPath.appendingPathComponent(
            "file_metadata", isDirectory: true)
        let snapshotsPath = metadataPath.appendingPathComponent("snapshots", isDirectory: true)

        do {
            try FileManager.default.createDirectory(
                at: metadataPath, withIntermediateDirectories: true)
            try FileManager.default.createDirectory(
                at: versionsPath, withIntermediateDirectories: true)
            try FileManager.default.createDirectory(
                at: fileVersionsPath, withIntermediateDirectories: true)
            try FileManager.default.createDirectory(
                at: fileMetadataPath, withIntermediateDirectories: true)
            try FileManager.default.createDirectory(
                at: snapshotsPath, withIntermediateDirectories: true)
        } catch {
            print("Error creating metadata directories: \(error)")
            return nil
        }

        // Create the space
        let space = AugmentSpace(id: UUID(), name: name, path: path)

        // Add the space to the list with thread safety
        monitorQueue.async(flags: .barrier) {
            self.spaces.append(space)

            // Save the spaces to persistent storage
            self.saveSpaces()

            // Start monitoring this space for file changes
            self.startMonitoringSpace(space)
        }

        // Initialize version control for the space
        _ = versionControl.initializeVersionControl(folderPath: path)

        return space
    }

    /// Deletes an Augment space
    /// - Parameter space: The space to delete
    /// - Returns: A boolean indicating success or failure
    public func deleteSpace(space: AugmentSpace) -> Bool {
        // Thread-safe removal of space and cleanup of monitor
        monitorQueue.async(flags: .barrier) {
            // Stop monitoring for this space
            self.stopMonitoringSpace(space)

            // Remove the space from the list
            self.spaces.removeAll { $0.id == space.id }

            // Save the spaces to persistent storage
            self.saveSpaces()
        }

        return true
    }

    /// Gets all registered Augment spaces
    /// - Returns: An array of Augment spaces
    public func getSpaces() -> [AugmentSpace] {
        return spaces
    }

    /// Gets an Augment space by path
    /// - Parameter path: The path to the space
    /// - Returns: The space if found, nil otherwise
    public func getSpace(path: URL) -> AugmentSpace? {
        return spaces.first { $0.path == path }
    }

    /// Loads spaces from persistent storage
    private func loadSpaces() {
        // Get the application support directory
        guard
            let appSupportDir = FileManager.default.urls(
                for: .applicationSupportDirectory, in: .userDomainMask
            ).first
        else {
            return
        }

        // Create the Augment directory if it doesn't exist
        let augmentDir = appSupportDir.appendingPathComponent("Augment", isDirectory: true)
        do {
            try FileManager.default.createDirectory(
                at: augmentDir, withIntermediateDirectories: true)
        } catch {
            print("Error creating Augment directory: \(error)")
            return
        }

        // Load the spaces file
        let spacesFile = augmentDir.appendingPathComponent("spaces.json")
        guard FileManager.default.fileExists(atPath: spacesFile.path) else {
            return
        }

        do {
            let data = try Data(contentsOf: spacesFile)
            let decoder = JSONDecoder()
            spaces = try decoder.decode([AugmentSpace].self, from: data)
        } catch {
            print("Error loading spaces: \(error)")
        }
    }

    /// Starts monitoring existing spaces after initialization
    private func startMonitoringExistingSpaces() {
        monitorQueue.async(flags: .barrier) {
            for space in self.spaces {
                self.startMonitoringSpace(space)
            }
        }
    }

    /// Starts monitoring a space for file changes
    /// - Parameter space: The space to monitor
    private func startMonitoringSpace(_ space: AugmentSpace) {
        // Check if already monitoring this space
        guard spaceMonitors[space.id] == nil else {
            print("AugmentFileSystem: Already monitoring space \(space.name)")
            return
        }

        let monitor = FileSystemMonitor()
        let success = monitor.startMonitoring(spacePath: space.path) { [weak self] url, event in
            self?.handleFileSystemEvent(url: url, event: event, space: space)
        }

        if success {
            // Store the monitor reference to prevent memory leaks and race conditions
            spaceMonitors[space.id] = monitor
            print("AugmentFileSystem: Started monitoring space \(space.name) at \(space.path.path)")
        } else {
            print("AugmentFileSystem: Failed to start monitoring space \(space.name)")
        }
    }

    /// Stops monitoring a space for file changes
    /// - Parameter space: The space to stop monitoring
    private func stopMonitoringSpace(_ space: AugmentSpace) {
        guard let monitor = spaceMonitors[space.id] else {
            print("AugmentFileSystem: No monitor found for space \(space.name)")
            return
        }

        monitor.stopMonitoring()
        spaceMonitors.removeValue(forKey: space.id)
        print("AugmentFileSystem: Stopped monitoring space \(space.name)")
    }

    /// Handles file system events for a space
    /// - Parameters:
    ///   - url: The URL of the changed file
    ///   - event: The type of event
    ///   - space: The space where the event occurred
    private func handleFileSystemEvent(url: URL, event: FileSystemEvent, space: AugmentSpace) {
        // Skip .augment directory and hidden files
        if url.path.contains("/.augment/") || url.lastPathComponent.starts(with: ".") {
            return
        }

        // Handle different event types
        switch event {
        case .created, .modified:
            // Auto-create file version for new or modified files
            DispatchQueue.global(qos: .utility).async {
                _ = self.versionControl.createFileVersion(
                    filePath: url, comment: "Auto-saved on \(event)")
            }
        case .deleted:
            // Log file deletion (could implement recovery here)
            print("File deleted: \(url.path)")
        case .renamed:
            // Handle file rename (could update version metadata)
            print("File renamed: \(url.path)")
        case .unknown:
            break
        }
    }

    /// Saves spaces to persistent storage
    private func saveSpaces() {
        // Get the application support directory
        guard
            let appSupportDir = FileManager.default.urls(
                for: .applicationSupportDirectory, in: .userDomainMask
            ).first
        else {
            return
        }

        // Create the Augment directory if it doesn't exist
        let augmentDir = appSupportDir.appendingPathComponent("Augment", isDirectory: true)
        do {
            try FileManager.default.createDirectory(
                at: augmentDir, withIntermediateDirectories: true)
        } catch {
            print("Error creating Augment directory: \(error)")
            return
        }

        // Save the spaces file
        let spacesFile = augmentDir.appendingPathComponent("spaces.json")
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(spaces)
            try data.write(to: spacesFile)
        } catch {
            print("Error saving spaces: \(error)")
        }
    }

    /// Cleanup method for proper resource management
    /// Should be called when the application is terminating
    public func cleanup() {
        monitorQueue.async(flags: .barrier) {
            // Stop all monitors
            for (spaceId, monitor) in self.spaceMonitors {
                monitor.stopMonitoring()
                print("AugmentFileSystem: Stopped monitor for space ID \(spaceId)")
            }
            self.spaceMonitors.removeAll()
        }
    }

    /// Gets the current monitoring status
    /// - Returns: Dictionary of space IDs to monitoring status
    public func getMonitoringStatus() -> [UUID: Bool] {
        return monitorQueue.sync {
            var status: [UUID: Bool] = [:]
            for space in spaces {
                status[space.id] = spaceMonitors[space.id] != nil
            }
            return status
        }
    }
}
