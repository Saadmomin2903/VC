import Foundation
import UserNotifications
import os.log

/// Comprehensive storage management system for Augment
/// Provides disk usage monitoring, cleanup policies, and storage alerts
public class StorageManager {

    // MARK: - Singleton for backward compatibility
    public static let shared = StorageManager()

    // MARK: - Dependencies
    private let fileManager = FileManager.default
    private let userDefaults = UserDefaults.standard
    private let logger = AugmentLogger.shared

    // MARK: - Thread Safety
    private let storageQueue = DispatchQueue(
        label: "com.augment.storagemanager",
        qos: .utility,
        attributes: .concurrent
    )

    // MARK: - Configuration
    private let defaultStoragePolicy = StoragePolicy(
        type: .maxSize(10 * 1024 * 1024 * 1024),  // 10GB default
        enabled: true,
        warningThreshold: 0.8  // 80% warning
    )

    // MARK: - Monitoring State
    private var isMonitoring = false
    private var monitoringTimer: Timer?

    /// Public initializer for dependency injection
    public init() {
        setupNotifications()
    }

    // MARK: - Setup Methods

    private func setupNotifications() {
        // Request notification permissions
        UNUserNotificationCenter.current().requestAuthorization(
            options: [.alert, .sound, .badge]
        ) { granted, error in
            if let error = error {
                self.logger.error(
                    "Failed to request notification permissions: \(error)", category: .storage)
            } else if granted {
                self.logger.info("Notification permissions granted", category: .storage)
            }
        }
    }

    // MARK: - Storage Monitoring

    /// Gets comprehensive disk usage information for a space
    /// - Parameter space: The Augment space to analyze
    /// - Returns: Detailed storage information
    public func getDiskUsage(for space: AugmentSpace) -> StorageInfo {
        return storageQueue.sync {
            let augmentDir = space.path.appendingPathComponent(".augment")

            guard fileManager.fileExists(atPath: augmentDir.path) else {
                return StorageInfo(
                    totalSize: 0,
                    versionCount: 0,
                    oldestVersion: Date(),
                    newestVersion: Date(),
                    spaceUtilization: 0.0,
                    spacePath: space.path,
                    augmentDirectorySize: 0,
                    originalFilesSize: 0
                )
            }

            let augmentSize = calculateDirectorySize(augmentDir)
            let originalSize = calculateDirectorySize(space.path, excluding: [".augment"])
            let versionCount = countVersions(in: augmentDir)
            let (oldestDate, newestDate) = getVersionDateRange(in: augmentDir)

            let utilization = originalSize > 0 ? Double(augmentSize) / Double(originalSize) : 0.0

            return StorageInfo(
                totalSize: augmentSize + originalSize,
                versionCount: versionCount,
                oldestVersion: oldestDate,
                newestVersion: newestDate,
                spaceUtilization: utilization,
                spacePath: space.path,
                augmentDirectorySize: augmentSize,
                originalFilesSize: originalSize
            )
        }
    }

    /// Gets storage information for all spaces
    /// - Parameter spaces: Array of Augment spaces
    /// - Returns: Dictionary mapping space ID to storage info
    public func getDiskUsage(for spaces: [AugmentSpace]) -> [UUID: StorageInfo] {
        return storageQueue.sync {
            var results: [UUID: StorageInfo] = [:]

            for space in spaces {
                results[space.id] = getDiskUsage(for: space)
            }

            return results
        }
    }

    // MARK: - Storage Policy Management

    /// Gets the storage policy for a space
    /// - Parameter spaceId: The space identifier
    /// - Returns: The storage policy for the space
    public func getStoragePolicy(for spaceId: UUID) -> StoragePolicy {
        let key = "storage_policy_\(spaceId.uuidString)"

        if let data = userDefaults.data(forKey: key),
            let policy = try? JSONDecoder().decode(StoragePolicy.self, from: data)
        {
            return policy
        }

        return defaultStoragePolicy
    }

    /// Sets the storage policy for a space
    /// - Parameters:
    ///   - policy: The storage policy to set
    ///   - spaceId: The space identifier
    public func setStoragePolicy(_ policy: StoragePolicy, for spaceId: UUID) {
        let key = "storage_policy_\(spaceId.uuidString)"

        if let data = try? JSONEncoder().encode(policy) {
            userDefaults.set(data, forKey: key)
            logger.info("Storage policy updated for space \(spaceId)", category: .storage)
        }
    }

    /// Enforces storage policy for a space
    /// - Parameters:
    ///   - policy: The storage policy to enforce
    ///   - space: The Augment space
    /// - Returns: Policy enforcement result
    public func enforceStoragePolicy(_ policy: StoragePolicy, for space: AugmentSpace)
        -> PolicyEnforcementResult
    {
        guard policy.enabled else {
            return .skipped("Policy disabled")
        }

        return storageQueue.sync {
            switch policy.type {
            case .maxSize(let maxBytes):
                return enforceMaxSizePolicy(
                    maxBytes, for: space, warningThreshold: policy.warningThreshold)
            case .maxAge(let maxDays):
                return enforceMaxAgePolicy(
                    maxDays, for: space, warningThreshold: policy.warningThreshold)
            case .maxVersions(let maxCount):
                return enforceMaxVersionsPolicy(
                    maxCount, for: space, warningThreshold: policy.warningThreshold)
            }
        }
    }

    // MARK: - Cleanup Operations

    /// Cleans up old versions based on age
    /// - Parameters:
    ///   - interval: Time interval (versions older than this will be removed)
    ///   - space: The Augment space
    /// - Returns: Cleanup result with statistics
    public func cleanupOldVersions(olderThan interval: TimeInterval, in space: AugmentSpace)
        -> CleanupResult
    {
        return storageQueue.sync(flags: .barrier) {
            let cutoffDate = Date().addingTimeInterval(-interval)
            let augmentDir = space.path.appendingPathComponent(".augment")

            var removedCount = 0
            var freedBytes: Int64 = 0
            var errors: [Error] = []

            logger.info(
                "Starting cleanup of versions older than \(cutoffDate) in space \(space.name)",
                category: .storage)

            do {
                let versionDirs = try fileManager.contentsOfDirectory(
                    at: augmentDir, includingPropertiesForKeys: [.creationDateKey], options: [])

                for versionDir in versionDirs {
                    if let creationDate = try? versionDir.resourceValues(forKeys: [.creationDateKey]
                    ).creationDate,
                        creationDate < cutoffDate
                    {

                        let dirSize = calculateDirectorySize(versionDir)

                        do {
                            try fileManager.removeItem(at: versionDir)
                            removedCount += 1
                            freedBytes += dirSize
                            logger.debug(
                                "Removed version directory: \(versionDir.path)", category: .storage)
                        } catch {
                            errors.append(error)
                            logger.error(
                                "Failed to remove version directory \(versionDir.path): \(error)",
                                category: .storage)
                        }
                    }
                }
            } catch {
                errors.append(error)
                logger.error(
                    "Failed to enumerate version directories: \(error)", category: .storage)
            }

            let result = CleanupResult(
                removedVersions: removedCount,
                freedBytes: freedBytes,
                errors: errors
            )

            logger.info(
                "Cleanup completed: removed \(removedCount) versions, freed \(ByteCountFormatter.string(fromByteCount: freedBytes, countStyle: .file))",
                category: .storage)

            return result
        }
    }

    // MARK: - User Alerts

    /// Alerts user of storage issues via native notifications
    /// - Parameters:
    ///   - space: The affected space
    ///   - issue: The storage issue type
    public func alertUserOfStorageIssues(for space: AugmentSpace, issue: StorageIssue) {
        let content = UNMutableNotificationContent()
        content.title = "Augment Storage Warning"
        content.sound = .default

        switch issue {
        case .approachingLimit(let percentage):
            content.body = "Storage for '\(space.name)' is \(Int(percentage * 100))% full"
            content.categoryIdentifier = "STORAGE_WARNING"
        case .limitExceeded:
            content.body = "Storage limit exceeded for '\(space.name)'. Cleanup recommended."
            content.categoryIdentifier = "STORAGE_CRITICAL"
        case .diskSpaceLow(let availableBytes):
            let formatter = ByteCountFormatter()
            formatter.countStyle = .file
            content.body =
                "Low disk space: \(formatter.string(fromByteCount: availableBytes)) remaining"
            content.categoryIdentifier = "DISK_SPACE_LOW"
        }

        let request = UNNotificationRequest(
            identifier: "storage_\(space.id.uuidString)_\(Date().timeIntervalSince1970)",
            content: content,
            trigger: nil
        )

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                self.logger.error(
                    "Failed to schedule storage notification: \(error)", category: .storage)
            } else {
                self.logger.info(
                    "Storage notification scheduled for space \(space.name)", category: .storage)
            }
        }
    }

    // MARK: - Monitoring Control

    /// Starts automatic storage monitoring
    /// - Parameter interval: Monitoring interval in seconds
    public func startMonitoring(interval: TimeInterval = 300) {  // 5 minutes default
        guard !isMonitoring else {
            logger.warning("Storage monitoring is already running", category: .storage)
            return
        }

        isMonitoring = true

        DispatchQueue.main.async {
            self.monitoringTimer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) {
                _ in
                self.performStorageCheck()
            }
        }

        logger.info("Storage monitoring started with \(interval)s interval", category: .storage)
    }

    /// Stops automatic storage monitoring
    public func stopMonitoring() {
        guard isMonitoring else { return }

        monitoringTimer?.invalidate()
        monitoringTimer = nil
        isMonitoring = false

        logger.info("Storage monitoring stopped", category: .storage)
    }

    // MARK: - Private Helper Methods

    private func performStorageCheck() {
        // This would be called by the monitoring timer
        // Implementation would check all spaces and alert if needed
        logger.debug("Performing periodic storage check", category: .storage)
    }

    private func calculateDirectorySize(_ directory: URL, excluding excludePaths: [String] = [])
        -> Int64
    {
        var totalSize: Int64 = 0

        guard
            let enumerator = fileManager.enumerator(
                at: directory,
                includingPropertiesForKeys: [.fileSizeKey, .isDirectoryKey],
                options: [.skipsHiddenFiles]
            )
        else {
            return 0
        }

        for case let fileURL as URL in enumerator {
            // Skip excluded paths
            let relativePath = fileURL.lastPathComponent
            if excludePaths.contains(relativePath) {
                enumerator.skipDescendants()
                continue
            }

            do {
                let resourceValues = try fileURL.resourceValues(forKeys: [
                    .fileSizeKey, .isDirectoryKey,
                ])

                if let isDirectory = resourceValues.isDirectory, !isDirectory,
                    let fileSize = resourceValues.fileSize
                {
                    totalSize += Int64(fileSize)
                }
            } catch {
                logger.warning(
                    "Failed to get file size for \(fileURL.path): \(error)", category: .storage)
            }
        }

        return totalSize
    }

    private func countVersions(in directory: URL) -> Int {
        do {
            let contents = try fileManager.contentsOfDirectory(
                at: directory, includingPropertiesForKeys: nil, options: [])
            return contents.count
        } catch {
            logger.warning(
                "Failed to count versions in \(directory.path): \(error)", category: .storage)
            return 0
        }
    }

    private func getVersionDateRange(in directory: URL) -> (oldest: Date, newest: Date) {
        var oldestDate = Date()
        var newestDate = Date.distantPast

        do {
            let contents = try fileManager.contentsOfDirectory(
                at: directory,
                includingPropertiesForKeys: [.creationDateKey],
                options: []
            )

            for url in contents {
                if let creationDate = try? url.resourceValues(forKeys: [.creationDateKey])
                    .creationDate
                {
                    if creationDate < oldestDate {
                        oldestDate = creationDate
                    }
                    if creationDate > newestDate {
                        newestDate = creationDate
                    }
                }
            }
        } catch {
            logger.warning("Failed to get version date range: \(error)", category: .storage)
        }

        return (oldestDate, newestDate)
    }

    // MARK: - Policy Enforcement Implementation

    private func enforceMaxSizePolicy(
        _ maxBytes: Int64, for space: AugmentSpace, warningThreshold: Double
    ) -> PolicyEnforcementResult {
        let storageInfo = getDiskUsage(for: space)
        let currentUsage = Double(storageInfo.augmentDirectorySize) / Double(maxBytes)

        if currentUsage >= 1.0 {
            // Exceeded limit - perform cleanup
            let cleanupResult = cleanupOldVersions(olderThan: 30 * 24 * 3600, in: space)  // 30 days
            alertUserOfStorageIssues(for: space, issue: .limitExceeded)

            return .enforced(
                "Cleaned up \(cleanupResult.removedVersions) versions, freed \(ByteCountFormatter.string(fromByteCount: cleanupResult.freedBytes, countStyle: .file))"
            )
        } else if currentUsage >= warningThreshold {
            // Approaching limit - warn user
            alertUserOfStorageIssues(for: space, issue: .approachingLimit(currentUsage))
            return .warning("Storage usage at \(Int(currentUsage * 100))% of limit")
        }

        return .compliant("Storage usage within limits")
    }

    private func enforceMaxAgePolicy(
        _ maxDays: Int, for space: AugmentSpace, warningThreshold: Double
    ) -> PolicyEnforcementResult {
        let maxAge = TimeInterval(maxDays * 24 * 3600)
        let cleanupResult = cleanupOldVersions(olderThan: maxAge, in: space)

        if cleanupResult.removedVersions > 0 {
            return .enforced("Cleaned up \(cleanupResult.removedVersions) old versions")
        }

        return .compliant("No old versions to clean up")
    }

    private func enforceMaxVersionsPolicy(
        _ maxCount: Int, for space: AugmentSpace, warningThreshold: Double
    ) -> PolicyEnforcementResult {
        let storageInfo = getDiskUsage(for: space)
        let currentCount = storageInfo.versionCount

        if currentCount > maxCount {
            // Need to remove excess versions
            let excessCount = currentCount - maxCount
            // Implementation would remove oldest versions
            return .enforced("Would remove \(excessCount) excess versions")
        } else if Double(currentCount) / Double(maxCount) >= warningThreshold {
            return .warning(
                "Version count at \(Int(Double(currentCount) / Double(maxCount) * 100))% of limit")
        }

        return .compliant("Version count within limits")
    }
}

// MARK: - Supporting Data Structures

/// Comprehensive storage information for a space
public struct StorageInfo {
    /// Total size including original files and versions
    public let totalSize: Int64

    /// Number of versions stored
    public let versionCount: Int

    /// Date of oldest version
    public let oldestVersion: Date

    /// Date of newest version
    public let newestVersion: Date

    /// Storage utilization ratio (versions size / original files size)
    public let spaceUtilization: Double

    /// Path to the space
    public let spacePath: URL

    /// Size of .augment directory (versions)
    public let augmentDirectorySize: Int64

    /// Size of original files
    public let originalFilesSize: Int64

    /// Human-readable storage summary
    public var summary: String {
        let formatter = ByteCountFormatter()
        formatter.countStyle = .file

        return """
            Total: \(formatter.string(fromByteCount: totalSize))
            Versions: \(formatter.string(fromByteCount: augmentDirectorySize)) (\(versionCount) versions)
            Original: \(formatter.string(fromByteCount: originalFilesSize))
            Utilization: \(String(format: "%.1f", spaceUtilization * 100))%
            """
    }
}

/// Storage policy configuration
public struct StoragePolicy: Codable {
    /// Policy type and limits
    public let type: PolicyType

    /// Whether the policy is enabled
    public let enabled: Bool

    /// Warning threshold (0.0 to 1.0)
    public let warningThreshold: Double

    public enum PolicyType: Codable {
        case maxSize(Int64)  // Maximum size in bytes
        case maxAge(Int)  // Maximum age in days
        case maxVersions(Int)  // Maximum number of versions
    }
}

/// Result of policy enforcement
public enum PolicyEnforcementResult {
    case compliant(String)  // Policy is being followed
    case warning(String)  // Approaching limits
    case enforced(String)  // Action was taken
    case skipped(String)  // Policy was skipped
}

/// Storage issue types for user alerts
public enum StorageIssue {
    case approachingLimit(Double)  // Percentage of limit reached
    case limitExceeded  // Limit has been exceeded
    case diskSpaceLow(Int64)  // Available disk space in bytes
}

/// Result of cleanup operations
public struct CleanupResult {
    /// Number of versions removed
    public let removedVersions: Int

    /// Bytes freed by cleanup
    public let freedBytes: Int64

    /// Any errors encountered during cleanup
    public let errors: [Error]

    /// Whether cleanup was successful
    public var isSuccessful: Bool {
        return errors.isEmpty
    }

    /// Human-readable summary
    public var summary: String {
        let formatter = ByteCountFormatter()
        formatter.countStyle = .file

        if isSuccessful {
            return
                "Removed \(removedVersions) versions, freed \(formatter.string(fromByteCount: freedBytes))"
        } else {
            return "Partial cleanup: \(removedVersions) versions removed, \(errors.count) errors"
        }
    }
}
