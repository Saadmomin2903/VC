import Foundation
import XCTest

@testable import Augment

/// Comprehensive tests for StorageManager functionality
class StorageManagerTests: XCTestCase {

    var storageManager: StorageManager!
    var testSpace: AugmentSpace!
    var testDirectory: URL!

    override func setUp() {
        super.setUp()

        // Create test directory
        let tempDir = FileManager.default.temporaryDirectory
        testDirectory = tempDir.appendingPathComponent("AugmentStorageTests_\(UUID().uuidString)")

        do {
            try FileManager.default.createDirectory(
                at: testDirectory, withIntermediateDirectories: true)

            // Create test space
            testSpace = AugmentSpace(
                name: "Test Space",
                path: testDirectory,
                isMonitoring: false
            )

            // Create .augment directory
            let augmentDir = testDirectory.appendingPathComponent(".augment")
            try FileManager.default.createDirectory(
                at: augmentDir, withIntermediateDirectories: true)

            // Create storage manager
            storageManager = StorageManager()

        } catch {
            XCTFail("Failed to set up test environment: \(error)")
        }
    }

    override func tearDown() {
        // Clean up test directory
        if let testDirectory = testDirectory {
            try? FileManager.default.removeItem(at: testDirectory)
        }

        storageManager = nil
        testSpace = nil
        testDirectory = nil

        super.tearDown()
    }

    // MARK: - Disk Usage Tests

    func testGetDiskUsageForEmptySpace() {
        let storageInfo = storageManager.getDiskUsage(for: testSpace)

        XCTAssertEqual(storageInfo.totalSize, 0)
        XCTAssertEqual(storageInfo.versionCount, 0)
        XCTAssertEqual(storageInfo.augmentDirectorySize, 0)
        XCTAssertEqual(storageInfo.originalFilesSize, 0)
        XCTAssertEqual(storageInfo.spaceUtilization, 0.0)
    }

    func testGetDiskUsageWithFiles() throws {
        // Create test files
        let testFile1 = testDirectory.appendingPathComponent("test1.txt")
        let testFile2 = testDirectory.appendingPathComponent("test2.txt")
        let testData = "Test content".data(using: .utf8)!

        try testData.write(to: testFile1)
        try testData.write(to: testFile2)

        // Create version files in .augment directory
        let augmentDir = testDirectory.appendingPathComponent(".augment")
        let versionDir = augmentDir.appendingPathComponent("version_1")
        try FileManager.default.createDirectory(at: versionDir, withIntermediateDirectories: true)

        let versionFile = versionDir.appendingPathComponent("test1.txt")
        try testData.write(to: versionFile)

        let storageInfo = storageManager.getDiskUsage(for: testSpace)

        XCTAssertGreaterThan(storageInfo.totalSize, 0)
        XCTAssertGreaterThan(storageInfo.originalFilesSize, 0)
        XCTAssertGreaterThan(storageInfo.augmentDirectorySize, 0)
        XCTAssertEqual(storageInfo.versionCount, 1)
    }

    func testGetDiskUsageForMultipleSpaces() throws {
        // Create second test space
        let testDirectory2 = FileManager.default.temporaryDirectory
            .appendingPathComponent("AugmentStorageTests2_\(UUID().uuidString)")

        try FileManager.default.createDirectory(
            at: testDirectory2, withIntermediateDirectories: true)

        let testSpace2 = AugmentSpace(
            name: "Test Space 2",
            path: testDirectory2,
            isMonitoring: false
        )

        let spaces = [testSpace, testSpace2]
        let storageInfos = storageManager.getDiskUsage(for: spaces)

        XCTAssertEqual(storageInfos.count, 2)
        XCTAssertNotNil(storageInfos[testSpace.id])
        XCTAssertNotNil(storageInfos[testSpace2.id])

        // Cleanup
        try? FileManager.default.removeItem(at: testDirectory2)
    }

    // MARK: - Storage Policy Tests

    func testStoragePolicyManagement() {
        let policy = StoragePolicy(
            type: .maxSize(5 * 1024 * 1024 * 1024),  // 5GB
            enabled: true,
            warningThreshold: 0.75
        )

        // Set policy
        storageManager.setStoragePolicy(policy, for: testSpace.id)

        // Get policy
        let retrievedPolicy = storageManager.getStoragePolicy(for: testSpace.id)

        XCTAssertTrue(retrievedPolicy.enabled)
        XCTAssertEqual(retrievedPolicy.warningThreshold, 0.75)

        if case .maxSize(let maxBytes) = retrievedPolicy.type {
            XCTAssertEqual(maxBytes, 5 * 1024 * 1024 * 1024)
        } else {
            XCTFail("Policy type should be maxSize")
        }
    }

    func testDefaultStoragePolicy() {
        let defaultPolicy = storageManager.getStoragePolicy(for: UUID())

        XCTAssertTrue(defaultPolicy.enabled)
        XCTAssertEqual(defaultPolicy.warningThreshold, 0.8)

        if case .maxSize(let maxBytes) = defaultPolicy.type {
            XCTAssertEqual(maxBytes, 10 * 1024 * 1024 * 1024)  // 10GB default
        } else {
            XCTFail("Default policy type should be maxSize")
        }
    }

    // MARK: - Policy Enforcement Tests

    func testEnforcePolicyDisabled() {
        let policy = StoragePolicy(
            type: .maxSize(1024),
            enabled: false,
            warningThreshold: 0.8
        )

        let result = storageManager.enforceStoragePolicy(policy, for: testSpace)

        if case .skipped(let message) = result {
            XCTAssertEqual(message, "Policy disabled")
        } else {
            XCTFail("Should skip disabled policy")
        }
    }

    func testEnforcePolicyCompliant() {
        let policy = StoragePolicy(
            type: .maxSize(100 * 1024 * 1024 * 1024),  // 100GB - very large
            enabled: true,
            warningThreshold: 0.8
        )

        let result = storageManager.enforceStoragePolicy(policy, for: testSpace)

        if case .compliant = result {
            // Expected result for empty space
        } else {
            XCTFail("Should be compliant with large limit")
        }
    }

    // MARK: - Cleanup Tests

    func testCleanupOldVersions() throws {
        // Create old version directories
        let augmentDir = testDirectory.appendingPathComponent(".augment")

        // Create old version (2 days ago)
        let oldVersionDir = augmentDir.appendingPathComponent("old_version")
        try FileManager.default.createDirectory(
            at: oldVersionDir, withIntermediateDirectories: true)

        let oldFile = oldVersionDir.appendingPathComponent("old_file.txt")
        try "Old content".write(to: oldFile, atomically: true, encoding: .utf8)

        // Set creation date to 2 days ago
        let twoDaysAgo = Date().addingTimeInterval(-2 * 24 * 3600)
        try FileManager.default.setAttributes(
            [.creationDate: twoDaysAgo], ofItemAtPath: oldVersionDir.path)

        // Create recent version (1 hour ago)
        let recentVersionDir = augmentDir.appendingPathComponent("recent_version")
        try FileManager.default.createDirectory(
            at: recentVersionDir, withIntermediateDirectories: true)

        let recentFile = recentVersionDir.appendingPathComponent("recent_file.txt")
        try "Recent content".write(to: recentFile, atomically: true, encoding: .utf8)

        // Cleanup versions older than 1 day
        let cleanupResult = storageManager.cleanupOldVersions(olderThan: 24 * 3600, in: testSpace)

        XCTAssertTrue(cleanupResult.isSuccessful)
        XCTAssertEqual(cleanupResult.removedVersions, 1)
        XCTAssertGreaterThan(cleanupResult.freedBytes, 0)

        // Verify old version was removed and recent version remains
        XCTAssertFalse(FileManager.default.fileExists(atPath: oldVersionDir.path))
        XCTAssertTrue(FileManager.default.fileExists(atPath: recentVersionDir.path))
    }

    // MARK: - Monitoring Tests

    func testStartStopMonitoring() {
        // Test that monitoring can be started and stopped without crashing
        storageManager.startMonitoring(interval: 1.0)

        // Wait a brief moment to ensure timer is set up
        let expectation = XCTestExpectation(description: "Timer setup")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)

        storageManager.stopMonitoring()
    }

    func testStartMonitoringTwice() {
        // Test that starting monitoring twice doesn't crash
        storageManager.startMonitoring(interval: 1.0)

        // Starting again should not crash or create duplicate timers
        storageManager.startMonitoring(interval: 1.0)

        storageManager.stopMonitoring()
    }

    // MARK: - Storage Info Tests

    func testStorageInfoSummary() {
        let storageInfo = StorageInfo(
            totalSize: 1024 * 1024,  // 1MB
            versionCount: 5,
            oldestVersion: Date().addingTimeInterval(-3600),  // 1 hour ago
            newestVersion: Date(),
            spaceUtilization: 0.5,
            spacePath: testDirectory,
            augmentDirectorySize: 512 * 1024,  // 512KB
            originalFilesSize: 512 * 1024  // 512KB
        )

        let summary = storageInfo.summary

        XCTAssertTrue(summary.contains("Total:"))
        XCTAssertTrue(summary.contains("Versions:"))
        XCTAssertTrue(summary.contains("Original:"))
        XCTAssertTrue(summary.contains("Utilization:"))
        XCTAssertTrue(summary.contains("50.0%"))
    }

    // MARK: - Cleanup Result Tests

    func testCleanupResultSummary() {
        let successfulResult = CleanupResult(
            removedVersions: 3,
            freedBytes: 1024 * 1024,
            errors: []
        )

        XCTAssertTrue(successfulResult.isSuccessful)
        XCTAssertTrue(successfulResult.summary.contains("Removed 3 versions"))

        let failedResult = CleanupResult(
            removedVersions: 1,
            freedBytes: 512,
            errors: [NSError(domain: "test", code: 1, userInfo: nil)]
        )

        XCTAssertFalse(failedResult.isSuccessful)
        XCTAssertTrue(failedResult.summary.contains("Partial cleanup"))
        XCTAssertTrue(failedResult.summary.contains("1 errors"))
    }
}
