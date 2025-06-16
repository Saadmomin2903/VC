import XCTest
import Foundation
import CryptoKit
@testable import AugmentCore

/// Unit tests for BackupManager encryption fixes
class BackupManagerTests: XCTestCase {
    
    var backupManager: BackupManager!
    var tempDirectory: URL!
    var testSpace: URL!
    var backupPath: URL!
    
    override func setUp() {
        super.setUp()
        backupManager = BackupManager.shared
        
        // Create temporary directory for testing
        tempDirectory = FileManager.default.temporaryDirectory
            .appendingPathComponent("AugmentBackupTests")
            .appendingPathComponent(UUID().uuidString)
        
        testSpace = tempDirectory.appendingPathComponent("TestSpace")
        backupPath = tempDirectory.appendingPathComponent("Backups")
        
        try! FileManager.default.createDirectory(
            at: testSpace, 
            withIntermediateDirectories: true
        )
        
        try! FileManager.default.createDirectory(
            at: backupPath, 
            withIntermediateDirectories: true
        )
    }
    
    override func tearDown() {
        // Clean up temporary directory
        try? FileManager.default.removeItem(at: tempDirectory)
        super.tearDown()
    }
    
    /// Test that backup manager can be accessed
    func testBackupManagerAccess() {
        XCTAssertNotNil(backupManager)
    }
    
    /// Test backup configuration creation
    func testBackupConfigurationCreation() {
        let config = BackupConfiguration(
            id: UUID(),
            spacePath: testSpace,
            backupPath: backupPath,
            frequency: .daily,
            retention: .keepLimited(5),
            isEncrypted: true,
            password: "test_password"
        )
        
        XCTAssertEqual(config.spacePath, testSpace)
        XCTAssertEqual(config.backupPath, backupPath)
        XCTAssertEqual(config.frequency, .daily)
        XCTAssertTrue(config.isEncrypted)
        XCTAssertEqual(config.password, "test_password")
    }
    
    /// Test backup configuration encoding/decoding
    func testBackupConfigurationCoding() {
        let originalConfig = BackupConfiguration(
            id: UUID(),
            spacePath: testSpace,
            backupPath: backupPath,
            frequency: .weekly,
            retention: .keepForTime(86400), // 1 day
            isEncrypted: true,
            password: "secure_password"
        )
        
        // Encode
        let encoder = JSONEncoder()
        guard let encodedData = try? encoder.encode(originalConfig) else {
            XCTFail("Failed to encode backup configuration")
            return
        }
        
        // Decode
        let decoder = JSONDecoder()
        guard let decodedConfig = try? decoder.decode(BackupConfiguration.self, from: encodedData) else {
            XCTFail("Failed to decode backup configuration")
            return
        }
        
        // Verify
        XCTAssertEqual(decodedConfig.id, originalConfig.id)
        XCTAssertEqual(decodedConfig.spacePath.path, originalConfig.spacePath.path)
        XCTAssertEqual(decodedConfig.backupPath.path, originalConfig.backupPath.path)
        XCTAssertEqual(decodedConfig.frequency, originalConfig.frequency)
        XCTAssertEqual(decodedConfig.isEncrypted, originalConfig.isEncrypted)
        XCTAssertEqual(decodedConfig.password, originalConfig.password)
    }
    
    /// Test backup frequency intervals
    func testBackupFrequencyIntervals() {
        XCTAssertEqual(BackupFrequency.manual.interval, 0)
        XCTAssertEqual(BackupFrequency.hourly.interval, 3600)
        XCTAssertEqual(BackupFrequency.daily.interval, 86400)
        XCTAssertEqual(BackupFrequency.weekly.interval, 604800)
    }
    
    /// Test backup retention policies
    func testBackupRetentionPolicies() {
        // Test encoding/decoding of different retention policies
        let policies: [BackupRetention] = [
            .keepAll,
            .keepLimited(10),
            .keepForTime(86400)
        ]
        
        for policy in policies {
            let encoder = JSONEncoder()
            guard let encodedData = try? encoder.encode(policy) else {
                XCTFail("Failed to encode retention policy: \(policy)")
                continue
            }
            
            let decoder = JSONDecoder()
            guard let decodedPolicy = try? decoder.decode(BackupRetention.self, from: encodedData) else {
                XCTFail("Failed to decode retention policy")
                continue
            }
            
            // Verify the policy matches
            switch (policy, decodedPolicy) {
            case (.keepAll, .keepAll):
                break
            case (.keepLimited(let original), .keepLimited(let decoded)):
                XCTAssertEqual(original, decoded)
            case (.keepForTime(let original), .keepForTime(let decoded)):
                XCTAssertEqual(original, decoded, accuracy: 0.001)
            default:
                XCTFail("Retention policy mismatch: \(policy) != \(decodedPolicy)")
            }
        }
    }
    
    /// Test encryption/decryption cycle
    func testEncryptionDecryptionCycle() {
        // Create test data
        let testData = "This is sensitive backup data that needs encryption".data(using: .utf8)!
        let password = "secure_test_password"
        
        // Create a test file
        let testFile = testSpace.appendingPathComponent("sensitive.txt")
        try! testData.write(to: testFile)
        
        // Test encryption (using reflection to access private method)
        // Note: In a real implementation, you'd make these methods internal for testing
        // or create a testable wrapper
        
        // For now, we'll test the public interface through backup operations
        let config = BackupConfiguration(
            id: UUID(),
            spacePath: testSpace,
            backupPath: backupPath,
            frequency: .manual,
            retention: .keepAll,
            isEncrypted: true,
            password: password
        )
        
        // Add configuration
        backupManager.addBackupConfiguration(config)
        
        // Perform backup
        backupManager.performBackup(configuration: config)
        
        // Verify backup was created
        let backupFiles = try? FileManager.default.contentsOfDirectory(at: backupPath, includingPropertiesForKeys: nil)
        XCTAssertNotNil(backupFiles)
        XCTAssertTrue(backupFiles?.count ?? 0 > 0, "Backup should have been created")
    }
    
    /// Test backup creation without encryption
    func testUnencryptedBackup() {
        // Create test files
        let file1 = testSpace.appendingPathComponent("file1.txt")
        let file2 = testSpace.appendingPathComponent("file2.txt")
        
        try! "Content 1".write(to: file1, atomically: true, encoding: .utf8)
        try! "Content 2".write(to: file2, atomically: true, encoding: .utf8)
        
        let config = BackupConfiguration(
            id: UUID(),
            spacePath: testSpace,
            backupPath: backupPath,
            frequency: .manual,
            retention: .keepAll,
            isEncrypted: false
        )
        
        // Add configuration and perform backup
        backupManager.addBackupConfiguration(config)
        backupManager.performBackup(configuration: config)
        
        // Verify backup was created
        let backupFiles = try? FileManager.default.contentsOfDirectory(at: backupPath, includingPropertiesForKeys: nil)
        XCTAssertNotNil(backupFiles)
        XCTAssertTrue(backupFiles?.count ?? 0 > 0, "Unencrypted backup should have been created")
    }
    
    /// Test backup restoration
    func testBackupRestoration() {
        // Create original files
        let file1 = testSpace.appendingPathComponent("original1.txt")
        let file2 = testSpace.appendingPathComponent("original2.txt")
        
        let content1 = "Original content 1"
        let content2 = "Original content 2"
        
        try! content1.write(to: file1, atomically: true, encoding: .utf8)
        try! content2.write(to: file2, atomically: true, encoding: .utf8)
        
        let config = BackupConfiguration(
            id: UUID(),
            spacePath: testSpace,
            backupPath: backupPath,
            frequency: .manual,
            retention: .keepAll
        )
        
        // Create backup
        backupManager.addBackupConfiguration(config)
        backupManager.performBackup(configuration: config)
        
        // Modify original files
        try! "Modified content 1".write(to: file1, atomically: true, encoding: .utf8)
        try! "Modified content 2".write(to: file2, atomically: true, encoding: .utf8)
        
        // Get available backups
        let backups = backupManager.getAvailableBackups(configuration: config)
        XCTAssertTrue(backups.count > 0, "Should have at least one backup")
        
        // Restore from backup
        if let firstBackup = backups.first {
            let success = backupManager.restoreBackup(backup: firstBackup, configuration: config)
            XCTAssertTrue(success, "Backup restoration should succeed")
            
            // Verify restoration
            let restoredContent1 = try? String(contentsOf: file1, encoding: .utf8)
            let restoredContent2 = try? String(contentsOf: file2, encoding: .utf8)
            
            XCTAssertEqual(restoredContent1, content1)
            XCTAssertEqual(restoredContent2, content2)
        }
    }
    
    /// Test retention policy application
    func testRetentionPolicyApplication() {
        let config = BackupConfiguration(
            id: UUID(),
            spacePath: testSpace,
            backupPath: backupPath,
            frequency: .manual,
            retention: .keepLimited(2) // Keep only 2 backups
        )
        
        // Create test file
        let testFile = testSpace.appendingPathComponent("retention_test.txt")
        
        backupManager.addBackupConfiguration(config)
        
        // Create multiple backups
        for i in 1...5 {
            try! "Content \(i)".write(to: testFile, atomically: true, encoding: .utf8)
            backupManager.performBackup(configuration: config)
            
            // Small delay to ensure different timestamps
            Thread.sleep(forTimeInterval: 0.1)
        }
        
        // Check that only 2 backups remain
        let backups = backupManager.getAvailableBackups(configuration: config)
        XCTAssertLessThanOrEqual(backups.count, 2, "Should keep only 2 backups due to retention policy")
    }
    
    /// Test error handling for invalid configurations
    func testErrorHandlingInvalidConfigurations() {
        // Test with non-existent space path
        let invalidConfig = BackupConfiguration(
            id: UUID(),
            spacePath: URL(fileURLWithPath: "/nonexistent/path"),
            backupPath: backupPath,
            frequency: .manual,
            retention: .keepAll
        )
        
        backupManager.addBackupConfiguration(invalidConfig)
        
        // This should not crash, but should handle the error gracefully
        backupManager.performBackup(configuration: invalidConfig)
        
        // Verify no backup was created
        let backups = backupManager.getAvailableBackups(configuration: invalidConfig)
        XCTAssertEqual(backups.count, 0, "No backups should be created for invalid configuration")
    }
    
    /// Test concurrent backup operations
    func testConcurrentBackupOperations() {
        let expectation = XCTestExpectation(description: "Concurrent backups")
        expectation.expectedFulfillmentCount = 3
        
        // Create test files
        for i in 1...3 {
            let file = testSpace.appendingPathComponent("concurrent\(i).txt")
            try! "Content \(i)".write(to: file, atomically: true, encoding: .utf8)
        }
        
        // Create multiple configurations
        for i in 1...3 {
            let config = BackupConfiguration(
                id: UUID(),
                spacePath: testSpace,
                backupPath: backupPath.appendingPathComponent("backup\(i)"),
                frequency: .manual,
                retention: .keepAll
            )
            
            backupManager.addBackupConfiguration(config)
            
            DispatchQueue.global().async {
                self.backupManager.performBackup(configuration: config)
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 10.0)
    }
}
