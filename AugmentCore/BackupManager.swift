import CryptoKit
import Foundation

/// Manages backups for Augment spaces
public class BackupManager {
    /// Singleton instance - DEPRECATED: Use dependency injection instead
    @available(*, deprecated, message: "Use dependency injection instead of singleton pattern")
    public static let shared = BackupManager()

    /// The list of backup configurations
    private var backupConfigurations: [BackupConfiguration] = []

    /// The backup queue
    private let backupQueue = DispatchQueue(label: "com.augment.backup", qos: .background)

    /// Public initializer for dependency injection
    public init() {
        loadConfigurations()
    }

    /// Adds a backup configuration
    /// - Parameter configuration: The configuration to add
    /// - Returns: A boolean indicating success or failure
    public func addConfiguration(_ configuration: BackupConfiguration) -> Bool {
        // Remove any existing configuration for the same space
        _ = removeConfiguration(spacePath: configuration.spacePath)

        // Add the new configuration
        backupConfigurations.append(configuration)

        // Save the configurations
        saveConfigurations()

        return true
    }

    /// Removes a backup configuration
    /// - Parameter spacePath: The path to the Augment space
    /// - Returns: A boolean indicating success or failure
    public func removeConfiguration(spacePath: URL) -> Bool {
        // Remove the configuration
        backupConfigurations.removeAll { $0.spacePath == spacePath }

        // Save the configurations
        saveConfigurations()

        return true
    }

    /// Gets the backup configuration for a space
    /// - Parameter spacePath: The path to the Augment space
    /// - Returns: The backup configuration if found, nil otherwise
    public func getConfiguration(spacePath: URL) -> BackupConfiguration? {
        return backupConfigurations.first { $0.spacePath == spacePath }
    }

    /// Gets all backup configurations
    /// - Returns: An array of backup configurations
    public func getConfigurations() -> [BackupConfiguration] {
        return backupConfigurations
    }

    /// Creates a backup of a space
    /// - Parameter spacePath: The path to the Augment space
    /// - Returns: A boolean indicating success or failure
    public func createBackup(spacePath: URL) -> Bool {
        // Get the configuration
        guard let configuration = getConfiguration(spacePath: spacePath) else { return false }

        // Check if the configuration is enabled
        guard configuration.isEnabled else { return false }

        // Create the backup
        backupQueue.async {
            self.performBackup(configuration: configuration)
        }

        return true
    }

    /// Creates backups of all spaces
    /// - Returns: A boolean indicating success or failure
    public func createAllBackups() -> Bool {
        // Get all enabled configurations
        let enabledConfigurations = backupConfigurations.filter { $0.isEnabled }

        // Create a backup for each space
        for configuration in enabledConfigurations {
            backupQueue.async {
                self.performBackup(configuration: configuration)
            }
        }

        return true
    }

    /// Restores a backup
    /// - Parameters:
    ///   - backupPath: The path to the backup
    ///   - spacePath: The path to the Augment space
    ///   - password: The password for encrypted backups
    /// - Returns: A boolean indicating success or failure
    public func restoreBackup(backupPath: URL, spacePath: URL, password: String? = nil) -> Bool {
        // Check if the backup exists
        guard FileManager.default.fileExists(atPath: backupPath.path) else { return false }

        // Get the configuration
        let configuration = getConfiguration(spacePath: spacePath)

        // Check if the backup is encrypted
        let isEncrypted = configuration?.isEncrypted ?? false

        // Restore the backup
        backupQueue.async {
            self.performRestore(
                backupPath: backupPath, spacePath: spacePath, isEncrypted: isEncrypted,
                password: password)
        }

        return true
    }

    /// Performs the backup operation
    /// - Parameter configuration: The backup configuration
    private func performBackup(configuration: BackupConfiguration) {
        // Get the space path
        let spacePath = configuration.spacePath

        // Get the backup path
        let backupPath = configuration.backupPath

        // Create a backup name
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd-HH-mm-ss"
        let backupName = "backup-\(dateFormatter.string(from: Date())).zip"

        // Create the backup file path
        let backupFilePath = backupPath.appendingPathComponent(backupName)

        // Create the backup directory if it doesn't exist
        try? FileManager.default.createDirectory(at: backupPath, withIntermediateDirectories: true)

        // Create a temporary directory
        let temporaryDirectory = FileManager.default.temporaryDirectory.appendingPathComponent(
            UUID().uuidString)
        try? FileManager.default.createDirectory(
            at: temporaryDirectory, withIntermediateDirectories: true)

        // Copy the space to the temporary directory
        let temporarySpacePath = temporaryDirectory.appendingPathComponent(
            spacePath.lastPathComponent)
        try? FileManager.default.copyItem(at: spacePath, to: temporarySpacePath)

        // Create the zip file
        let zipProcess = Process()
        zipProcess.executableURL = URL(fileURLWithPath: "/usr/bin/zip")
        zipProcess.arguments = ["-r", backupFilePath.path, temporarySpacePath.path]
        zipProcess.currentDirectoryURL = temporaryDirectory

        do {
            try zipProcess.run()
            zipProcess.waitUntilExit()
        } catch {
            print("Error creating zip file: \(error)")
        }

        // Encrypt the backup if needed
        if configuration.isEncrypted, let password = configuration.password {
            encryptFile(filePath: backupFilePath, password: password)
        }

        // Clean up the temporary directory
        try? FileManager.default.removeItem(at: temporaryDirectory)

        // Update the last backup timestamp
        if let index = backupConfigurations.firstIndex(where: { $0.id == configuration.id }) {
            backupConfigurations[index].lastBackupTimestamp = Date()
            saveConfigurations()
        }

        // Apply retention policy
        applyRetentionPolicy(configuration: configuration)
    }

    /// Performs the restore operation
    /// - Parameters:
    ///   - backupPath: The path to the backup
    ///   - spacePath: The path to the Augment space
    ///   - isEncrypted: Whether the backup is encrypted
    ///   - password: The password for encrypted backups
    private func performRestore(
        backupPath: URL, spacePath: URL, isEncrypted: Bool, password: String? = nil
    ) {
        // Create a temporary directory
        let temporaryDirectory = FileManager.default.temporaryDirectory.appendingPathComponent(
            UUID().uuidString)
        try? FileManager.default.createDirectory(
            at: temporaryDirectory, withIntermediateDirectories: true)

        // Copy the backup to the temporary directory
        let temporaryBackupPath = temporaryDirectory.appendingPathComponent(
            backupPath.lastPathComponent)
        try? FileManager.default.copyItem(at: backupPath, to: temporaryBackupPath)

        // Decrypt the backup if needed
        if isEncrypted, let password = password {
            decryptFile(filePath: temporaryBackupPath, password: password)
        }

        // Extract the zip file
        let unzipProcess = Process()
        unzipProcess.executableURL = URL(fileURLWithPath: "/usr/bin/unzip")
        unzipProcess.arguments = ["-o", temporaryBackupPath.path, "-d", temporaryDirectory.path]

        do {
            try unzipProcess.run()
            unzipProcess.waitUntilExit()
        } catch {
            print("Error extracting zip file: \(error)")
        }

        // Find the extracted space
        guard let extractedSpacePath = findExtractedSpace(in: temporaryDirectory) else {
            // Clean up the temporary directory
            try? FileManager.default.removeItem(at: temporaryDirectory)
            return
        }

        // Remove the existing space
        try? FileManager.default.removeItem(at: spacePath)

        // Copy the extracted space to the space path
        try? FileManager.default.copyItem(at: extractedSpacePath, to: spacePath)

        // Clean up the temporary directory
        try? FileManager.default.removeItem(at: temporaryDirectory)
    }

    /// Finds the extracted space in a directory
    /// - Parameter directory: The directory to search in
    /// - Returns: The path to the extracted space if found, nil otherwise
    private func findExtractedSpace(in directory: URL) -> URL? {
        // Get the contents of the directory
        guard
            let contents = try? FileManager.default.contentsOfDirectory(
                at: directory, includingPropertiesForKeys: nil)
        else { return nil }

        // Find the first directory
        for url in contents {
            var isDirectory: ObjCBool = false
            if FileManager.default.fileExists(atPath: url.path, isDirectory: &isDirectory),
                isDirectory.boolValue
            {
                return url
            }
        }

        return nil
    }

    /// Encrypts a file
    /// - Parameters:
    ///   - filePath: The path to the file
    ///   - password: The password
    private func encryptFile(filePath: URL, password: String) {
        // Read the file
        guard let data = try? Data(contentsOf: filePath) else { return }

        // Generate a salt
        let salt = generateRandomBytes(length: 16)

        // Derive a key from the password
        guard let key = deriveKey(password: password, salt: salt) else { return }

        // CRITICAL FIX #5: Use new encryption method that handles nonce internally
        guard let encryptedData = encrypt(data: data, key: key) else { return }

        // Create the encrypted file with salt + encrypted data (which includes nonce)
        var encryptedFile = Data()
        encryptedFile.append(salt)
        encryptedFile.append(encryptedData)

        // Write the encrypted file atomically
        let tempFile = filePath.appendingPathExtension("tmp")
        do {
            try encryptedFile.write(to: tempFile)
            _ = try FileManager.default.replaceItem(
                at: filePath, withItemAt: tempFile,
                backupItemName: nil, options: [],
                resultingItemURL: nil)
        } catch {
            print("BackupManager: Error writing encrypted file: \(error)")
            try? FileManager.default.removeItem(at: tempFile)
        }
    }

    /// Decrypts a file
    /// - Parameters:
    ///   - filePath: The path to the file
    ///   - password: The password
    private func decryptFile(filePath: URL, password: String) {
        // Read the file
        guard let encryptedFile = try? Data(contentsOf: filePath) else { return }

        // Validate minimum file size (16 bytes salt + 28 bytes encrypted data minimum)
        guard encryptedFile.count >= 44 else {
            print("BackupManager: Encrypted file too small")
            return
        }

        // Extract the salt
        let salt = encryptedFile.prefix(16)

        // Extract the encrypted data (everything after salt)
        let encryptedData = encryptedFile.suffix(from: 16)

        // Derive a key from the password
        guard let key = deriveKey(password: password, salt: salt) else { return }

        // CRITICAL FIX #5: Try new decryption method first, fall back to legacy if needed
        var decryptedData: Data?

        // Try new format first
        decryptedData = decrypt(encryptedData: encryptedData, key: key)

        // If new format fails, try legacy format for backward compatibility
        if decryptedData == nil && encryptedData.count >= 28 {
            print("BackupManager: Trying legacy decryption format")
            let nonce = encryptedData.prefix(12)
            let ciphertext = encryptedData.suffix(from: 12)
            decryptedData = decrypt(encryptedData: ciphertext, key: key, nonce: nonce)
        }

        guard let finalDecryptedData = decryptedData else {
            print("BackupManager: Failed to decrypt file with both new and legacy methods")
            return
        }

        // Write the decrypted file atomically
        let tempFile = filePath.appendingPathExtension("tmp")
        do {
            try finalDecryptedData.write(to: tempFile)
            _ = try FileManager.default.replaceItem(
                at: filePath, withItemAt: tempFile,
                backupItemName: nil, options: [],
                resultingItemURL: nil)
        } catch {
            print("BackupManager: Error writing decrypted file: \(error)")
            try? FileManager.default.removeItem(at: tempFile)
        }
    }

    /// Generates random bytes
    /// - Parameter length: The length of the bytes
    /// - Returns: The random bytes
    private func generateRandomBytes(length: Int) -> Data {
        var bytes = [UInt8](repeating: 0, count: length)
        _ = SecRandomCopyBytes(kSecRandomDefault, length, &bytes)
        return Data(bytes)
    }

    /// Derives a key from a password
    /// - Parameters:
    ///   - password: The password
    ///   - salt: The salt
    /// - Returns: The derived key
    private func deriveKey(password: String, salt: Data) -> SymmetricKey? {
        guard let passwordData = password.data(using: .utf8) else { return nil }

        let inputKeyMaterial = SymmetricKey(data: passwordData)
        let key = HKDF<SHA256>.deriveKey(
            inputKeyMaterial: inputKeyMaterial,
            salt: salt,
            outputByteCount: 32
        )

        return key
    }

    /// CRITICAL FIX #5: Correct AES-GCM encryption implementation
    /// Encrypts data using AES-GCM with proper nonce handling
    /// - Parameters:
    ///   - data: The data to encrypt
    ///   - key: The encryption key
    /// - Returns: The encrypted data with format: nonce(12) + ciphertext + tag(16)
    private func encrypt(data: Data, key: SymmetricKey) -> Data? {
        do {
            // Generate a secure random nonce for each encryption
            let nonce = AES.GCM.Nonce()

            // Encrypt the data
            let sealedBox = try AES.GCM.seal(data, using: key, nonce: nonce)

            // Return the combined data (nonce + ciphertext + tag)
            // This is the standard format that can be safely stored and transmitted
            return sealedBox.combined

        } catch {
            print("BackupManager: Error encrypting data: \(error)")
            return nil
        }
    }

    /// CRITICAL FIX #5: Correct AES-GCM decryption implementation
    /// Decrypts data using AES-GCM with proper format handling
    /// - Parameters:
    ///   - encryptedData: The encrypted data in format: nonce(12) + ciphertext + tag(16)
    ///   - key: The encryption key
    /// - Returns: The decrypted data
    private func decrypt(encryptedData: Data, key: SymmetricKey) -> Data? {
        do {
            // Validate minimum size (12 bytes nonce + 16 bytes tag = 28 bytes minimum)
            guard encryptedData.count >= 28 else {
                print("BackupManager: Encrypted data too small (minimum 28 bytes required)")
                return nil
            }

            // Create sealed box from combined data
            let sealedBox = try AES.GCM.SealedBox(combined: encryptedData)

            // Decrypt the data
            let decryptedData = try AES.GCM.open(sealedBox, using: key)

            return decryptedData

        } catch {
            print("BackupManager: Error decrypting data: \(error)")
            return nil
        }
    }

    /// Legacy decrypt method for backward compatibility (deprecated)
    /// - Parameters:
    ///   - encryptedData: The encrypted data
    ///   - key: The encryption key
    ///   - nonce: The nonce (deprecated - now extracted from combined data)
    /// - Returns: The decrypted data
    @available(*, deprecated, message: "Use decrypt(encryptedData:key:) instead")
    private func decrypt(encryptedData: Data, key: SymmetricKey, nonce: Data) -> Data? {
        // For backward compatibility, try the old method first
        guard let nonceData = try? AES.GCM.Nonce(data: nonce) else {
            print("BackupManager: Invalid nonce data")
            return nil
        }

        do {
            // Try to create sealed box from separate components
            // This is for compatibility with old encrypted backups
            let sealedBox = try AES.GCM.SealedBox(
                nonce: nonceData, ciphertext: encryptedData, tag: Data())
            return try AES.GCM.open(sealedBox, using: key)
        } catch {
            print("BackupManager: Legacy decryption failed: \(error)")
            // Fall back to new method
            return decrypt(encryptedData: encryptedData, key: key)
        }
    }

    /// Applies the retention policy to backups
    /// - Parameter configuration: The backup configuration
    private func applyRetentionPolicy(configuration: BackupConfiguration) {
        // Get the backup path
        let backupPath = configuration.backupPath

        // Get the retention policy
        let retention = configuration.retention

        // Get all backups
        guard
            let backupFiles = try? FileManager.default.contentsOfDirectory(
                at: backupPath, includingPropertiesForKeys: nil)
        else { return }

        // Filter for backup files
        let backups = backupFiles.filter { $0.lastPathComponent.hasPrefix("backup-") }

        // Sort by date (oldest first)
        let sortedBackups = backups.sorted { (lhs, rhs) -> Bool in
            let lhsAttributes = try? FileManager.default.attributesOfItem(atPath: lhs.path)
            let rhsAttributes = try? FileManager.default.attributesOfItem(atPath: rhs.path)

            let lhsDate = lhsAttributes?[.creationDate] as? Date ?? Date.distantPast
            let rhsDate = rhsAttributes?[.creationDate] as? Date ?? Date.distantPast

            return lhsDate < rhsDate
        }

        // Apply the retention policy
        switch retention {
        case .keepAll:
            // Keep all backups
            break
        case .keepLimited(let count):
            // Keep only the specified number of backups
            if sortedBackups.count > count {
                // Get the backups to delete
                let backupsToDelete = sortedBackups.prefix(sortedBackups.count - count)

                // Delete each backup
                for backup in backupsToDelete {
                    try? FileManager.default.removeItem(at: backup)
                }
            }
        case .keepForTime(let time):
            // Keep backups for the specified time
            let cutoffDate = Date().addingTimeInterval(-time)

            // Get the backups to delete
            let backupsToDelete = sortedBackups.filter {
                let attributes = try? FileManager.default.attributesOfItem(atPath: $0.path)
                let creationDate = attributes?[.creationDate] as? Date ?? Date.distantPast
                return creationDate < cutoffDate
            }

            // Delete each backup
            for backup in backupsToDelete {
                try? FileManager.default.removeItem(at: backup)
            }
        }
    }

    /// Saves the backup configurations to disk
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
        let configurationsFile = augmentDir.appendingPathComponent("backup_configurations.json")
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let data = try encoder.encode(backupConfigurations)
            try data.write(to: configurationsFile)
        } catch {
            print("Error saving configurations: \(error)")
        }
    }

    /// Loads the backup configurations from disk
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
            "Augment/backup_configurations.json")

        // Check if the file exists
        guard FileManager.default.fileExists(atPath: configurationsFile.path) else { return }

        // Read the file
        do {
            let data = try Data(contentsOf: configurationsFile)

            // Decode the configurations
            let decoder = JSONDecoder()
            backupConfigurations = try decoder.decode([BackupConfiguration].self, from: data)
        } catch {
            print("Error loading configurations: \(error)")
        }
    }
}

/// Represents a backup configuration
public struct BackupConfiguration: Identifiable, Codable {
    /// Unique identifier for the configuration
    public let id: UUID

    /// The path to the Augment space
    public let spacePath: URL

    /// The backup path
    public let backupPath: URL

    /// The backup frequency
    public let frequency: BackupFrequency

    /// The retention policy
    public let retention: BackupRetention

    /// Whether the backup is encrypted
    public let isEncrypted: Bool

    /// The password for encrypted backups
    public let password: String?

    /// Whether the configuration is enabled
    public var isEnabled: Bool

    /// The last backup timestamp
    public var lastBackupTimestamp: Date?

    /// Coding keys for encoding and decoding
    enum CodingKeys: String, CodingKey {
        case id
        case spacePath
        case backupPath
        case frequency
        case retention
        case isEncrypted
        case password
        case isEnabled
        case lastBackupTimestamp
    }

    /// Initializes a new backup configuration
    /// - Parameters:
    ///   - id: The unique identifier for the configuration
    ///   - spacePath: The path to the Augment space
    ///   - backupPath: The backup path
    ///   - frequency: The backup frequency
    ///   - retention: The retention policy
    ///   - isEncrypted: Whether the backup is encrypted
    ///   - password: The password for encrypted backups
    ///   - isEnabled: Whether the configuration is enabled
    ///   - lastBackupTimestamp: The last backup timestamp
    public init(
        id: UUID, spacePath: URL, backupPath: URL, frequency: BackupFrequency,
        retention: BackupRetention, isEncrypted: Bool = false, password: String? = nil,
        isEnabled: Bool = true, lastBackupTimestamp: Date? = nil
    ) {
        self.id = id
        self.spacePath = spacePath
        self.backupPath = backupPath
        self.frequency = frequency
        self.retention = retention
        self.isEncrypted = isEncrypted
        self.password = password
        self.isEnabled = isEnabled
        self.lastBackupTimestamp = lastBackupTimestamp
    }

    /// Encodes the configuration to a decoder
    /// - Parameter encoder: The encoder
    /// - Throws: An error if encoding fails
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(spacePath.path, forKey: .spacePath)
        try container.encode(backupPath.path, forKey: .backupPath)
        try container.encode(frequency, forKey: .frequency)
        try container.encode(retention, forKey: .retention)
        try container.encode(isEncrypted, forKey: .isEncrypted)
        try container.encode(password, forKey: .password)
        try container.encode(isEnabled, forKey: .isEnabled)
        try container.encode(lastBackupTimestamp, forKey: .lastBackupTimestamp)
    }

    /// Initializes a configuration from a decoder
    /// - Parameter decoder: The decoder
    /// - Throws: An error if decoding fails
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        let spacePathString = try container.decode(String.self, forKey: .spacePath)
        spacePath = URL(fileURLWithPath: spacePathString)
        let backupPathString = try container.decode(String.self, forKey: .backupPath)
        backupPath = URL(fileURLWithPath: backupPathString)
        frequency = try container.decode(BackupFrequency.self, forKey: .frequency)
        retention = try container.decode(BackupRetention.self, forKey: .retention)
        isEncrypted = try container.decode(Bool.self, forKey: .isEncrypted)
        password = try container.decode(String?.self, forKey: .password)
        isEnabled = try container.decode(Bool.self, forKey: .isEnabled)
        lastBackupTimestamp = try container.decode(Date?.self, forKey: .lastBackupTimestamp)
    }
}

/// The frequency of backups
public enum BackupFrequency: String, Codable {
    /// Manual backups
    case manual

    /// Hourly backups
    case hourly

    /// Daily backups
    case daily

    /// Weekly backups
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

/// The retention policy for backups
public enum BackupRetention: Codable {
    /// Keep all backups
    case keepAll

    /// Keep a limited number of backups
    case keepLimited(Int)

    /// Keep backups for a limited time
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
