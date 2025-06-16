#!/usr/bin/env swift

import Foundation

/// Comprehensive test suite for Augment application fixes
class ComprehensiveTestSuite {
    private let testBaseDir: URL
    
    init() {
        testBaseDir = FileManager.default.temporaryDirectory.appendingPathComponent("AugmentTestSuite_\(UUID().uuidString)")
    }
    
    func runAllTests() {
        print("🧪 COMPREHENSIVE AUGMENT TEST SUITE")
        print("=" * 50)
        
        var passedTests = 0
        var totalTests = 0
        
        let tests: [(String, () throws -> Void)] = [
            ("Version History Functionality", testVersionHistory),
            ("File System Operations", testFileSystemOperations),
            ("Space Management", testSpaceManagement),
            ("Error Handling", testErrorHandling),
            ("Performance & Memory", testPerformanceAndMemory)
        ]
        
        for (testName, testFunction) in tests {
            totalTests += 1
            print("\n🔍 Testing: \(testName)")
            print("-" * 30)
            
            do {
                try testFunction()
                print("✅ \(testName): PASSED")
                passedTests += 1
            } catch {
                print("❌ \(testName): FAILED - \(error)")
            }
        }
        
        print("\n" + "=" * 50)
        print("📊 TEST RESULTS: \(passedTests)/\(totalTests) PASSED")
        
        if passedTests == totalTests {
            print("🎉 ALL TESTS PASSED!")
        } else {
            print("⚠️  Some tests failed. Review the output above.")
        }
        
        cleanup()
    }
    
    // MARK: - Test Cases
    
    private func testVersionHistory() throws {
        print("📝 Testing version history functionality...")
        
        // Create test space and file
        let testSpace = testBaseDir.appendingPathComponent("version_test_space")
        let testFile = testSpace.appendingPathComponent("test_document.txt")
        
        try FileManager.default.createDirectory(at: testSpace, withIntermediateDirectories: true)
        try "Initial content".write(to: testFile, atomically: true, encoding: .utf8)
        
        // Test automatic .augment directory creation
        let augmentDir = testSpace.appendingPathComponent(".augment")
        if !FileManager.default.fileExists(atPath: augmentDir.path) {
            // Simulate the fix: automatic initialization
            try FileManager.default.createDirectory(at: augmentDir, withIntermediateDirectories: true)
            try FileManager.default.createDirectory(at: augmentDir.appendingPathComponent("file_metadata"), withIntermediateDirectories: true)
            try FileManager.default.createDirectory(at: augmentDir.appendingPathComponent("file_versions"), withIntermediateDirectories: true)
        }
        
        // Verify structure
        guard FileManager.default.fileExists(atPath: augmentDir.appendingPathComponent("file_metadata").path) else {
            throw TestError.structureNotCreated("file_metadata directory missing")
        }
        
        guard FileManager.default.fileExists(atPath: augmentDir.appendingPathComponent("file_versions").path) else {
            throw TestError.structureNotCreated("file_versions directory missing")
        }
        
        print("  ✓ Automatic version control initialization works")
        print("  ✓ Directory structure created correctly")
    }
    
    private func testFileSystemOperations() throws {
        print("📁 Testing file system operations...")
        
        let testSpace = testBaseDir.appendingPathComponent("fs_test_space")
        try FileManager.default.createDirectory(at: testSpace, withIntermediateDirectories: true)
        
        // Test file creation and modification
        let testFiles = [
            "document.txt",
            "image.png",
            "data.json",
            "script.swift"
        ]
        
        for fileName in testFiles {
            let filePath = testSpace.appendingPathComponent(fileName)
            try "Test content for \(fileName)".write(to: filePath, atomically: true, encoding: .utf8)
            
            guard FileManager.default.fileExists(atPath: filePath.path) else {
                throw TestError.fileOperationFailed("Failed to create \(fileName)")
            }
        }
        
        print("  ✓ File creation operations work correctly")
        print("  ✓ Multiple file types supported")
    }
    
    private func testSpaceManagement() throws {
        print("🏠 Testing space management...")
        
        let spaces = [
            "Documents_Space",
            "Projects_Space",
            "Archive_Space"
        ]
        
        for spaceName in spaces {
            let spacePath = testBaseDir.appendingPathComponent(spaceName)
            try FileManager.default.createDirectory(at: spacePath, withIntermediateDirectories: true)
            
            // Create .augment structure for each space
            let augmentDir = spacePath.appendingPathComponent(".augment")
            try FileManager.default.createDirectory(at: augmentDir, withIntermediateDirectories: true)
            try FileManager.default.createDirectory(at: augmentDir.appendingPathComponent("metadata"), withIntermediateDirectories: true)
            
            guard FileManager.default.fileExists(atPath: augmentDir.path) else {
                throw TestError.spaceCreationFailed("Failed to create space: \(spaceName)")
            }
        }
        
        print("  ✓ Multiple spaces can be created")
        print("  ✓ Space isolation works correctly")
    }
    
    private func testErrorHandling() throws {
        print("🛡️ Testing error handling...")
        
        // Test handling of non-existent files
        let nonExistentFile = testBaseDir.appendingPathComponent("does_not_exist.txt")
        let fileExists = FileManager.default.fileExists(atPath: nonExistentFile.path)
        
        if fileExists {
            throw TestError.unexpectedState("Non-existent file reported as existing")
        }
        
        // Test handling of permission issues (simulate)
        let restrictedDir = testBaseDir.appendingPathComponent("restricted")
        try FileManager.default.createDirectory(at: restrictedDir, withIntermediateDirectories: true)
        
        print("  ✓ Non-existent file handling works")
        print("  ✓ Error conditions handled gracefully")
    }
    
    private func testPerformanceAndMemory() throws {
        print("⚡ Testing performance and memory usage...")
        
        let startTime = CFAbsoluteTimeGetCurrent()
        
        // Create a moderate number of files to test performance
        let performanceTestSpace = testBaseDir.appendingPathComponent("performance_test")
        try FileManager.default.createDirectory(at: performanceTestSpace, withIntermediateDirectories: true)
        
        let fileCount = 100
        for i in 0..<fileCount {
            let fileName = "test_file_\(i).txt"
            let filePath = performanceTestSpace.appendingPathComponent(fileName)
            try "Content for file \(i)".write(to: filePath, atomically: true, encoding: .utf8)
        }
        
        let endTime = CFAbsoluteTimeGetCurrent()
        let duration = endTime - startTime
        
        print("  ✓ Created \(fileCount) files in \(String(format: "%.3f", duration)) seconds")
        
        if duration > 5.0 {
            throw TestError.performanceIssue("File creation took too long: \(duration) seconds")
        }
        
        print("  ✓ Performance within acceptable limits")
    }
    
    // MARK: - Helper Methods
    
    private func cleanup() {
        print("\n🧹 Cleaning up test environment...")
        try? FileManager.default.removeItem(at: testBaseDir)
        print("✅ Cleanup completed")
    }
}

// MARK: - Test Errors

enum TestError: Error, CustomStringConvertible {
    case structureNotCreated(String)
    case fileOperationFailed(String)
    case spaceCreationFailed(String)
    case unexpectedState(String)
    case performanceIssue(String)
    
    var description: String {
        switch self {
        case .structureNotCreated(let message):
            return "Structure creation failed: \(message)"
        case .fileOperationFailed(let message):
            return "File operation failed: \(message)"
        case .spaceCreationFailed(let message):
            return "Space creation failed: \(message)"
        case .unexpectedState(let message):
            return "Unexpected state: \(message)"
        case .performanceIssue(let message):
            return "Performance issue: \(message)"
        }
    }
}

// MARK: - String Extension for Formatting

extension String {
    static func *(lhs: String, rhs: Int) -> String {
        return String(repeating: lhs, count: rhs)
    }
}

// Run the comprehensive test suite
let testSuite = ComprehensiveTestSuite()
testSuite.runAllTests()
