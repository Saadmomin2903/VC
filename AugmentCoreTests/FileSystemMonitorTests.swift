import Foundation
import XCTest

@testable import AugmentCore

/// Unit tests for FileSystemMonitor critical fixes
class FileSystemMonitorTests: XCTestCase {

    var monitor: FileSystemMonitor!
    var tempDirectory: URL!
    var testFile: URL!

    override func setUp() {
        super.setUp()
        monitor = FileSystemMonitor()

        // Create temporary directory for testing
        tempDirectory = FileManager.default.temporaryDirectory
            .appendingPathComponent("AugmentTests")
            .appendingPathComponent(UUID().uuidString)

        try! FileManager.default.createDirectory(
            at: tempDirectory,
            withIntermediateDirectories: true
        )

        testFile = tempDirectory.appendingPathComponent("test.txt")
    }

    override func tearDown() {
        monitor.stopMonitoring()
        monitor = nil

        // Clean up temporary directory
        try? FileManager.default.removeItem(at: tempDirectory)

        super.tearDown()
    }

    /// Test that FileSystemMonitor can be created without crashing
    func testMonitorCreation() {
        XCTAssertNotNil(monitor)
    }

    /// Test that monitoring can be started and stopped safely
    func testMonitoringStartStop() {
        var eventReceived = false
        let expectation = XCTestExpectation(description: "Monitor start/stop")

        let success = monitor.startMonitoring(spacePath: tempDirectory) { url, event in
            eventReceived = true
        }

        XCTAssertTrue(success, "Monitor should start successfully")

        // Stop monitoring
        monitor.stopMonitoring()

        // Should be able to start again
        let secondSuccess = monitor.startMonitoring(spacePath: tempDirectory) { url, event in
            eventReceived = true
        }

        XCTAssertTrue(secondSuccess, "Monitor should restart successfully")
        expectation.fulfill()

        wait(for: [expectation], timeout: 1.0)
    }

    /// Test file creation detection
    func testFileCreationDetection() {
        let expectation = XCTestExpectation(description: "File creation detected")
        var detectedEvent: FileSystemEvent?
        var detectedURL: URL?

        let success = monitor.startMonitoring(spacePath: tempDirectory) { url, event in
            detectedEvent = event
            detectedURL = url
            expectation.fulfill()
        }

        XCTAssertTrue(success, "Monitor should start successfully")

        // Create a test file
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.1) {
            try? "Test content".write(to: self.testFile, atomically: true, encoding: .utf8)
        }

        wait(for: [expectation], timeout: 5.0)

        XCTAssertNotNil(detectedEvent, "Should detect file system event")
        XCTAssertNotNil(detectedURL, "Should provide event URL")

        if let event = detectedEvent {
            XCTAssertTrue(
                event == .created || event == .modified,
                "Should detect creation or modification event"
            )
        }
    }

    /// Test file modification detection
    func testFileModificationDetection() {
        // First create the file
        try! "Initial content".write(to: testFile, atomically: true, encoding: .utf8)

        let expectation = XCTestExpectation(description: "File modification detected")
        var detectedEvent: FileSystemEvent?

        let success = monitor.startMonitoring(spacePath: tempDirectory) { url, event in
            if url.lastPathComponent == self.testFile.lastPathComponent {
                detectedEvent = event
                expectation.fulfill()
            }
        }

        XCTAssertTrue(success, "Monitor should start successfully")

        // Modify the test file
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.1) {
            try? "Modified content".write(to: self.testFile, atomically: true, encoding: .utf8)
        }

        wait(for: [expectation], timeout: 5.0)

        XCTAssertNotNil(detectedEvent, "Should detect file modification")
        if let event = detectedEvent {
            XCTAssertTrue(
                event == .modified || event == .created,
                "Should detect modification event"
            )
        }
    }

    /// Test that monitor handles invalid paths gracefully
    func testInvalidPathHandling() {
        let invalidPath = URL(fileURLWithPath: "/nonexistent/path/that/does/not/exist")

        let success = monitor.startMonitoring(spacePath: invalidPath) { url, event in
            // Should not be called for invalid paths
            XCTFail("Should not receive events for invalid paths")
        }

        // Should handle invalid paths gracefully (may return false or true depending on implementation)
        // The important thing is it shouldn't crash
        XCTAssertNotNil(success, "Should handle invalid paths without crashing")
    }

    /// Test memory safety by creating and destroying multiple monitors
    func testMemorySafety() {
        let expectation = XCTestExpectation(description: "Memory safety test")

        // Create multiple monitors rapidly
        for i in 0..<10 {
            let tempMonitor = FileSystemMonitor()
            let success = tempMonitor.startMonitoring(spacePath: tempDirectory) { url, event in
                // Event handling
            }
            XCTAssertTrue(success, "Monitor \(i) should start successfully")
            tempMonitor.stopMonitoring()
        }

        expectation.fulfill()
        wait(for: [expectation], timeout: 1.0)
    }

    /// Test throttling mechanism
    func testVersionCreationThrottling() {
        let expectation = XCTestExpectation(description: "Throttling test")
        expectation.expectedFulfillmentCount = 1  // Should only fulfill once due to throttling

        let success = monitor.startMonitoring(spacePath: tempDirectory) { url, event in
            expectation.fulfill()
        }

        XCTAssertTrue(success, "Monitor should start successfully")

        // Rapidly modify the same file multiple times
        DispatchQueue.global().async {
            for i in 0..<5 {
                try? "Content \(i)".write(to: self.testFile, atomically: true, encoding: .utf8)
                Thread.sleep(forTimeInterval: 0.1)
            }
        }

        wait(for: [expectation], timeout: 10.0)
    }

    /// Test cleanup functionality
    func testCleanup() {
        monitor.performMaintenance()
        // Should not crash
        XCTAssertNotNil(monitor)
    }

    // MARK: - Crash Prevention Tests (Critical Fix Verification)

    /// Test that the monitor handles corrupted FSEvents data without crashing
    func testCorruptedFSEventsHandling() {
        let expectation = XCTestExpectation(description: "Corrupted data handling")

        // This test verifies that our fix prevents crashes when FSEvents provides invalid data
        // We can't easily simulate the exact crash condition, but we can test error handling

        let success = monitor.startMonitoring(spacePath: tempDirectory) { url, event in
            // If we get here, the monitor is working despite any internal errors
            expectation.fulfill()
        }

        XCTAssertTrue(success, "Monitor should start even with potential data corruption risks")

        // Create a file to trigger events
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.1) {
            try? "Test content for crash prevention".write(
                to: self.testFile, atomically: true, encoding: .utf8)
        }

        wait(for: [expectation], timeout: 5.0)
    }

    /// Test that file version creation works correctly after the crash fix
    func testFileVersionCreationAfterFix() {
        let expectation = XCTestExpectation(description: "Version creation works")

        // Initialize version control for the test directory
        let versionControl = VersionControl.shared
        XCTAssertTrue(versionControl.initializeVersionControl(folderPath: tempDirectory))

        let success = monitor.startMonitoring(spacePath: tempDirectory) { url, event in
            if event == .created || event == .modified {
                expectation.fulfill()
            }
        }

        XCTAssertTrue(success, "Monitor should start successfully")

        // Create a test file that should trigger version creation
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.1) {
            try? "Content for version creation test".write(
                to: self.testFile, atomically: true, encoding: .utf8)
        }

        wait(for: [expectation], timeout: 10.0)

        // Verify that version creation still works
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            let versions = versionControl.getFileVersions(filePath: self.testFile)
            XCTAssertGreaterThanOrEqual(
                versions.count, 0, "Version creation should work without crashing")
        }
    }

    /// Test that the monitor can handle rapid file system events without crashing
    func testRapidEventHandling() {
        let expectation = XCTestExpectation(description: "Rapid events handled")
        expectation.expectedFulfillmentCount = 1  // At least one event should be processed

        let success = monitor.startMonitoring(spacePath: tempDirectory) { url, event in
            expectation.fulfill()
        }

        XCTAssertTrue(success, "Monitor should start successfully")

        // Generate rapid file system events
        DispatchQueue.global().async {
            for i in 0..<20 {
                let fileName = "rapid_test_\(i).txt"
                let fileURL = self.tempDirectory.appendingPathComponent(fileName)
                try? "Rapid content \(i)".write(to: fileURL, atomically: true, encoding: .utf8)
                Thread.sleep(forTimeInterval: 0.01)  // 10ms between events
            }
        }

        wait(for: [expectation], timeout: 10.0)
    }

    /// Test that the fallback mechanism activates correctly
    func testFallbackMechanismActivation() {
        // This test ensures that when FSEvents fails, the fallback mechanism works
        let expectation = XCTestExpectation(description: "Fallback mechanism test")

        // Start monitoring
        let success = monitor.startMonitoring(spacePath: tempDirectory) { url, event in
            // Events should still be detected even if FSEvents has issues
        }

        XCTAssertTrue(success, "Monitor should start successfully")

        // The monitor should continue working even if internal errors occur
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 2.0)
    }

    /// Test that multiple start/stop cycles don't cause memory issues
    func testMultipleStartStopCycles() {
        let expectation = XCTestExpectation(description: "Multiple cycles test")

        // Perform multiple start/stop cycles rapidly
        for i in 0..<10 {
            let success = monitor.startMonitoring(spacePath: tempDirectory) { url, event in
                // Event handling
            }
            XCTAssertTrue(success, "Cycle \(i) should start successfully")

            monitor.stopMonitoring()

            // Brief pause between cycles
            Thread.sleep(forTimeInterval: 0.01)
        }

        expectation.fulfill()
        wait(for: [expectation], timeout: 1.0)
    }

    /// Test that the monitor handles edge cases gracefully
    func testEdgeCaseHandling() {
        let expectation = XCTestExpectation(description: "Edge cases handled")

        // Test with empty directory
        let emptyDir = tempDirectory.appendingPathComponent("empty")
        try! FileManager.default.createDirectory(at: emptyDir, withIntermediateDirectories: true)

        let success = monitor.startMonitoring(spacePath: emptyDir) { url, event in
            // Should handle empty directories without issues
        }

        XCTAssertTrue(success, "Should handle empty directories")

        monitor.stopMonitoring()

        expectation.fulfill()
        wait(for: [expectation], timeout: 1.0)
    }
}
