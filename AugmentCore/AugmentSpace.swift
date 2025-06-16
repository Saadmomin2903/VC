import Foundation

/// Represents an Augment space - a monitored directory with version control
public struct AugmentSpace: Identifiable, Codable, Hashable {
    /// Unique identifier for the space
    public let id: UUID

    /// Display name of the space
    public var name: String

    /// File system path to the space directory
    public var path: URL

    /// Date when the space was created
    public let createdDate: Date

    /// Date when the space was last accessed
    public var lastAccessedDate: Date

    /// Whether the space is currently being monitored
    public var isMonitoring: Bool

    /// Settings for this space
    public var settings: SpaceSettings

    /// Initialize a new Augment space
    /// - Parameters:
    ///   - id: Unique identifier (generates new UUID if not provided)
    ///   - name: Display name for the space
    ///   - path: File system path to the directory
    ///   - createdDate: Creation date (defaults to now)
    ///   - isMonitoring: Whether to start monitoring immediately
    public init(
        id: UUID = UUID(),
        name: String,
        path: URL,
        createdDate: Date = Date(),
        isMonitoring: Bool = true
    ) {
        self.id = id
        self.name = name
        self.path = path
        self.createdDate = createdDate
        self.lastAccessedDate = createdDate
        self.isMonitoring = isMonitoring
        self.settings = SpaceSettings()
    }

    /// Update the last accessed date to now
    public mutating func updateLastAccessed() {
        lastAccessedDate = Date()
    }

    /// Get the relative path from the space root to a file
    /// - Parameter filePath: The full file path
    /// - Returns: Relative path string, or nil if file is not in this space
    public func relativePath(for filePath: URL) -> String? {
        guard filePath.path.hasPrefix(path.path) else { return nil }

        let relativePath = String(filePath.path.dropFirst(path.path.count))
        return relativePath.hasPrefix("/") ? String(relativePath.dropFirst()) : relativePath
    }

    /// Check if a file path is within this space
    /// - Parameter filePath: The file path to check
    /// - Returns: True if the file is within this space
    public func contains(filePath: URL) -> Bool {
        return filePath.path.hasPrefix(path.path)
    }
}

/// Settings for an Augment space
public struct SpaceSettings: Codable, Hashable {
    /// Whether to automatically create versions on file changes
    public var autoVersioning: Bool = true

    /// Maximum number of versions to keep per file
    public var maxVersionsPerFile: Int = 50

    /// Whether to monitor subdirectories
    public var monitorSubdirectories: Bool = true

    /// File patterns to exclude from monitoring
    public var excludePatterns: [String] = [
        "*.tmp", "*.temp", "~$*", ".DS_Store", "Thumbs.db",
    ]

    /// Whether to create automatic snapshots
    public var autoSnapshots: Bool = false

    /// Snapshot frequency in hours (0 = disabled)
    public var snapshotFrequencyHours: Int = 24

    /// Whether to enable network sync
    public var networkSyncEnabled: Bool = false

    /// Network sync configuration
    public var syncConfiguration: SimpleSyncConfiguration = SimpleSyncConfiguration()

    // MARK: - Storage Management Settings

    /// Whether storage management is enabled
    public var storageManagementEnabled: Bool = true

    /// Maximum storage size in bytes (0 = unlimited)
    public var maxStorageBytes: Int64 = 10 * 1024 * 1024 * 1024  // 10GB default

    /// Maximum age for versions in days (0 = unlimited)
    public var maxVersionAgeDays: Int = 365  // 1 year default

    /// Storage warning threshold (0.0 to 1.0)
    public var storageWarningThreshold: Double = 0.8  // 80%

    /// Whether to automatically cleanup old versions
    public var autoCleanupEnabled: Bool = true

    /// Cleanup frequency in hours
    public var cleanupFrequencyHours: Int = 24  // Daily cleanup

    /// Whether to show storage notifications
    public var storageNotificationsEnabled: Bool = true

    public init() {}
}

/// Simple network sync configuration for spaces
public struct SimpleSyncConfiguration: Codable, Hashable {
    /// Remote server URL
    public var serverURL: String = ""

    /// Authentication token
    public var authToken: String = ""

    /// Whether to sync automatically
    public var autoSync: Bool = false

    /// Sync frequency in minutes
    public var syncFrequencyMinutes: Int = 60

    public init() {}
}

// MARK: - Hashable Conformance
extension AugmentSpace {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    public static func == (lhs: AugmentSpace, rhs: AugmentSpace) -> Bool {
        return lhs.id == rhs.id
    }
}
