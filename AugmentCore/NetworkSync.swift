import Foundation

/// Manages network synchronization for Augment spaces
public class NetworkSync {
    /// Singleton instance
    public static let shared = NetworkSync()

    /// The list of sync configurations
    private var syncConfigurations: [SyncConfiguration] = []

    /// The sync queue
    private let syncQueue = DispatchQueue(label: "com.augment.sync", qos: .background)

    /// Private initializer for singleton pattern
    private init() {
        loadConfigurations()
    }

    /// Adds a sync configuration
    /// - Parameter configuration: The configuration to add
    /// - Returns: A boolean indicating success or failure
    public func addConfiguration(_ configuration: SyncConfiguration) -> Bool {
        // Remove any existing configuration for the same space
        removeConfiguration(spacePath: configuration.spacePath)

        // Add the new configuration
        syncConfigurations.append(configuration)

        // Save the configurations
        saveConfigurations()

        return true
    }

    /// Removes a sync configuration
    /// - Parameter spacePath: The path to the Augment space
    /// - Returns: A boolean indicating success or failure
    public func removeConfiguration(spacePath: URL) -> Bool {
        // Remove the configuration
        syncConfigurations.removeAll { $0.spacePath == spacePath }

        // Save the configurations
        saveConfigurations()

        return true
    }

    /// Gets the sync configuration for a space
    /// - Parameter spacePath: The path to the Augment space
    /// - Returns: The sync configuration if found, nil otherwise
    public func getConfiguration(spacePath: URL) -> SyncConfiguration? {
        return syncConfigurations.first { $0.spacePath == spacePath }
    }

    /// Gets all sync configurations
    /// - Returns: An array of sync configurations
    public func getConfigurations() -> [SyncConfiguration] {
        return syncConfigurations
    }

    /// Syncs a space
    /// - Parameter spacePath: The path to the Augment space
    /// - Returns: A boolean indicating success or failure
    public func syncSpace(spacePath: URL) -> Bool {
        // Get the configuration
        guard let configuration = getConfiguration(spacePath: spacePath) else { return false }

        // Check if the configuration is enabled
        guard configuration.isEnabled else { return false }

        // Sync the space
        syncQueue.async {
            self.performSync(configuration: configuration)
        }

        return true
    }

    /// Syncs all spaces
    /// - Returns: A boolean indicating success or failure
    public func syncAllSpaces() -> Bool {
        // Get all enabled configurations
        let enabledConfigurations = syncConfigurations.filter { $0.isEnabled }

        // Sync each space
        for configuration in enabledConfigurations {
            syncQueue.async {
                self.performSync(configuration: configuration)
            }
        }

        return true
    }

    /// Performs the sync operation
    /// - Parameter configuration: The sync configuration
    private func performSync(configuration: SyncConfiguration) {
        // Get the space path
        let spacePath = configuration.spacePath

        // Get the remote path
        let remotePath = configuration.remotePath

        // Get the sync direction
        let direction = configuration.direction

        // Get the file system
        let fileSystem = AugmentFileSystem.shared

        // Get the version control
        let versionControl = VersionControl.shared

        // Get the space
        guard let space = fileSystem.getSpace(path: spacePath) else { return }

        // Get all files in the space
        guard
            let fileEnumerator = FileManager.default.enumerator(
                at: spacePath, includingPropertiesForKeys: nil)
        else { return }

        // Sync each file
        for case let fileURL as URL in fileEnumerator {
            // Skip directories
            var isDirectory: ObjCBool = false
            guard FileManager.default.fileExists(atPath: fileURL.path, isDirectory: &isDirectory),
                !isDirectory.boolValue
            else { continue }

            // Skip hidden files and the .augment directory
            if fileURL.lastPathComponent.starts(with: ".") || fileURL.path.contains("/.augment/") {
                continue
            }

            // Get the relative path
            let relativePath = fileURL.path.replacingOccurrences(of: spacePath.path, with: "")

            // Get the remote file path
            let remoteFilePath = URL(fileURLWithPath: remotePath.path + relativePath)

            // Sync the file
            syncFile(localPath: fileURL, remotePath: remoteFilePath, direction: direction)
        }
    }

    /// Syncs a file
    /// - Parameters:
    ///   - localPath: The local path
    ///   - remotePath: The remote path
    ///   - direction: The sync direction
    private func syncFile(localPath: URL, remotePath: URL, direction: SyncDirection) {
        // Check if the remote file exists
        let remoteExists = FileManager.default.fileExists(atPath: remotePath.path)

        // Get the local file attributes
        guard
            let localAttributes = try? FileManager.default.attributesOfItem(atPath: localPath.path)
        else { return }

        // Get the local modification date
        guard let localModificationDate = localAttributes[.modificationDate] as? Date else {
            return
        }

        // Get the remote file attributes
        let remoteAttributes = try? FileManager.default.attributesOfItem(atPath: remotePath.path)

        // Get the remote modification date
        let remoteModificationDate = remoteAttributes?[.modificationDate] as? Date

        // Sync based on direction
        switch direction {
        case .localToRemote:
            // Local to remote
            if !remoteExists
                || (remoteModificationDate != nil
                    && localModificationDate > remoteModificationDate!)
            {
                // Create the remote directory if it doesn't exist
                let remoteDirectory = remotePath.deletingLastPathComponent()
                try? FileManager.default.createDirectory(
                    at: remoteDirectory, withIntermediateDirectories: true)

                // Copy the file
                try? FileManager.default.copyItem(at: localPath, to: remotePath)
            }
        case .remoteToLocal:
            // Remote to local
            if remoteExists
                && (remoteModificationDate != nil
                    && (localModificationDate < remoteModificationDate!))
            {
                // Copy the file
                try? FileManager.default.copyItem(at: remotePath, to: localPath)
            }
        case .bidirectional:
            // Bidirectional
            if !remoteExists {
                // Create the remote directory if it doesn't exist
                let remoteDirectory = remotePath.deletingLastPathComponent()
                try? FileManager.default.createDirectory(
                    at: remoteDirectory, withIntermediateDirectories: true)

                // Copy the file
                try? FileManager.default.copyItem(at: localPath, to: remotePath)
            } else if remoteModificationDate != nil {
                // Check for conflicts (both files modified since last sync)
                if abs(localModificationDate.timeIntervalSince(remoteModificationDate!)) < 1.0 {
                    // Files are essentially the same time, no conflict
                    return
                } else if localModificationDate > remoteModificationDate! {
                    // Local is newer, copy local to remote
                    try? FileManager.default.removeItem(at: remotePath)
                    try? FileManager.default.copyItem(at: localPath, to: remotePath)
                } else if localModificationDate < remoteModificationDate! {
                    // Remote is newer, but check for conflicts first
                    let conflictManager = ConflictManager.shared
                    let conflicts = conflictManager.detectConflicts(for: localPath)
                    if !conflicts.isEmpty {
                        // Conflict detected, don't overwrite
                        print("Conflict detected for file: \(localPath.path)")
                        return
                    }

                    // No conflict, copy remote to local
                    try? FileManager.default.removeItem(at: localPath)
                    try? FileManager.default.copyItem(at: remotePath, to: localPath)
                }
            }
        }
    }

    /// Finds the space path for a given file
    /// - Parameter filePath: The path to the file
    /// - Returns: The space path if found, nil otherwise
    private func findSpacePath(for filePath: URL) -> URL? {
        var currentPath = filePath.deletingLastPathComponent()

        while currentPath.path != "/" {
            let augmentDir = currentPath.appendingPathComponent(".augment")
            if FileManager.default.fileExists(atPath: augmentDir.path) {
                return currentPath
            }
            currentPath = currentPath.deletingLastPathComponent()
        }

        return nil
    }

    /// Saves the sync configurations to disk
    private func saveConfigurations() {
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

        // Save the configurations file
        let configurationsFile = augmentDir.appendingPathComponent("sync_configurations.json")
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let data = try encoder.encode(syncConfigurations)
            try data.write(to: configurationsFile)
        } catch {
            print("Error saving configurations: \(error)")
        }
    }

    /// Loads the sync configurations from disk
    private func loadConfigurations() {
        // Get the application support directory
        guard
            let appSupportDir = FileManager.default.urls(
                for: .applicationSupportDirectory, in: .userDomainMask
            ).first
        else {
            return
        }

        // Get the configurations file
        let configurationsFile = appSupportDir.appendingPathComponent(
            "Augment/sync_configurations.json")

        // Check if the file exists
        guard FileManager.default.fileExists(atPath: configurationsFile.path) else { return }

        // Read the file
        do {
            let data = try Data(contentsOf: configurationsFile)

            // Decode the configurations
            let decoder = JSONDecoder()
            syncConfigurations = try decoder.decode([SyncConfiguration].self, from: data)
        } catch {
            print("Error loading configurations: \(error)")
        }
    }
}

/// Represents a sync configuration
public struct SyncConfiguration: Identifiable, Codable, Hashable {
    /// Unique identifier for the configuration
    public let id: UUID

    /// The path to the Augment space
    public let spacePath: URL

    /// The remote path
    public let remotePath: URL

    /// The sync direction
    public let direction: SyncDirection

    /// The sync frequency
    public let frequency: SyncFrequency

    /// Whether the configuration is enabled
    public var isEnabled: Bool

    /// The last sync timestamp
    public var lastSyncTimestamp: Date?

    /// Coding keys for encoding and decoding
    enum CodingKeys: String, CodingKey {
        case id
        case spacePath
        case remotePath
        case direction
        case frequency
        case isEnabled
        case lastSyncTimestamp
    }

    /// Initializes a new sync configuration
    /// - Parameters:
    ///   - id: The unique identifier for the configuration
    ///   - spacePath: The path to the Augment space
    ///   - remotePath: The remote path
    ///   - direction: The sync direction
    ///   - frequency: The sync frequency
    ///   - isEnabled: Whether the configuration is enabled
    ///   - lastSyncTimestamp: The last sync timestamp
    public init(
        id: UUID, spacePath: URL, remotePath: URL, direction: SyncDirection,
        frequency: SyncFrequency, isEnabled: Bool = true, lastSyncTimestamp: Date? = nil
    ) {
        self.id = id
        self.spacePath = spacePath
        self.remotePath = remotePath
        self.direction = direction
        self.frequency = frequency
        self.isEnabled = isEnabled
        self.lastSyncTimestamp = lastSyncTimestamp
    }

    /// Encodes the configuration to a decoder
    /// - Parameter encoder: The encoder
    /// - Throws: An error if encoding fails
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(spacePath.path, forKey: .spacePath)
        try container.encode(remotePath.path, forKey: .remotePath)
        try container.encode(direction, forKey: .direction)
        try container.encode(frequency, forKey: .frequency)
        try container.encode(isEnabled, forKey: .isEnabled)
        try container.encode(lastSyncTimestamp, forKey: .lastSyncTimestamp)
    }

    /// Initializes a configuration from a decoder
    /// - Parameter decoder: The decoder
    /// - Throws: An error if decoding fails
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        let spacePathString = try container.decode(String.self, forKey: .spacePath)
        spacePath = URL(fileURLWithPath: spacePathString)
        let remotePathString = try container.decode(String.self, forKey: .remotePath)
        remotePath = URL(fileURLWithPath: remotePathString)
        direction = try container.decode(SyncDirection.self, forKey: .direction)
        frequency = try container.decode(SyncFrequency.self, forKey: .frequency)
        isEnabled = try container.decode(Bool.self, forKey: .isEnabled)
        lastSyncTimestamp = try container.decode(Date?.self, forKey: .lastSyncTimestamp)
    }
}

/// The direction of synchronization
public enum SyncDirection: String, Codable {
    /// Local to remote
    case localToRemote

    /// Remote to local
    case remoteToLocal

    /// Bidirectional
    case bidirectional
}

/// The frequency of synchronization
public enum SyncFrequency: String, Codable {
    /// Manual synchronization
    case manual

    /// Hourly synchronization
    case hourly

    /// Daily synchronization
    case daily

    /// Weekly synchronization
    case weekly

    /// The interval in seconds
    public var interval: TimeInterval {
        switch self {
        case .manual:
            return 0
        case .hourly:
            return 60 * 60  // 1 hour
        case .daily:
            return 60 * 60 * 24  // 1 day
        case .weekly:
            return 60 * 60 * 24 * 7  // 1 week
        }
    }
}
