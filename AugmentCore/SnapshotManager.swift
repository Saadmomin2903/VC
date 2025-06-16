import Foundation

/// Manages snapshots for Augment spaces
public class SnapshotManager {
    /// Singleton instance
    public static let shared = SnapshotManager()

    /// The snapshot scheduler
    private var scheduler: SnapshotScheduler

    /// Private initializer for singleton pattern
    private init() {
        scheduler = SnapshotScheduler()
        loadSchedules()
    }

    /// Creates a snapshot of a space
    /// - Parameters:
    ///   - spacePath: The path to the Augment space
    ///   - name: The name of the snapshot
    ///   - description: An optional description of the snapshot
    /// - Returns: The created snapshot if successful, nil otherwise
    public func createSnapshot(spacePath: URL, name: String, description: String? = nil)
        -> Snapshot?
    {
        // Create a new snapshot
        let snapshot = Snapshot(
            id: UUID(),
            spacePath: spacePath,
            name: name,
            description: description,
            timestamp: Date(),
            files: []
        )

        // Get all files in the space
        guard
            let fileEnumerator = FileManager.default.enumerator(
                at: spacePath, includingPropertiesForKeys: nil)
        else { return nil }

        // Add each file to the snapshot
        var snapshotFiles: [SnapshotFile] = []

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

            // Get the file attributes
            guard let attributes = try? FileManager.default.attributesOfItem(atPath: fileURL.path)
            else { continue }

            // Get the file size
            guard let fileSize = attributes[.size] as? UInt64 else { continue }

            // Get the modification date
            guard let modificationDate = attributes[.modificationDate] as? Date else { continue }

            // Create a snapshot file
            let snapshotFile = SnapshotFile(
                id: UUID(),
                filePath: fileURL,
                relativePath: fileURL.path.replacingOccurrences(of: spacePath.path, with: ""),
                size: fileSize,
                modificationDate: modificationDate
            )

            snapshotFiles.append(snapshotFile)
        }

        // Update the snapshot with the files
        var updatedSnapshot = snapshot
        updatedSnapshot.files = snapshotFiles

        // Save the snapshot
        if saveSnapshot(updatedSnapshot) {
            return updatedSnapshot
        } else {
            return nil
        }
    }

    /// Gets all snapshots for a space
    /// - Parameter spacePath: The path to the Augment space
    /// - Returns: An array of snapshots
    public func getSnapshots(spacePath: URL) -> [Snapshot] {
        // Get the snapshots directory
        let snapshotsDir = spacePath.appendingPathComponent(".augment/snapshots")

        // Check if the directory exists
        guard FileManager.default.fileExists(atPath: snapshotsDir.path) else { return [] }

        // Get all snapshot files
        guard
            let snapshotFiles = try? FileManager.default.contentsOfDirectory(
                at: snapshotsDir, includingPropertiesForKeys: nil)
        else { return [] }

        // Load each snapshot
        var snapshots: [Snapshot] = []

        for snapshotFile in snapshotFiles {
            if snapshotFile.pathExtension == "json" {
                if let snapshot = loadSnapshot(snapshotFile) {
                    snapshots.append(snapshot)
                }
            }
        }

        // Sort by timestamp (newest first)
        snapshots.sort { $0.timestamp > $1.timestamp }

        return snapshots
    }

    /// Restores a snapshot
    /// - Parameter snapshot: The snapshot to restore
    /// - Returns: A boolean indicating success or failure
    public func restoreSnapshot(snapshot: Snapshot) -> Bool {
        // TODO: Implement snapshot restoration
        // This is a placeholder for the actual implementation

        // Get the version control manager
        let versionControl = VersionControl.shared

        // Restore each file in the snapshot
        for file in snapshot.files {
            // Get the full path
            let filePath = snapshot.spacePath.appendingPathComponent(file.relativePath)

            // Get the versions of the file
            let versions = versionControl.getVersions(filePath: filePath)

            // Find the version closest to the snapshot timestamp
            let closestVersion = versions.min {
                abs($0.timestamp.timeIntervalSince(snapshot.timestamp))
                    < abs($1.timestamp.timeIntervalSince(snapshot.timestamp))
            }

            // Restore the version
            if let version = closestVersion {
                _ = versionControl.restoreVersion(filePath: filePath, version: version)
            }
        }

        return true
    }

    /// Deletes a snapshot
    /// - Parameter snapshot: The snapshot to delete
    /// - Returns: A boolean indicating success or failure
    public func deleteSnapshot(snapshot: Snapshot) -> Bool {
        // Get the snapshot file path
        let snapshotFile = snapshot.spacePath.appendingPathComponent(
            ".augment/snapshots/\(snapshot.id.uuidString).json")

        // Delete the file
        do {
            try FileManager.default.removeItem(at: snapshotFile)
            return true
        } catch {
            print("Error deleting snapshot: \(error)")
            return false
        }
    }

    /// Schedules automated snapshots for a space
    /// - Parameters:
    ///   - spacePath: The path to the Augment space
    ///   - schedule: The snapshot schedule
    /// - Returns: A boolean indicating success or failure
    public func scheduleSnapshots(spacePath: URL, schedule: SnapshotSchedule) -> Bool {
        // Add the schedule to the scheduler
        scheduler.addSchedule(schedule)

        // Save the schedules
        saveSchedules()

        return true
    }

    /// Gets the snapshot schedule for a space
    /// - Parameter spacePath: The path to the Augment space
    /// - Returns: The snapshot schedule if found, nil otherwise
    public func getSchedule(spacePath: URL) -> SnapshotSchedule? {
        return scheduler.getSchedule(spacePath: spacePath)
    }

    /// Removes the snapshot schedule for a space
    /// - Parameter spacePath: The path to the Augment space
    /// - Returns: A boolean indicating success or failure
    public func removeSchedule(spacePath: URL) -> Bool {
        // Remove the schedule from the scheduler
        scheduler.removeSchedule(spacePath: spacePath)

        // Save the schedules
        saveSchedules()

        return true
    }

    /// Saves a snapshot to disk
    /// - Parameter snapshot: The snapshot to save
    /// - Returns: A boolean indicating success or failure
    private func saveSnapshot(_ snapshot: Snapshot) -> Bool {
        // Get the snapshots directory
        let snapshotsDir = snapshot.spacePath.appendingPathComponent(".augment/snapshots")

        // Create the directory if it doesn't exist
        do {
            try FileManager.default.createDirectory(
                at: snapshotsDir, withIntermediateDirectories: true)
        } catch {
            print("Error creating snapshots directory: \(error)")
            return false
        }

        // Get the snapshot file path
        let snapshotFile = snapshotsDir.appendingPathComponent("\(snapshot.id.uuidString).json")

        // Encode the snapshot
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let data = try encoder.encode(snapshot)

            // Write the file
            try data.write(to: snapshotFile)

            return true
        } catch {
            print("Error saving snapshot: \(error)")
            return false
        }
    }

    /// Loads a snapshot from disk
    /// - Parameter snapshotFile: The path to the snapshot file
    /// - Returns: The loaded snapshot if successful, nil otherwise
    private func loadSnapshot(_ snapshotFile: URL) -> Snapshot? {
        // Read the file
        do {
            let data = try Data(contentsOf: snapshotFile)

            // Decode the snapshot
            let decoder = JSONDecoder()
            return try decoder.decode(Snapshot.self, from: data)
        } catch {
            print("Error loading snapshot: \(error)")
            return nil
        }
    }

    /// Saves the snapshot schedules to disk
    private func saveSchedules() {
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

        // Save the schedules file
        let schedulesFile = augmentDir.appendingPathComponent("snapshot_schedules.json")
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let data = try encoder.encode(scheduler.schedules)
            try data.write(to: schedulesFile)
        } catch {
            print("Error saving schedules: \(error)")
        }
    }

    /// Loads the snapshot schedules from disk
    private func loadSchedules() {
        // Get the application support directory
        guard
            let appSupportDir = FileManager.default.urls(
                for: .applicationSupportDirectory, in: .userDomainMask
            ).first
        else {
            return
        }

        // Get the schedules file
        let schedulesFile = appSupportDir.appendingPathComponent("Augment/snapshot_schedules.json")

        // Check if the file exists
        guard FileManager.default.fileExists(atPath: schedulesFile.path) else { return }

        // Read the file
        do {
            let data = try Data(contentsOf: schedulesFile)

            // Decode the schedules
            let decoder = JSONDecoder()
            let schedules = try decoder.decode([SnapshotSchedule].self, from: data)

            // Set the schedules
            scheduler.schedules = schedules
        } catch {
            print("Error loading schedules: \(error)")
        }
    }
}

/// Represents a snapshot of an Augment space
public struct Snapshot: Identifiable, Codable {
    /// Unique identifier for the snapshot
    public let id: UUID

    /// The path to the Augment space
    public let spacePath: URL

    /// The name of the snapshot
    public let name: String

    /// An optional description of the snapshot
    public let description: String?

    /// The timestamp when the snapshot was created
    public let timestamp: Date

    /// The files in the snapshot
    public var files: [SnapshotFile]

    /// Coding keys for encoding and decoding
    enum CodingKeys: String, CodingKey {
        case id
        case spacePath
        case name
        case description
        case timestamp
        case files
    }

    /// Initializes a new snapshot
    /// - Parameters:
    ///   - id: The unique identifier for the snapshot
    ///   - spacePath: The path to the Augment space
    ///   - name: The name of the snapshot
    ///   - description: An optional description of the snapshot
    ///   - timestamp: The timestamp when the snapshot was created
    ///   - files: The files in the snapshot
    public init(
        id: UUID, spacePath: URL, name: String, description: String?, timestamp: Date,
        files: [SnapshotFile]
    ) {
        self.id = id
        self.spacePath = spacePath
        self.name = name
        self.description = description
        self.timestamp = timestamp
        self.files = files
    }

    /// Encodes the snapshot to a decoder
    /// - Parameter encoder: The encoder
    /// - Throws: An error if encoding fails
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(spacePath.path, forKey: .spacePath)
        try container.encode(name, forKey: .name)
        try container.encode(description, forKey: .description)
        try container.encode(timestamp, forKey: .timestamp)
        try container.encode(files, forKey: .files)
    }

    /// Initializes a snapshot from a decoder
    /// - Parameter decoder: The decoder
    /// - Throws: An error if decoding fails
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        let spacePathString = try container.decode(String.self, forKey: .spacePath)
        spacePath = URL(fileURLWithPath: spacePathString)
        name = try container.decode(String.self, forKey: .name)
        description = try container.decode(String?.self, forKey: .description)
        timestamp = try container.decode(Date.self, forKey: .timestamp)
        files = try container.decode([SnapshotFile].self, forKey: .files)
    }
}

/// Represents a file in a snapshot
public struct SnapshotFile: Identifiable, Codable {
    /// Unique identifier for the snapshot file
    public let id: UUID

    /// The path to the file
    public let filePath: URL

    /// The path relative to the space
    public let relativePath: String

    /// The size of the file in bytes
    public let size: UInt64

    /// The modification date of the file
    public let modificationDate: Date

    /// Coding keys for encoding and decoding
    enum CodingKeys: String, CodingKey {
        case id
        case filePath
        case relativePath
        case size
        case modificationDate
    }

    /// Initializes a new snapshot file
    /// - Parameters:
    ///   - id: The unique identifier for the snapshot file
    ///   - filePath: The path to the file
    ///   - relativePath: The path relative to the space
    ///   - size: The size of the file in bytes
    ///   - modificationDate: The modification date of the file
    public init(id: UUID, filePath: URL, relativePath: String, size: UInt64, modificationDate: Date)
    {
        self.id = id
        self.filePath = filePath
        self.relativePath = relativePath
        self.size = size
        self.modificationDate = modificationDate
    }

    /// Encodes the snapshot file to a decoder
    /// - Parameter encoder: The encoder
    /// - Throws: An error if encoding fails
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(filePath.path, forKey: .filePath)
        try container.encode(relativePath, forKey: .relativePath)
        try container.encode(size, forKey: .size)
        try container.encode(modificationDate, forKey: .modificationDate)
    }

    /// Initializes a snapshot file from a decoder
    /// - Parameter decoder: The decoder
    /// - Throws: An error if decoding fails
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        let filePathString = try container.decode(String.self, forKey: .filePath)
        filePath = URL(fileURLWithPath: filePathString)
        relativePath = try container.decode(String.self, forKey: .relativePath)
        size = try container.decode(UInt64.self, forKey: .size)
        modificationDate = try container.decode(Date.self, forKey: .modificationDate)
    }
}

/// Represents a snapshot schedule
public struct SnapshotSchedule: Identifiable, Codable {
    /// Unique identifier for the schedule
    public let id: UUID

    /// The path to the Augment space
    public let spacePath: URL

    /// The frequency of snapshots
    public let frequency: SnapshotFrequency

    /// The retention policy
    public let retention: SnapshotRetention

    /// Whether the schedule is enabled
    public var isEnabled: Bool

    /// The last snapshot timestamp
    public var lastSnapshotTimestamp: Date?

    /// Coding keys for encoding and decoding
    enum CodingKeys: String, CodingKey {
        case id
        case spacePath
        case frequency
        case retention
        case isEnabled
        case lastSnapshotTimestamp
    }

    /// Initializes a new snapshot schedule
    /// - Parameters:
    ///   - id: The unique identifier for the schedule
    ///   - spacePath: The path to the Augment space
    ///   - frequency: The frequency of snapshots
    ///   - retention: The retention policy
    ///   - isEnabled: Whether the schedule is enabled
    ///   - lastSnapshotTimestamp: The last snapshot timestamp
    public init(
        id: UUID, spacePath: URL, frequency: SnapshotFrequency, retention: SnapshotRetention,
        isEnabled: Bool = true, lastSnapshotTimestamp: Date? = nil
    ) {
        self.id = id
        self.spacePath = spacePath
        self.frequency = frequency
        self.retention = retention
        self.isEnabled = isEnabled
        self.lastSnapshotTimestamp = lastSnapshotTimestamp
    }

    /// Encodes the schedule to a decoder
    /// - Parameter encoder: The encoder
    /// - Throws: An error if encoding fails
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(spacePath.path, forKey: .spacePath)
        try container.encode(frequency, forKey: .frequency)
        try container.encode(retention, forKey: .retention)
        try container.encode(isEnabled, forKey: .isEnabled)
        try container.encode(lastSnapshotTimestamp, forKey: .lastSnapshotTimestamp)
    }

    /// Initializes a schedule from a decoder
    /// - Parameter decoder: The decoder
    /// - Throws: An error if decoding fails
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        let spacePathString = try container.decode(String.self, forKey: .spacePath)
        spacePath = URL(fileURLWithPath: spacePathString)
        frequency = try container.decode(SnapshotFrequency.self, forKey: .frequency)
        retention = try container.decode(SnapshotRetention.self, forKey: .retention)
        isEnabled = try container.decode(Bool.self, forKey: .isEnabled)
        lastSnapshotTimestamp = try container.decode(Date?.self, forKey: .lastSnapshotTimestamp)
    }
}

/// The frequency of snapshots
public enum SnapshotFrequency: String, Codable {
    /// Hourly snapshots
    case hourly

    /// Daily snapshots
    case daily

    /// Weekly snapshots
    case weekly

    /// Monthly snapshots
    case monthly

    /// The interval in seconds
    public var interval: TimeInterval {
        switch self {
        case .hourly:
            return 60 * 60  // 1 hour
        case .daily:
            return 60 * 60 * 24  // 1 day
        case .weekly:
            return 60 * 60 * 24 * 7  // 1 week
        case .monthly:
            return 60 * 60 * 24 * 30  // 30 days (approximate)
        }
    }
}

/// The retention policy for snapshots
public enum SnapshotRetention: Codable {
    /// Keep all snapshots
    case keepAll

    /// Keep a limited number of snapshots
    case keepLimited(Int)

    /// Keep snapshots for a limited time
    case keepForTime(TimeInterval)

    /// Coding keys for encoding and decoding
    private enum CodingKeys: String, CodingKey {
        case type
        case value
    }

    /// Encodes the retention policy to a decoder
    /// - Parameter encoder: The encoder
    /// - Throws: An error if encoding fails
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        switch self {
        case .keepAll:
            try container.encode("keepAll", forKey: .type)
            try container.encode(0, forKey: .value)
        case .keepLimited(let count):
            try container.encode("keepLimited", forKey: .type)
            try container.encode(count, forKey: .value)
        case .keepForTime(let time):
            try container.encode("keepForTime", forKey: .type)
            try container.encode(time, forKey: .value)
        }
    }

    /// Initializes a retention policy from a decoder
    /// - Parameter decoder: The decoder
    /// - Throws: An error if decoding fails
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(String.self, forKey: .type)
        let value = try container.decode(Double.self, forKey: .value)

        switch type {
        case "keepAll":
            self = .keepAll
        case "keepLimited":
            self = .keepLimited(Int(value))
        case "keepForTime":
            self = .keepForTime(value)
        default:
            self = .keepAll
        }
    }
}

/// Schedules and executes automated snapshots
class SnapshotScheduler {
    /// The list of snapshot schedules
    var schedules: [SnapshotSchedule] = []

    /// The timer for executing snapshots
    private var timer: Timer?

    /// Initializes a new snapshot scheduler
    init() {
        // Start the scheduler
        startScheduler()
    }

    /// Starts the scheduler
    private func startScheduler() {
        // Stop any existing timer
        timer?.invalidate()

        // Create a new timer that runs every hour
        timer = Timer.scheduledTimer(withTimeInterval: 60 * 60, repeats: true) { [weak self] _ in
            self?.executeScheduledSnapshots()
        }
    }

    /// Executes scheduled snapshots
    private func executeScheduledSnapshots() {
        // Get the current date
        let now = Date()

        // Check each schedule
        for (index, schedule) in schedules.enumerated() {
            // Skip disabled schedules
            guard schedule.isEnabled else { continue }

            // Check if it's time for a snapshot
            if let lastSnapshot = schedule.lastSnapshotTimestamp {
                let timeSinceLastSnapshot = now.timeIntervalSince(lastSnapshot)

                if timeSinceLastSnapshot >= schedule.frequency.interval {
                    // Create a snapshot
                    createScheduledSnapshot(schedule: schedule)

                    // Update the last snapshot timestamp
                    schedules[index].lastSnapshotTimestamp = now
                }
            } else {
                // No previous snapshot, create one
                createScheduledSnapshot(schedule: schedule)

                // Update the last snapshot timestamp
                schedules[index].lastSnapshotTimestamp = now
            }
        }
    }

    /// Creates a scheduled snapshot
    /// - Parameter schedule: The snapshot schedule
    private func createScheduledSnapshot(schedule: SnapshotSchedule) {
        // Create a snapshot name based on the current date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let snapshotName = "Scheduled Snapshot - \(dateFormatter.string(from: Date()))"

        // Create the snapshot
        _ = SnapshotManager.shared.createSnapshot(
            spacePath: schedule.spacePath,
            name: snapshotName,
            description: "Automatically created by scheduler"
        )

        // Apply retention policy
        applyRetentionPolicy(schedule: schedule)
    }

    /// Applies the retention policy to snapshots
    /// - Parameter schedule: The snapshot schedule
    private func applyRetentionPolicy(schedule: SnapshotSchedule) {
        // Get all snapshots for the space
        let snapshots = SnapshotManager.shared.getSnapshots(spacePath: schedule.spacePath)

        // Apply the retention policy
        switch schedule.retention {
        case .keepAll:
            // Keep all snapshots
            break
        case .keepLimited(let count):
            // Keep only the specified number of snapshots
            if snapshots.count > count {
                // Get the snapshots to delete
                let snapshotsToDelete = snapshots.suffix(from: count)

                // Delete each snapshot
                for snapshot in snapshotsToDelete {
                    _ = SnapshotManager.shared.deleteSnapshot(snapshot: snapshot)
                }
            }
        case .keepForTime(let time):
            // Keep snapshots for the specified time
            let cutoffDate = Date().addingTimeInterval(-time)

            // Get the snapshots to delete
            let snapshotsToDelete = snapshots.filter { $0.timestamp < cutoffDate }

            // Delete each snapshot
            for snapshot in snapshotsToDelete {
                _ = SnapshotManager.shared.deleteSnapshot(snapshot: snapshot)
            }
        }
    }

    /// Adds a snapshot schedule
    /// - Parameter schedule: The snapshot schedule
    func addSchedule(_ schedule: SnapshotSchedule) {
        // Remove any existing schedule for the same space
        removeSchedule(spacePath: schedule.spacePath)

        // Add the new schedule
        schedules.append(schedule)
    }

    /// Gets the snapshot schedule for a space
    /// - Parameter spacePath: The path to the Augment space
    /// - Returns: The snapshot schedule if found, nil otherwise
    func getSchedule(spacePath: URL) -> SnapshotSchedule? {
        return schedules.first { $0.spacePath == spacePath }
    }

    /// Removes the snapshot schedule for a space
    /// - Parameter spacePath: The path to the Augment space
    func removeSchedule(spacePath: URL) {
        schedules.removeAll { $0.spacePath == spacePath }
    }
}
