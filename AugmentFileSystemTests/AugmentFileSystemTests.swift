import XCTest
import Foundation
@testable import AugmentFileSystem

/// Unit tests for AugmentFileSystem critical fixes
class AugmentFileSystemTests: XCTestCase {
    
    var fileSystem: AugmentFileSystem!
    var tempDirectory: URL!
    var testSpacePath: URL!
    
    override func setUp() {
        super.setUp()
        fileSystem = AugmentFileSystem.shared
        
        // Create temporary directory for testing
        tempDirectory = FileManager.default.temporaryDirectory
            .appendingPathComponent("AugmentFileSystemTests")
            .appendingPathComponent(UUID().uuidString)
        
        testSpacePath = tempDirectory.appendingPathComponent("TestSpace")
        
        try! FileManager.default.createDirectory(
            at: tempDirectory, 
            withIntermediateDirectories: true
        )
    }
    
    override func tearDown() {
        // Cleanup
        fileSystem.cleanup()
        
        // Clean up temporary directory
        try? FileManager.default.removeItem(at: tempDirectory)
        super.tearDown()
    }
    
    /// Test that file system can be accessed without crashing
    func testFileSystemAccess() {
        XCTAssertNotNil(fileSystem)
        
        let spaces = fileSystem.getSpaces()
        XCTAssertNotNil(spaces)
    }
    
    /// Test space creation with proper monitor management
    func testSpaceCreationWithMonitoring() {
        let spaceName = "Test Space"
        
        // Create space
        guard let space = fileSystem.createSpace(name: spaceName, path: testSpacePath) else {
            XCTFail("Failed to create space")
            return
        }
        
        XCTAssertEqual(space.name, spaceName)
        XCTAssertEqual(space.path, testSpacePath)
        
        // Wait for monitoring to start
        let expectation = XCTestExpectation(description: "Monitoring setup")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2.0)
        
        // Check monitoring status
        let monitoringStatus = fileSystem.getMonitoringStatus()
        XCTAssertTrue(monitoringStatus[space.id] == true, "Space should be monitored")
    }
    
    /// Test space deletion with proper monitor cleanup
    func testSpaceDeletionWithMonitorCleanup() {
        let spaceName = "Test Space for Deletion"
        
        // Create space
        guard let space = fileSystem.createSpace(name: spaceName, path: testSpacePath) else {
            XCTFail("Failed to create space")
            return
        }
        
        // Wait for monitoring to start
        let setupExpectation = XCTestExpectation(description: "Monitoring setup")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            setupExpectation.fulfill()
        }
        wait(for: [setupExpectation], timeout: 2.0)
        
        // Verify monitoring is active
        var monitoringStatus = fileSystem.getMonitoringStatus()
        XCTAssertTrue(monitoringStatus[space.id] == true, "Space should be monitored before deletion")
        
        // Delete space
        let deleteSuccess = fileSystem.deleteSpace(space: space)
        XCTAssertTrue(deleteSuccess, "Space deletion should succeed")
        
        // Wait for cleanup
        let cleanupExpectation = XCTestExpectation(description: "Monitor cleanup")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            cleanupExpectation.fulfill()
        }
        wait(for: [cleanupExpectation], timeout: 2.0)
        
        // Verify monitoring is stopped
        monitoringStatus = fileSystem.getMonitoringStatus()
        XCTAssertTrue(monitoringStatus[space.id] == false || monitoringStatus[space.id] == nil, 
                     "Space should not be monitored after deletion")
    }
    
    /// Test multiple space creation without race conditions
    func testMultipleSpaceCreationThreadSafety() {
        let expectation = XCTestExpectation(description: "Multiple space creation")
        expectation.expectedFulfillmentCount = 5
        
        var createdSpaces: [AugmentSpace] = []
        let spacesLock = NSLock()
        
        // Create multiple spaces concurrently
        for i in 0..<5 {
            DispatchQueue.global().async {
                let spacePath = self.tempDirectory.appendingPathComponent("Space\(i)")
                if let space = self.fileSystem.createSpace(name: "Space \(i)", path: spacePath) {
                    spacesLock.lock()
                    createdSpaces.append(space)
                    spacesLock.unlock()
                }
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 10.0)
        
        // Verify all spaces were created
        XCTAssertEqual(createdSpaces.count, 5, "All spaces should be created")
        
        // Wait for monitoring setup
        let monitoringExpectation = XCTestExpectation(description: "Monitoring setup")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            monitoringExpectation.fulfill()
        }
        wait(for: [monitoringExpectation], timeout: 3.0)
        
        // Verify all spaces are being monitored
        let monitoringStatus = fileSystem.getMonitoringStatus()
        for space in createdSpaces {
            XCTAssertTrue(monitoringStatus[space.id] == true, "Space \(space.name) should be monitored")
        }
    }
    
    /// Test file system event handling
    func testFileSystemEventHandling() {
        let spaceName = "Event Test Space"
        
        // Create space
        guard let space = fileSystem.createSpace(name: spaceName, path: testSpacePath) else {
            XCTFail("Failed to create space")
            return
        }
        
        // Wait for monitoring to start
        let setupExpectation = XCTestExpectation(description: "Monitoring setup")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            setupExpectation.fulfill()
        }
        wait(for: [setupExpectation], timeout: 2.0)
        
        // Create a test file to trigger events
        let testFile = testSpacePath.appendingPathComponent("test.txt")
        
        let fileCreationExpectation = XCTestExpectation(description: "File creation")
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.5) {
            try? "Test content".write(to: testFile, atomically: true, encoding: .utf8)
            fileCreationExpectation.fulfill()
        }
        
        wait(for: [fileCreationExpectation], timeout: 5.0)
        
        // Verify file exists
        XCTAssertTrue(FileManager.default.fileExists(atPath: testFile.path))
    }
    
    /// Test cleanup functionality
    func testCleanupFunctionality() {
        let spaceName = "Cleanup Test Space"
        
        // Create space
        guard let space = fileSystem.createSpace(name: spaceName, path: testSpacePath) else {
            XCTFail("Failed to create space")
            return
        }
        
        // Wait for monitoring to start
        let setupExpectation = XCTestExpectation(description: "Monitoring setup")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            setupExpectation.fulfill()
        }
        wait(for: [setupExpectation], timeout: 2.0)
        
        // Verify monitoring is active
        var monitoringStatus = fileSystem.getMonitoringStatus()
        XCTAssertTrue(monitoringStatus[space.id] == true, "Space should be monitored")
        
        // Call cleanup
        fileSystem.cleanup()
        
        // Wait for cleanup to complete
        let cleanupExpectation = XCTestExpectation(description: "Cleanup completion")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            cleanupExpectation.fulfill()
        }
        wait(for: [cleanupExpectation], timeout: 2.0)
        
        // Verify all monitoring is stopped
        monitoringStatus = fileSystem.getMonitoringStatus()
        for (_, isMonitored) in monitoringStatus {
            XCTAssertFalse(isMonitored, "No spaces should be monitored after cleanup")
        }
    }
    
    /// Test invalid space creation
    func testInvalidSpaceCreation() {
        // Test with invalid URL
        let invalidPath = URL(string: "not-a-file-url")!
        let space = fileSystem.createSpace(name: "Invalid", path: invalidPath)
        XCTAssertNil(space, "Should not create space with invalid URL")
        
        // Test with duplicate path
        guard let firstSpace = fileSystem.createSpace(name: "First", path: testSpacePath) else {
            XCTFail("Failed to create first space")
            return
        }
        
        let duplicateSpace = fileSystem.createSpace(name: "Duplicate", path: testSpacePath)
        XCTAssertNil(duplicateSpace, "Should not create space with duplicate path")
        
        // Cleanup
        _ = fileSystem.deleteSpace(space: firstSpace)
    }
    
    /// Test space retrieval
    func testSpaceRetrieval() {
        let spaceName = "Retrieval Test Space"
        
        // Create space
        guard let space = fileSystem.createSpace(name: spaceName, path: testSpacePath) else {
            XCTFail("Failed to create space")
            return
        }
        
        // Test getSpace by path
        let retrievedSpace = fileSystem.getSpace(path: testSpacePath)
        XCTAssertNotNil(retrievedSpace)
        XCTAssertEqual(retrievedSpace?.id, space.id)
        XCTAssertEqual(retrievedSpace?.name, spaceName)
        
        // Test getSpaces
        let allSpaces = fileSystem.getSpaces()
        XCTAssertTrue(allSpaces.contains { $0.id == space.id })
    }
}
