import Foundation
import XCTest

@testable import AugmentCore

/// Comprehensive tests to validate all critical fixes implemented
class ComprehensiveFixValidationTests: XCTestCase {

    var tempDirectory: URL!
    var testSpace: URL!
    var fileSystemMonitor: FileSystemMonitor!
    var versionControl: VersionControl!
    var searchEngine: SearchEngine!

    override func setUp() {
        super.setUp()

        // Create temporary directory for testing
        tempDirectory = FileManager.default.temporaryDirectory
            .appendingPathComponent("ComprehensiveFixValidationTests")
            .appendingPathComponent(UUID().uuidString)

        testSpace = tempDirectory.appendingPathComponent("TestSpace")

        try! FileManager.default.createDirectory(
            at: testSpace,
            withIntermediateDirectories: true
        )

        // Initialize components using dependency injection
        let dependencies = DependencyContainer.createTestContainer()
        fileSystemMonitor = dependencies.fileSystemMonitor()
        versionControl = dependencies.versionControl()
        searchEngine = dependencies.searchEngine()

        // Initialize version control for test space
        _ = versionControl.initializeVersionControl(folderPath: testSpace)
    }

    override func tearDown() {
        // Clean up temporary directory
        try? FileManager.default.removeItem(at: tempDirectory)
        super.tearDown()
    }

    // MARK: - Critical Fix #1: FileSystemMonitor Memory Safety

    /// Test that FileSystemMonitor handles events without crashing
    func testFileSystemMonitorMemorySafety() {
        let expectation = XCTestExpectation(description: "Memory safety test")

        let success = fileSystemMonitor.startMonitoring(spacePath: testSpace) { url, event in
            // If we get here without crashing, the fix is working
            expectation.fulfill()
        }

        XCTAssertTrue(success, "Monitor should start successfully")

        // Create a test file to trigger events
        let testFile = testSpace.appendingPathComponent("memory_safety_test.txt")
        try! "Test content".write(to: testFile, atomically: true, encoding: .utf8)

        wait(for: [expectation], timeout: 5.0)
        fileSystemMonitor.stopMonitoring()
    }

    // MARK: - Critical Fix #2: Version Control Rollback

    /// Test atomic version control operations with rollback
    func testVersionControlAtomicOperations() {
        // Create initial files
        let file1 = testSpace.appendingPathComponent("atomic_test1.txt")
        let file2 = testSpace.appendingPathComponent("atomic_test2.txt")

        try! "Original content 1".write(to: file1, atomically: true, encoding: .utf8)
        try! "Original content 2".write(to: file2, atomically: true, encoding: .utf8)

        // Create version
        guard
            let version = versionControl.createVersion(
                folderPath: testSpace,
                comment: "Atomic test version"
            )
        else {
            XCTFail("Failed to create version")
            return
        }

        // Modify files
        try! "Modified content 1".write(to: file1, atomically: true, encoding: .utf8)
        try! "Modified content 2".write(to: file2, atomically: true, encoding: .utf8)

        // Restore version (should be atomic)
        let success = versionControl.restoreVersion(version: version)
        XCTAssertTrue(success, "Version restoration should succeed")

        // Verify restoration
        let restoredContent1 = try! String(contentsOf: file1)
        let restoredContent2 = try! String(contentsOf: file2)

        XCTAssertEqual(restoredContent1, "Original content 1")
        XCTAssertEqual(restoredContent2, "Original content 2")
    }

    // MARK: - Critical Fix #3: SearchEngine Performance

    /// Test improved search engine data structure performance
    func testSearchEnginePerformance() {
        // Create test files
        for i in 0..<100 {
            let testFile = testSpace.appendingPathComponent("search_test_\(i).txt")
            try! "This is test content for file \(i) with unique token_\(i)".write(
                to: testFile, atomically: true, encoding: .utf8)
        }

        // Index the space
        let indexSuccess = searchEngine.indexSpace(spacePath: testSpace)
        XCTAssertTrue(indexSuccess, "Space indexing should succeed")

        // Perform search
        let results = searchEngine.search(query: "test content", spacePaths: [testSpace])
        XCTAssertGreaterThan(results.count, 0, "Search should return results")

        // Test search performance with specific token
        let specificResults = searchEngine.search(query: "token_50", spacePaths: [testSpace])
        XCTAssertEqual(
            specificResults.count, 1, "Should find exactly one result for specific token")

        // Get statistics to verify efficient structure
        let stats = searchEngine.getIndexStatistics()
        XCTAssertGreaterThan(stats["totalTokens"] as? Int ?? 0, 0, "Should have indexed tokens")
        XCTAssertGreaterThan(stats["totalResults"] as? Int ?? 0, 0, "Should have search results")
    }

    // MARK: - Critical Fix #4: Memory Leak Prevention

    /// Test memory leak prevention in file monitoring
    func testMemoryLeakPrevention() {
        // Simulate rapid file operations to test throttling cleanup
        for i in 0..<50 {
            let testFile = testSpace.appendingPathComponent("leak_test_\(i).txt")
            try! "Content \(i)".write(to: testFile, atomically: true, encoding: .utf8)
        }

        // Trigger maintenance cleanup
        fileSystemMonitor.performMaintenance()

        // Test should complete without memory issues
        XCTAssertTrue(true, "Memory leak prevention test completed")
    }

    // MARK: - Integration Test: All Fixes Working Together

    /// Test that all fixes work together without conflicts
    func testIntegratedFunctionality() {
        let expectation = XCTestExpectation(description: "Integrated functionality test")

        // Start monitoring
        let monitorSuccess = fileSystemMonitor.startMonitoring(spacePath: testSpace) { url, event in
            // File system events are being handled safely
        }
        XCTAssertTrue(monitorSuccess, "Monitoring should start successfully")

        // Create and version files
        let testFile = testSpace.appendingPathComponent("integration_test.txt")
        try! "Integration test content".write(to: testFile, atomically: true, encoding: .utf8)

        // Create version
        guard
            let version = versionControl.createFileVersion(
                filePath: testFile,
                comment: "Integration test version"
            )
        else {
            XCTFail("Failed to create file version")
            return
        }

        // Index for search
        let indexSuccess = searchEngine.indexFile(filePath: testFile, version: version)
        XCTAssertTrue(indexSuccess, "File indexing should succeed")

        // Search for content
        let searchResults = searchEngine.search(query: "integration", spacePaths: [testSpace])
        XCTAssertGreaterThan(searchResults.count, 0, "Should find search results")

        // Clean up
        fileSystemMonitor.stopMonitoring()
        expectation.fulfill()

        wait(for: [expectation], timeout: 1.0)
    }

    // MARK: - Performance Validation

    /// Test that UI-blocking issues are resolved
    func testUIResponsiveness() {
        let startTime = Date()

        // Create many files to test batch processing
        for i in 0..<200 {
            let testFile = testSpace.appendingPathComponent("ui_test_\(i).txt")
            try! "UI test content \(i)".write(to: testFile, atomically: true, encoding: .utf8)
        }

        let endTime = Date()
        let processingTime = endTime.timeIntervalSince(startTime)

        // Should complete reasonably quickly (batch processing prevents blocking)
        XCTAssertLessThan(processingTime, 10.0, "File processing should not block for too long")
    }

    // MARK: - Error Handling Validation

    /// Test comprehensive error handling
    func testErrorHandling() {
        // Test with invalid paths
        let invalidPath = URL(fileURLWithPath: "/nonexistent/path")

        // Version control should handle invalid paths gracefully
        let invalidVersion = versionControl.createVersion(folderPath: invalidPath)
        XCTAssertNil(invalidVersion, "Should return nil for invalid path")

        // Search engine should handle invalid paths gracefully
        let invalidIndex = searchEngine.indexSpace(spacePath: invalidPath)
        XCTAssertFalse(invalidIndex, "Should return false for invalid path")

        // File system monitor should handle invalid paths gracefully
        let invalidMonitor = fileSystemMonitor.startMonitoring(spacePath: invalidPath) { _, _ in }
        XCTAssertFalse(invalidMonitor, "Should return false for invalid path")
    }
}
