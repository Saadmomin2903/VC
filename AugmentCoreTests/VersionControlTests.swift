import XCTest
import Foundation
@testable import AugmentCore

/// Unit tests for VersionControl critical fixes
class VersionControlTests: XCTestCase {
    
    var versionControl: VersionControl!
    var tempDirectory: URL!
    var testSpace: URL!
    
    override func setUp() {
        super.setUp()
        versionControl = VersionControl.shared
        
        // Create temporary directory for testing
        tempDirectory = FileManager.default.temporaryDirectory
            .appendingPathComponent("AugmentVersionTests")
            .appendingPathComponent(UUID().uuidString)
        
        testSpace = tempDirectory.appendingPathComponent("TestSpace")
        
        try! FileManager.default.createDirectory(
            at: testSpace, 
            withIntermediateDirectories: true
        )
        
        // Initialize version control for the test space
        _ = versionControl.initializeVersionControl(folderPath: testSpace)
    }
    
    override func tearDown() {
        // Clean up temporary directory
        try? FileManager.default.removeItem(at: tempDirectory)
        super.tearDown()
    }
    
    /// Test that version control can be initialized
    func testVersionControlInitialization() {
        let newSpace = tempDirectory.appendingPathComponent("NewSpace")
        try! FileManager.default.createDirectory(at: newSpace, withIntermediateDirectories: true)
        
        let success = versionControl.initializeVersionControl(folderPath: newSpace)
        XCTAssertTrue(success, "Version control should initialize successfully")
        
        // Check that .augment directory was created
        let augmentDir = newSpace.appendingPathComponent(".augment")
        XCTAssertTrue(FileManager.default.fileExists(atPath: augmentDir.path))
    }
    
    /// Test atomic folder restoration with successful scenario
    func testAtomicFolderRestorationSuccess() {
        // Create initial files
        let file1 = testSpace.appendingPathComponent("file1.txt")
        let file2 = testSpace.appendingPathComponent("file2.txt")
        
        try! "Initial content 1".write(to: file1, atomically: true, encoding: .utf8)
        try! "Initial content 2".write(to: file2, atomically: true, encoding: .utf8)
        
        // Create first version
        guard let version1 = versionControl.createVersion(
            folderPath: testSpace, 
            comment: "Initial version"
        ) else {
            XCTFail("Failed to create initial version")
            return
        }
        
        // Modify files
        try! "Modified content 1".write(to: file1, atomically: true, encoding: .utf8)
        try! "Modified content 2".write(to: file2, atomically: true, encoding: .utf8)
        
        // Create second version
        guard let version2 = versionControl.createVersion(
            folderPath: testSpace, 
            comment: "Modified version"
        ) else {
            XCTFail("Failed to create modified version")
            return
        }
        
        // Restore to first version
        let restoreSuccess = versionControl.restoreVersion(
            folderPath: testSpace, 
            version: version1
        )
        
        XCTAssertTrue(restoreSuccess, "Restoration should succeed")
        
        // Verify files were restored
        let restoredContent1 = try? String(contentsOf: file1, encoding: .utf8)
        let restoredContent2 = try? String(contentsOf: file2, encoding: .utf8)
        
        XCTAssertEqual(restoredContent1, "Initial content 1")
        XCTAssertEqual(restoredContent2, "Initial content 2")
    }
    
    /// Test atomic folder restoration with failure and rollback
    func testAtomicFolderRestorationWithRollback() {
        // Create initial files
        let file1 = testSpace.appendingPathComponent("file1.txt")
        try! "Original content".write(to: file1, atomically: true, encoding: .utf8)
        
        // Create version
        guard let version = versionControl.createVersion(
            folderPath: testSpace, 
            comment: "Test version"
        ) else {
            XCTFail("Failed to create version")
            return
        }
        
        // Modify the version storage to simulate corruption
        let corruptedVersion = FolderVersion(
            id: UUID(),
            folderPath: testSpace,
            timestamp: Date(),
            comment: "Corrupted version",
            storagePath: URL(fileURLWithPath: "/nonexistent/path")
        )
        
        // Attempt restoration with corrupted version
        let restoreSuccess = versionControl.restoreVersion(
            folderPath: testSpace, 
            version: corruptedVersion
        )
        
        XCTAssertFalse(restoreSuccess, "Restoration should fail with corrupted version")
        
        // Verify original file still exists (rollback worked)
        XCTAssertTrue(FileManager.default.fileExists(atPath: file1.path))
        
        let content = try? String(contentsOf: file1, encoding: .utf8)
        XCTAssertEqual(content, "Original content", "Original content should be preserved after failed restoration")
    }
    
    /// Test file version creation and restoration
    func testFileVersionCreationAndRestoration() {
        let testFile = testSpace.appendingPathComponent("test.txt")
        try! "Original content".write(to: testFile, atomically: true, encoding: .utf8)
        
        // Create file version
        guard let version = versionControl.createFileVersion(
            filePath: testFile, 
            comment: "Original version"
        ) else {
            XCTFail("Failed to create file version")
            return
        }
        
        // Modify file
        try! "Modified content".write(to: testFile, atomically: true, encoding: .utf8)
        
        // Restore file version
        let restoreSuccess = versionControl.restoreVersion(
            filePath: testFile, 
            version: version
        )
        
        XCTAssertTrue(restoreSuccess, "File restoration should succeed")
        
        // Verify content was restored
        let restoredContent = try? String(contentsOf: testFile, encoding: .utf8)
        XCTAssertEqual(restoredContent, "Original content")
    }
    
    /// Test version retrieval
    func testVersionRetrieval() {
        // Create multiple versions
        let file = testSpace.appendingPathComponent("versioned.txt")
        
        try! "Version 1".write(to: file, atomically: true, encoding: .utf8)
        _ = versionControl.createVersion(folderPath: testSpace, comment: "Version 1")
        
        try! "Version 2".write(to: file, atomically: true, encoding: .utf8)
        _ = versionControl.createVersion(folderPath: testSpace, comment: "Version 2")
        
        try! "Version 3".write(to: file, atomically: true, encoding: .utf8)
        _ = versionControl.createVersion(folderPath: testSpace, comment: "Version 3")
        
        // Retrieve versions
        let versions = versionControl.getVersions(folderPath: testSpace)
        
        XCTAssertGreaterThanOrEqual(versions.count, 3, "Should have at least 3 versions")
        
        // Versions should be sorted by timestamp (newest first)
        for i in 0..<(versions.count - 1) {
            XCTAssertGreaterThanOrEqual(
                versions[i].timestamp, 
                versions[i + 1].timestamp,
                "Versions should be sorted by timestamp (newest first)"
            )
        }
    }
    
    /// Test error handling for invalid paths
    func testErrorHandlingInvalidPaths() {
        let invalidPath = URL(fileURLWithPath: "/nonexistent/path")
        
        // Test initialization with invalid path
        let initSuccess = versionControl.initializeVersionControl(folderPath: invalidPath)
        XCTAssertFalse(initSuccess, "Should fail to initialize with invalid path")
        
        // Test version creation with invalid path
        let version = versionControl.createVersion(folderPath: invalidPath)
        XCTAssertNil(version, "Should fail to create version with invalid path")
    }
    
    /// Test concurrent version operations
    func testConcurrentVersionOperations() {
        let expectation = XCTestExpectation(description: "Concurrent operations")
        expectation.expectedFulfillmentCount = 5
        
        let file = testSpace.appendingPathComponent("concurrent.txt")
        try! "Initial".write(to: file, atomically: true, encoding: .utf8)
        
        // Create multiple versions concurrently
        for i in 0..<5 {
            DispatchQueue.global().async {
                try? "Content \(i)".write(to: file, atomically: true, encoding: .utf8)
                _ = self.versionControl.createVersion(
                    folderPath: self.testSpace, 
                    comment: "Concurrent version \(i)"
                )
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 10.0)
        
        // Verify versions were created
        let versions = versionControl.getVersions(folderPath: testSpace)
        XCTAssertGreaterThanOrEqual(versions.count, 5, "Should have created multiple versions")
    }
    
    /// Test memory usage during large operations
    func testMemoryUsageDuringLargeOperations() {
        // Create many small files
        for i in 0..<100 {
            let file = testSpace.appendingPathComponent("file\(i).txt")
            try! "Content \(i)".write(to: file, atomically: true, encoding: .utf8)
        }
        
        // Create version
        let version = versionControl.createVersion(
            folderPath: testSpace, 
            comment: "Large version"
        )
        
        XCTAssertNotNil(version, "Should handle large number of files")
        
        // Verify all files exist
        for i in 0..<100 {
            let file = testSpace.appendingPathComponent("file\(i).txt")
            XCTAssertTrue(FileManager.default.fileExists(atPath: file.path))
        }
    }
}
