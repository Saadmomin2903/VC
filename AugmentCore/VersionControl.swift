import CryptoKit
import Foundation

// MARK: - Error Types

/// Errors that can occur in version control operations
public enum VersionControlError: Error {
    case invalidPath(String)
    case invalidVersion(String)
    case restorationFailed(String)
    case rollbackFailed(String)
    case metadataCorrupted(String)

    var localizedDescription: String {
        switch self {
        case .invalidPath(let message):
            return "Invalid path: \(message)"
        case .invalidVersion(let message):
            return "Invalid version: \(message)"
        case .restorationFailed(let message):
            return "Restoration failed: \(message)"
        case .rollbackFailed(let message):
            return "Rollback failed: \(message)"
        case .metadataCorrupted(let message):
            return "Metadata corrupted: \(message)"
        }
    }
}

// MARK: - Core Data Models

/// Represents a version of an individual file
public struct FileVersion: Identifiable, Codable, Hashable {
    /// Unique identifier for the version
    public let id: UUID

    /// The path to the file
    public let filePath: URL

    /// The timestamp when the version was created
    public let timestamp: Date

    /// The size of the file in bytes
    public let size: UInt64

    /// Optional comment for the version
    public let comment: String?

    /// The content hash of the file
    public let contentHash: String

    /// The path to the stored version data
    public let storagePath: URL

    /// Coding keys for encoding and decoding
    enum CodingKeys: String, CodingKey {
        case id
        case filePath
        case timestamp
        case size
        case comment
        case contentHash
        case storagePath
    }

    /// Initializes a new file version
    public init(
        id: UUID, filePath: URL, timestamp: Date, size: UInt64, comment: String?,
        contentHash: String, storagePath: URL
    ) {
        self.id = id
        self.filePath = filePath
        self.timestamp = timestamp
        self.size = size
        self.comment = comment
        self.contentHash = contentHash
        self.storagePath = storagePath
    }

    // MARK: - Hashable conformance
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    public static func == (lhs: FileVersion, rhs: FileVersion) -> Bool {
        return lhs.id == rhs.id
    }

    /// Encodes the file version
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(filePath.path, forKey: .filePath)
        try container.encode(timestamp, forKey: .timestamp)
        try container.encode(size, forKey: .size)
        try container.encode(comment, forKey: .comment)
        try container.encode(contentHash, forKey: .contentHash)
        try container.encode(storagePath.path, forKey: .storagePath)
    }

    /// Initializes a file version from a decoder
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        let filePathString = try container.decode(String.self, forKey: .filePath)
        filePath = URL(fileURLWithPath: filePathString)
        timestamp = try container.decode(Date.self, forKey: .timestamp)
        size = try container.decode(UInt64.self, forKey: .size)
        comment = try container.decodeIfPresent(String.self, forKey: .comment)
        contentHash = try container.decode(String.self, forKey: .contentHash)
        let storagePathString = try container.decode(String.self, forKey: .storagePath)
        storagePath = URL(fileURLWithPath: storagePathString)
    }
}

/// Represents the type of diff between two versions
public enum DiffType: String, Codable {
    /// Text-based diff
    case text

    /// Image comparison
    case image

    /// Binary file comparison
    case binary

    /// No differences
    case none
}

/// Represents a diff between two file versions
public struct FileDiff {
    /// The source version
    public let fromVersion: FileVersion

    /// The target version
    public let toVersion: FileVersion

    /// The type of diff
    public let diffType: DiffType

    /// The diff data
    public let diffData: Data

    /// Initializes a new file diff
    public init(
        fromVersion: FileVersion, toVersion: FileVersion, diffType: DiffType, diffData: Data
    ) {
        self.fromVersion = fromVersion
        self.toVersion = toVersion
        self.diffType = diffType
        self.diffData = diffData
    }
}

/// The main class responsible for version control operations
public class VersionControl {
    /// Singleton instance - DEPRECATED: Use dependency injection instead
    @available(*, deprecated, message: "Use dependency injection instead of singleton pattern")
    public static let shared = VersionControl()

    private let fileManager = FileManager.default
    private let metadataManager: MetadataManager

    /// Public initializer for dependency injection
    public init(metadataManager: MetadataManager = MetadataManager()) {
        self.metadataManager = metadataManager
    }

    /// Initializes version control for a folder
    /// - Parameter folderPath: The path to the folder to version control
    /// - Returns: A boolean indicating success or failure
    public func initializeVersionControl(folderPath: URL) -> Bool {
        do {
            let augmentDir = folderPath.appendingPathComponent(".augment")
            let versionsDir = augmentDir.appendingPathComponent("versions")
            let metadataDir = augmentDir.appendingPathComponent("metadata")

            // CRITICAL FIX: Also create file-specific directories
            let fileVersionsDir = augmentDir.appendingPathComponent("file_versions")
            let fileMetadataDir = augmentDir.appendingPathComponent("file_metadata")

            try fileManager.createDirectory(at: augmentDir, withIntermediateDirectories: true)
            try fileManager.createDirectory(at: versionsDir, withIntermediateDirectories: true)
            try fileManager.createDirectory(at: metadataDir, withIntermediateDirectories: true)

            // CRITICAL FIX: Create file version directories
            try fileManager.createDirectory(at: fileVersionsDir, withIntermediateDirectories: true)
            try fileManager.createDirectory(at: fileMetadataDir, withIntermediateDirectories: true)

            print("✅ VersionControl.initializeVersionControl: Created all required directories")
            print("   📁 Augment dir: \(augmentDir.path)")
            print("   📁 Folder versions: \(versionsDir.path)")
            print("   📁 Folder metadata: \(metadataDir.path)")
            print("   📁 File versions: \(fileVersionsDir.path)")
            print("   📁 File metadata: \(fileMetadataDir.path)")

            // Don't create initial folder version automatically - just ensure directories exist
            return true
        } catch {
            print("Error initializing version control: \(error)")
            return false
        }
    }

    /// Creates a new version of a folder
    /// - Parameters:
    ///   - folderPath: The path to the folder
    ///   - comment: Optional comment for the version
    /// - Returns: The version object if successful, nil otherwise
    public func createVersion(folderPath: URL, comment: String? = nil) -> FolderVersion? {
        do {
            let versionId = UUID()
            let augmentDir = folderPath.appendingPathComponent(".augment")
            let versionsDir = augmentDir.appendingPathComponent("versions")
            let versionDir = versionsDir.appendingPathComponent(versionId.uuidString)

            // Create version directory
            try fileManager.createDirectory(at: versionDir, withIntermediateDirectories: true)

            // Copy all files except .augment directory
            let contents = try fileManager.contentsOfDirectory(
                at: folderPath, includingPropertiesForKeys: nil)
            for file in contents where file.lastPathComponent != ".augment" {
                let relativePath = file.path.replacingOccurrences(of: folderPath.path, with: "")
                let targetPath = versionDir.appendingPathComponent(relativePath)
                try fileManager.createDirectory(
                    at: targetPath.deletingLastPathComponent(), withIntermediateDirectories: true)
                try fileManager.copyItem(at: file, to: targetPath)
            }

            // Create version metadata
            let version = FolderVersion(
                id: versionId,
                folderPath: folderPath,
                timestamp: Date(),
                comment: comment,
                storagePath: versionDir
            )

            // Save metadata
            if metadataManager.saveVersionMetadata(version: version, spacePath: folderPath) {
                return version
            }

            return nil
        } catch {
            print("Error creating version: \(error)")
            return nil
        }
    }

    /// Retrieves all versions of a folder
    /// - Parameter folderPath: The path to the folder
    /// - Returns: An array of folder versions
    public func getVersions(folderPath: URL) -> [FolderVersion] {
        return metadataManager.loadVersionMetadata(folderPath: folderPath, spacePath: folderPath)
    }

    // MARK: - File-Level Version Control

    /// Creates a new version of an individual file
    /// - Parameters:
    ///   - filePath: The path to the file
    ///   - comment: Optional comment for the version
    /// - Returns: The file version if successful, nil otherwise
    public func createFileVersion(filePath: URL, comment: String? = nil) -> FileVersion? {
        // CRITICAL FIX #8: Implement comprehensive error handling with rollback mechanisms
        print("🚀 VersionControl.createFileVersion: STARTING for \(filePath.path)")

        var createdDirectories: [URL] = []
        var createdFiles: [URL] = []

        do {
            // Validate input parameters
            guard !filePath.path.isEmpty else {
                print("❌ VersionControl.createFileVersion: Empty file path provided")
                throw VersionControlError.invalidPath("Empty file path provided")
            }

            // Find the space path for this file
            guard let spacePath = findSpacePath(for: filePath) else {
                print(
                    "❌ VersionControl.createFileVersion: File is not in an Augment space: \(filePath)"
                )
                throw VersionControlError.invalidPath(
                    "File is not in an Augment space: \(filePath)")
            }

            print("✅ VersionControl.createFileVersion: Found space path: \(spacePath.path)")

            // Check if file exists and is readable
            guard fileManager.fileExists(atPath: filePath.path) else {
                throw VersionControlError.invalidPath("File does not exist: \(filePath)")
            }

            // Verify file is readable
            guard fileManager.isReadableFile(atPath: filePath.path) else {
                throw VersionControlError.invalidPath("File is not readable: \(filePath)")
            }

            // Get file attributes with error handling
            let attributes: [FileAttributeKey: Any]
            do {
                attributes = try fileManager.attributesOfItem(atPath: filePath.path)
            } catch {
                throw VersionControlError.invalidPath(
                    "Cannot read file attributes: \(error.localizedDescription)")
            }

            let fileSize = attributes[.size] as? UInt64 ?? 0

            // Calculate content hash with error handling
            let fileData: Data
            do {
                fileData = try Data(contentsOf: filePath)
            } catch {
                throw VersionControlError.invalidPath(
                    "Cannot read file data: \(error.localizedDescription)")
            }

            let contentHash = calculateHash(for: fileData)

            // Create version ID and storage paths
            let versionId = UUID()
            let augmentDir = spacePath.appendingPathComponent(".augment")
            let versionsDir = augmentDir.appendingPathComponent("file_versions")
            let fileId = calculateFilePathHash(filePath: filePath)
            let fileVersionsDir = versionsDir.appendingPathComponent(fileId)
            let versionFile = fileVersionsDir.appendingPathComponent("\(versionId.uuidString).data")

            // Create directories with rollback tracking
            do {
                if !fileManager.fileExists(atPath: fileVersionsDir.path) {
                    try fileManager.createDirectory(
                        at: fileVersionsDir, withIntermediateDirectories: true)
                    createdDirectories.append(fileVersionsDir)
                }
            } catch {
                throw VersionControlError.invalidPath(
                    "Cannot create version directory: \(error.localizedDescription)")
            }

            // Copy file data to version storage with rollback tracking
            do {
                try fileData.write(to: versionFile)
                createdFiles.append(versionFile)
            } catch {
                // Rollback created directories and files
                performFileVersionRollback(directories: createdDirectories, files: createdFiles)
                throw VersionControlError.invalidVersion(
                    "Cannot write version data: \(error.localizedDescription)")
            }

            // Create file version object
            let fileVersion = FileVersion(
                id: versionId,
                filePath: filePath,
                timestamp: Date(),
                size: fileSize,
                comment: comment,
                contentHash: contentHash,
                storagePath: versionFile
            )

            // Save metadata with rollback on failure
            do {
                if !metadataManager.saveFileVersionMetadata(
                    version: fileVersion, spacePath: spacePath)
                {
                    // Rollback created files and directories
                    performFileVersionRollback(directories: createdDirectories, files: createdFiles)
                    throw VersionControlError.metadataCorrupted("Failed to save version metadata")
                }
            } catch {
                // Rollback created files and directories
                performFileVersionRollback(directories: createdDirectories, files: createdFiles)
                throw error
            }

            print(
                "Successfully created file version \(versionId) for \(filePath.lastPathComponent)")
            return fileVersion

        } catch let error as VersionControlError {
            print("VersionControl Error: \(error.localizedDescription)")
            return nil
        } catch {
            print("Unexpected error creating file version: \(error)")
            // Ensure rollback happens for any unexpected errors
            performFileVersionRollback(directories: createdDirectories, files: createdFiles)
            return nil
        }
    }

    /// Performs rollback for file version creation
    /// - Parameters:
    ///   - directories: Directories to remove
    ///   - files: Files to remove
    private func performFileVersionRollback(directories: [URL], files: [URL]) {
        print("VersionControl: Performing rollback for file version creation...")

        // Remove created files first
        for file in files.reversed() {
            do {
                if fileManager.fileExists(atPath: file.path) {
                    try fileManager.removeItem(at: file)
                    print("VersionControl: Rolled back file: \(file.lastPathComponent)")
                }
            } catch {
                print(
                    "VersionControl: Warning - Could not remove file during rollback: \(file.path) - \(error)"
                )
            }
        }

        // Remove created directories (in reverse order)
        for directory in directories.reversed() {
            do {
                if fileManager.fileExists(atPath: directory.path) {
                    // Only remove if directory is empty
                    let contents = try fileManager.contentsOfDirectory(
                        at: directory, includingPropertiesForKeys: nil)
                    if contents.isEmpty {
                        try fileManager.removeItem(at: directory)
                        print(
                            "VersionControl: Rolled back directory: \(directory.lastPathComponent)")
                    }
                }
            } catch {
                print(
                    "VersionControl: Warning - Could not remove directory during rollback: \(directory.path) - \(error)"
                )
            }
        }

        print("VersionControl: Rollback completed")
    }

    /// Async version of createFileVersion for modern Swift concurrency
    /// - Parameters:
    ///   - filePath: The path to the file
    ///   - comment: Optional comment for the version
    /// - Returns: The file version if successful, nil otherwise
    @available(macOS 10.15, *)
    public func createFileVersionAsync(filePath: URL, comment: String? = nil) async -> FileVersion?
    {
        return await withCheckedContinuation { continuation in
            DispatchQueue.global(qos: .utility).async {
                let result = self.createFileVersion(filePath: filePath, comment: comment)
                continuation.resume(returning: result)
            }
        }
    }

    /// Retrieves all versions of a file
    /// - Parameter filePath: The path to the file
    /// - Returns: An array of file versions
    public func getVersions(filePath: URL) -> [FileVersion] {
        print("🔍 VersionControl.getVersions: STARTING for file: \(filePath.path)")

        guard let spacePath = findSpacePath(for: filePath) else {
            print("❌ VersionControl.getVersions: No Augment space found for file: \(filePath.path)")
            print(
                "🔍 VersionControl.getVersions: Searched from \(filePath.deletingLastPathComponent().path) up to root"
            )

            // FALLBACK: Try to initialize version control for the parent directory
            let parentPath = filePath.deletingLastPathComponent()
            print(
                "🔧 VersionControl.getVersions: Attempting to initialize version control for: \(parentPath.path)"
            )

            if initializeVersionControl(folderPath: parentPath) {
                print(
                    "✅ VersionControl.getVersions: Successfully initialized version control, retrying..."
                )
                // Retry after initialization
                if let newSpacePath = findSpacePath(for: filePath) {
                    let retryVersions = metadataManager.loadFileVersionMetadata(
                        filePath: filePath, spacePath: newSpacePath)
                    print(
                        "🔄 VersionControl.getVersions: Retry loaded \(retryVersions.count) versions"
                    )
                    return retryVersions
                }
            } else {
                print(
                    "❌ VersionControl.getVersions: Failed to initialize version control for: \(parentPath.path)"
                )
            }

            print("🚫 VersionControl.getVersions: Returning empty array - no space found")
            return []
        }

        print(
            "✅ VersionControl.getVersions: Found space at \(spacePath.path) for file: \(filePath.lastPathComponent)"
        )

        // Calculate and log the hash being used
        let filePathHash = calculateFilePathHash(filePath: filePath)
        print("🔢 VersionControl.getVersions: Calculated hash: \(filePathHash)")

        let versions = metadataManager.loadFileVersionMetadata(
            filePath: filePath, spacePath: spacePath)
        print(
            "📊 VersionControl.getVersions: Loaded \(versions.count) versions for file: \(filePath.lastPathComponent)"
        )

        if versions.isEmpty {
            print("⚠️ VersionControl.getVersions: No versions found - investigating...")
            let metadataDir = spacePath.appendingPathComponent(".augment/file_metadata")
            let fileMetadataDir = metadataDir.appendingPathComponent(filePathHash)
            print("🔍 VersionControl.getVersions: Looking in directory: \(fileMetadataDir.path)")
            print(
                "🔍 VersionControl.getVersions: Directory exists: \(FileManager.default.fileExists(atPath: fileMetadataDir.path))"
            )
        }

        return versions
    }

    /// Restores a file to a specific version
    /// - Parameters:
    ///   - filePath: The path to the file to restore
    ///   - version: The version to restore to
    ///   - comment: Optional comment for the restoration
    /// - Returns: True if the restoration was successful, false otherwise
    public func restoreVersion(filePath: URL, version: FileVersion, comment: String? = nil) -> Bool
    {
        // CRITICAL FIX #8: Enhanced error handling with atomic operations and rollback

        var backupVersion: FileVersion?
        var originalData: Data?

        do {
            // Validate input parameters
            guard !filePath.path.isEmpty else {
                throw VersionControlError.invalidPath("Empty file path provided")
            }

            guard version.filePath == filePath else {
                throw VersionControlError.invalidVersion("Version does not match file path")
            }

            // Verify the version file exists and is readable
            guard fileManager.fileExists(atPath: version.storagePath.path) else {
                throw VersionControlError.invalidVersion(
                    "Version file does not exist: \(version.storagePath.path)")
            }

            guard fileManager.isReadableFile(atPath: version.storagePath.path) else {
                throw VersionControlError.invalidVersion(
                    "Version file is not readable: \(version.storagePath.path)")
            }

            // Read and validate the current file before making changes
            if fileManager.fileExists(atPath: filePath.path) {
                do {
                    originalData = try Data(contentsOf: filePath)
                } catch {
                    throw VersionControlError.invalidPath(
                        "Cannot read current file data: \(error.localizedDescription)")
                }

                // Create a backup of the current file before restoring
                let backupComment =
                    comment ?? "Restored to version from \(formatDate(version.timestamp))"
                backupVersion = createFileVersion(
                    filePath: filePath, comment: "Pre-restore backup: \(backupComment)")

                if backupVersion != nil {
                    print("Created backup version: \(backupVersion!.id)")
                } else {
                    print("Warning: Could not create backup version before restoration")
                }
            }

            // Read the version data with validation
            let versionData: Data
            do {
                versionData = try Data(contentsOf: version.storagePath)
            } catch {
                throw VersionControlError.invalidVersion(
                    "Cannot read version data: \(error.localizedDescription)")
            }

            // Validate version data integrity
            let versionHash = calculateHash(for: versionData)
            if versionHash != version.contentHash {
                throw VersionControlError.metadataCorrupted("Version data integrity check failed")
            }

            // Perform atomic write operation
            do {
                try versionData.write(to: filePath, options: .atomic)
            } catch {
                // Attempt rollback if we have original data
                if let original = originalData {
                    do {
                        try original.write(to: filePath, options: .atomic)
                        print("Successfully rolled back to original file content")
                    } catch {
                        print("CRITICAL: Failed to rollback file content: \(error)")
                    }
                }
                throw VersionControlError.restorationFailed(
                    "Cannot write restored data: \(error.localizedDescription)")
            }

            // Update file modification time
            do {
                let attributes = [FileAttributeKey.modificationDate: Date()]
                try fileManager.setAttributes(attributes, ofItemAtPath: filePath.path)
            } catch {
                print("Warning: Could not update file modification time: \(error)")
                // This is not critical, so we don't fail the operation
            }

            print(
                "Successfully restored file \(filePath.lastPathComponent) to version \(version.id)")
            return true

        } catch let error as VersionControlError {
            print("VersionControl Error during restoration: \(error.localizedDescription)")
            return false
        } catch {
            print("Unexpected error during file restoration: \(error)")

            // Attempt emergency rollback if we have original data
            if let original = originalData {
                do {
                    try original.write(to: filePath, options: .atomic)
                    print("Emergency rollback completed successfully")
                } catch {
                    print("CRITICAL: Emergency rollback failed: \(error)")
                }
            }

            return false
        }
    }

    /// Formats a date for display
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }

    /// Finds the space path for a given file
    /// - Parameter filePath: The path to the file
    /// - Returns: The space path if found, nil otherwise
    private func findSpacePath(for filePath: URL) -> URL? {
        var currentPath = filePath.deletingLastPathComponent()

        while currentPath.path != "/" {
            let augmentDir = currentPath.appendingPathComponent(".augment")
            if fileManager.fileExists(atPath: augmentDir.path) {
                return currentPath
            }
            currentPath = currentPath.deletingLastPathComponent()
        }

        return nil
    }

    /// Calculates SHA-256 hash for data
    /// - Parameter data: The data to hash
    /// - Returns: The hash string
    private func calculateHash(for data: Data) -> String {
        let hash = SHA256.hash(data: data)
        return hash.compactMap { String(format: "%02x", $0) }.joined()
    }

    /// Calculates a hash for a file path to use as directory name
    /// - Parameter filePath: The file path
    /// - Returns: A hash string
    private func calculateFilePathHash(filePath: URL) -> String {
        let pathData = Data(filePath.path.utf8)
        let hash = SHA256.hash(data: pathData)
        return hash.compactMap { String(format: "%02x", $0) }.joined()
    }

    /// Restores a folder to a specific version with atomic operations and rollback
    /// - Parameters:
    ///   - folderPath: The path to the folder
    ///   - version: The version to restore
    /// - Returns: A boolean indicating success or failure
    public func restoreVersion(folderPath: URL, version: FolderVersion) -> Bool {
        // CRITICAL FIX #2: Implement atomic operations with proper rollback mechanism

        // Create temporary staging area for atomic operations
        let tempDirectory = FileManager.default.temporaryDirectory
            .appendingPathComponent("AugmentRestore")
            .appendingPathComponent(UUID().uuidString)

        var backupDirectory: URL?

        do {
            // Step 1: Validate inputs
            guard fileManager.fileExists(atPath: folderPath.path) else {
                throw VersionControlError.invalidPath(
                    "Folder path does not exist: \(folderPath.path)")
            }

            guard fileManager.fileExists(atPath: version.storagePath.path) else {
                throw VersionControlError.invalidVersion(
                    "Version storage path does not exist: \(version.storagePath.path)")
            }

            // Step 2: Create temporary directories
            try fileManager.createDirectory(at: tempDirectory, withIntermediateDirectories: true)

            let stagingDirectory = tempDirectory.appendingPathComponent("staging")
            backupDirectory = tempDirectory.appendingPathComponent("backup")

            try fileManager.createDirectory(at: stagingDirectory, withIntermediateDirectories: true)
            try fileManager.createDirectory(at: backupDirectory!, withIntermediateDirectories: true)

            // Step 3: Create backup of current state BEFORE any modifications
            print("VersionControl: Creating backup before restoration...")
            let currentContents = try fileManager.contentsOfDirectory(
                at: folderPath, includingPropertiesForKeys: nil)

            for item in currentContents where item.lastPathComponent != ".augment" {
                let relativePath = item.lastPathComponent
                let backupPath = backupDirectory!.appendingPathComponent(relativePath)
                try fileManager.copyItem(at: item, to: backupPath)
            }

            // Step 4: Prepare restoration in staging area
            print("VersionControl: Preparing restoration in staging area...")
            let versionContents = try fileManager.contentsOfDirectory(
                at: version.storagePath, includingPropertiesForKeys: nil,
                options: [.skipsHiddenFiles])

            for file in versionContents {
                let relativePath = file.path.replacingOccurrences(
                    of: version.storagePath.path + "/", with: "")
                let stagingPath = stagingDirectory.appendingPathComponent(relativePath)

                // Create parent directories if needed
                try fileManager.createDirectory(
                    at: stagingPath.deletingLastPathComponent(),
                    withIntermediateDirectories: true)

                try fileManager.copyItem(at: file, to: stagingPath)
            }

            // Step 5: Atomic replacement - remove current files and move staged files
            print("VersionControl: Performing atomic replacement...")

            // Remove current files (except .augment)
            for item in currentContents where item.lastPathComponent != ".augment" {
                try fileManager.removeItem(at: item)
            }

            // Move staged files to final location
            let stagedContents = try fileManager.contentsOfDirectory(
                at: stagingDirectory, includingPropertiesForKeys: nil)

            for stagedItem in stagedContents {
                let relativePath = stagedItem.lastPathComponent
                let finalPath = folderPath.appendingPathComponent(relativePath)
                try fileManager.moveItem(at: stagedItem, to: finalPath)
            }

            // Step 6: Cleanup temporary directory
            try fileManager.removeItem(at: tempDirectory)

            print("VersionControl: Successfully restored folder to version \(version.id)")
            return true

        } catch {
            print("VersionControl: Error during restoration: \(error)")

            // ROLLBACK MECHANISM: Restore from backup if restoration failed
            if let backup = backupDirectory,
                fileManager.fileExists(atPath: backup.path)
            {

                print("VersionControl: Attempting rollback from backup...")

                do {
                    // Remove any partially restored files
                    let currentContents = try fileManager.contentsOfDirectory(
                        at: folderPath, includingPropertiesForKeys: nil)

                    for item in currentContents where item.lastPathComponent != ".augment" {
                        try fileManager.removeItem(at: item)
                    }

                    // Restore from backup
                    let backupContents = try fileManager.contentsOfDirectory(
                        at: backup, includingPropertiesForKeys: nil)

                    for backupItem in backupContents {
                        let relativePath = backupItem.lastPathComponent
                        let restorePath = folderPath.appendingPathComponent(relativePath)
                        try fileManager.moveItem(at: backupItem, to: restorePath)
                    }

                    print("VersionControl: Successfully rolled back to original state")

                } catch let rollbackError {
                    print("VersionControl: CRITICAL ERROR - Rollback failed: \(rollbackError)")
                    // This is a critical situation - log extensively
                    print("VersionControl: Original error: \(error)")
                    print("VersionControl: Backup directory: \(backup.path)")
                }
            }

            // Cleanup temporary directory
            try? fileManager.removeItem(at: tempDirectory)

            return false
        }
    }
}

/// Represents a version of a folder
public struct FolderVersion: Identifiable, Codable {
    /// Unique identifier for the version
    public let id: UUID

    /// The path to the folder
    public let folderPath: URL

    /// The timestamp when the version was created
    public let timestamp: Date

    /// Optional comment for the version
    public let comment: String?

    /// The path to the stored version data
    public let storagePath: URL
}

/// Manages metadata for versioned folders
public class MetadataManager {
    /// Singleton instance - DEPRECATED: Use dependency injection instead
    @available(*, deprecated, message: "Use dependency injection instead of singleton pattern")
    public static let shared = MetadataManager()

    private let fileManager = FileManager.default

    /// Public initializer for dependency injection
    public init() {}

    /// Saves metadata for a folder version
    /// - Parameters:
    ///   - version: The folder version
    ///   - spacePath: The path to the Augment space
    /// - Returns: A boolean indicating success or failure
    public func saveVersionMetadata(version: FolderVersion, spacePath: URL) -> Bool {
        do {
            let metadataDir = spacePath.appendingPathComponent(".augment/metadata")
            let metadataFile = metadataDir.appendingPathComponent("\(version.id.uuidString).json")

            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            let data = try encoder.encode(version)
            try data.write(to: metadataFile)

            return true
        } catch {
            print("Error saving metadata: \(error)")
            return false
        }
    }

    /// Loads metadata for all versions of a folder
    /// - Parameters:
    ///   - folderPath: The path to the folder
    ///   - spacePath: The path to the Augment space
    /// - Returns: An array of folder versions
    public func loadVersionMetadata(folderPath: URL, spacePath: URL) -> [FolderVersion] {
        do {
            let metadataDir = spacePath.appendingPathComponent(".augment/metadata")
            let metadataFiles = try fileManager.contentsOfDirectory(
                at: metadataDir, includingPropertiesForKeys: nil)

            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601

            var versions: [FolderVersion] = []
            for file in metadataFiles where file.pathExtension == "json" {
                if let data = try? Data(contentsOf: file),
                    let version = try? decoder.decode(FolderVersion.self, from: data)
                {
                    versions.append(version)
                }
            }

            return versions.sorted { $0.timestamp > $1.timestamp }
        } catch {
            print("Error loading metadata: \(error)")
            return []
        }
    }

    /// Deletes metadata for a folder version
    /// - Parameters:
    ///   - version: The folder version
    ///   - spacePath: The path to the Augment space
    /// - Returns: A boolean indicating success or failure
    public func deleteVersionMetadata(version: FolderVersion, spacePath: URL) -> Bool {
        do {
            let metadataDir = spacePath.appendingPathComponent(".augment/metadata")
            let metadataFile = metadataDir.appendingPathComponent("\(version.id.uuidString).json")
            try fileManager.removeItem(at: metadataFile)
            return true
        } catch {
            print("Error deleting metadata: \(error)")
            return false
        }
    }

    // MARK: - File Version Metadata Management

    /// Saves metadata for a file version
    /// - Parameters:
    ///   - version: The file version
    ///   - spacePath: The path to the Augment space
    /// - Returns: A boolean indicating success or failure
    public func saveFileVersionMetadata(version: FileVersion, spacePath: URL) -> Bool {
        do {
            let metadataDir = spacePath.appendingPathComponent(".augment/file_metadata")
            try fileManager.createDirectory(at: metadataDir, withIntermediateDirectories: true)

            // Create a hash of the file path for the metadata filename
            let filePathHash = calculateFilePathHash(filePath: version.filePath)
            let fileMetadataDir = metadataDir.appendingPathComponent(filePathHash)
            try fileManager.createDirectory(at: fileMetadataDir, withIntermediateDirectories: true)

            let metadataFile = fileMetadataDir.appendingPathComponent(
                "\(version.id.uuidString).json")

            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            let data = try encoder.encode(version)
            try data.write(to: metadataFile)

            return true
        } catch {
            print("Error saving file metadata: \(error)")
            return false
        }
    }

    /// Loads metadata for all versions of a file
    /// - Parameters:
    ///   - filePath: The path to the file
    ///   - spacePath: The path to the Augment space
    /// - Returns: An array of file versions
    public func loadFileVersionMetadata(filePath: URL, spacePath: URL) -> [FileVersion] {
        print("🔍 MetadataManager.loadFileVersionMetadata: STARTING")
        print("📁 MetadataManager.loadFileVersionMetadata: filePath = \(filePath.path)")
        print("🏠 MetadataManager.loadFileVersionMetadata: spacePath = \(spacePath.path)")

        do {
            let metadataDir = spacePath.appendingPathComponent(".augment/file_metadata")
            print("📂 MetadataManager.loadFileVersionMetadata: metadataDir = \(metadataDir.path)")

            let filePathHash = calculateFilePathHash(filePath: filePath)
            print("🔢 MetadataManager.loadFileVersionMetadata: filePathHash = \(filePathHash)")

            let fileMetadataDir = metadataDir.appendingPathComponent(filePathHash)
            print(
                "📁 MetadataManager.loadFileVersionMetadata: fileMetadataDir = \(fileMetadataDir.path)"
            )

            let dirExists = fileManager.fileExists(atPath: fileMetadataDir.path)
            print("✅ MetadataManager.loadFileVersionMetadata: Directory exists = \(dirExists)")

            guard dirExists else {
                print(
                    "❌ MetadataManager.loadFileVersionMetadata: Directory does not exist, returning empty array"
                )
                return []
            }

            let metadataFiles = try fileManager.contentsOfDirectory(
                at: fileMetadataDir, includingPropertiesForKeys: nil)
            print("📄 MetadataManager.loadFileVersionMetadata: Found \(metadataFiles.count) files")

            for file in metadataFiles {
                print("   📄 File: \(file.lastPathComponent) (extension: \(file.pathExtension))")
            }

            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601

            var versions: [FileVersion] = []
            var successCount = 0
            var errorCount = 0

            for file in metadataFiles where file.pathExtension == "json" {
                print(
                    "🔄 MetadataManager.loadFileVersionMetadata: Processing \(file.lastPathComponent)"
                )

                do {
                    let data = try Data(contentsOf: file)
                    print("   ✅ Successfully read data (\(data.count) bytes)")

                    let version = try decoder.decode(FileVersion.self, from: data)
                    print("   ✅ Successfully decoded FileVersion: \(version.id)")

                    versions.append(version)
                    successCount += 1
                } catch {
                    print("   ❌ Error processing \(file.lastPathComponent): \(error)")
                    errorCount += 1
                }
            }

            print(
                "📊 MetadataManager.loadFileVersionMetadata: Success: \(successCount), Errors: \(errorCount)"
            )
            print(
                "📊 MetadataManager.loadFileVersionMetadata: Total versions loaded: \(versions.count)"
            )

            let sortedVersions = versions.sorted { $0.timestamp > $1.timestamp }
            print(
                "✅ MetadataManager.loadFileVersionMetadata: Returning \(sortedVersions.count) sorted versions"
            )
            return sortedVersions

        } catch {
            print(
                "❌ MetadataManager.loadFileVersionMetadata: Error loading file metadata: \(error)")
            return []
        }
    }

    /// Deletes metadata for a file version
    /// - Parameters:
    ///   - version: The file version
    ///   - spacePath: The path to the Augment space
    /// - Returns: A boolean indicating success or failure
    public func deleteFileVersionMetadata(version: FileVersion, spacePath: URL) -> Bool {
        do {
            let metadataDir = spacePath.appendingPathComponent(".augment/file_metadata")
            let filePathHash = calculateFilePathHash(filePath: version.filePath)
            let fileMetadataDir = metadataDir.appendingPathComponent(filePathHash)
            let metadataFile = fileMetadataDir.appendingPathComponent(
                "\(version.id.uuidString).json")
            try fileManager.removeItem(at: metadataFile)
            return true
        } catch {
            print("Error deleting file metadata: \(error)")
            return false
        }
    }

    /// Calculates a hash for a file path to use as directory name
    /// - Parameter filePath: The file path
    /// - Returns: A hash string
    private func calculateFilePathHash(filePath: URL) -> String {
        let pathData = Data(filePath.path.utf8)
        let hash = SHA256.hash(data: pathData)
        return hash.compactMap { String(format: "%02x", $0) }.joined()
    }
}
