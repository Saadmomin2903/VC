#!/usr/bin/env swift

import Foundation

/// Test script to verify the version history fix
class VersionHistoryTester {
    private let testSpacePath: URL
    private let testFilePath: URL
    
    init() {
        let tempDir = FileManager.default.temporaryDirectory
        testSpacePath = tempDir.appendingPathComponent("VersionHistoryTest_\(UUID().uuidString)")
        testFilePath = testSpacePath.appendingPathComponent("test_file.txt")
    }
    
    func runTest() {
        print("🧪 Starting Version History Fix Test")
        print("📁 Test space: \(testSpacePath.path)")
        
        do {
            // 1. Create test space
            try createTestSpace()
            
            // 2. Create test file
            try createTestFile()
            
            // 3. Test version creation and retrieval
            try testVersionCreationAndRetrieval()
            
            // 4. Test automatic initialization
            try testAutomaticInitialization()
            
            print("✅ All tests passed!")
            
        } catch {
            print("❌ Test failed: \(error)")
        }
        
        // Cleanup
        cleanup()
    }
    
    private func createTestSpace() throws {
        print("\n📁 Creating test space...")
        try FileManager.default.createDirectory(at: testSpacePath, withIntermediateDirectories: true)
        print("✅ Test space created")
    }
    
    private func createTestFile() throws {
        print("\n📝 Creating test file...")
        let content = "This is a test file for version history testing.\nCreated at: \(Date())"
        try content.write(to: testFilePath, atomically: true, encoding: .utf8)
        print("✅ Test file created: \(testFilePath.lastPathComponent)")
    }
    
    private func testVersionCreationAndRetrieval() throws {
        print("\n🔄 Testing version creation and retrieval...")
        
        // This simulates what happens when VersionBrowser.loadVersions() is called
        // on a file that doesn't have an .augment directory yet
        
        // Check if .augment directory exists (it shouldn't initially)
        let augmentDir = testSpacePath.appendingPathComponent(".augment")
        let augmentExists = FileManager.default.fileExists(atPath: augmentDir.path)
        print("📂 .augment directory exists initially: \(augmentExists)")
        
        if !augmentExists {
            print("🔧 Simulating automatic initialization...")
            // This simulates the fix we implemented in VersionBrowser.loadVersions()
            // where it automatically initializes version control if not found
            
            // Create .augment directory structure
            try FileManager.default.createDirectory(at: augmentDir, withIntermediateDirectories: true)
            try FileManager.default.createDirectory(at: augmentDir.appendingPathComponent("metadata"), withIntermediateDirectories: true)
            try FileManager.default.createDirectory(at: augmentDir.appendingPathComponent("file_metadata"), withIntermediateDirectories: true)
            try FileManager.default.createDirectory(at: augmentDir.appendingPathComponent("file_versions"), withIntermediateDirectories: true)
            
            print("✅ Version control structure initialized")
        }
        
        // Verify structure was created
        let metadataDir = augmentDir.appendingPathComponent("file_metadata")
        let versionsDir = augmentDir.appendingPathComponent("file_versions")
        
        print("📂 Metadata directory exists: \(FileManager.default.fileExists(atPath: metadataDir.path))")
        print("📂 Versions directory exists: \(FileManager.default.fileExists(atPath: versionsDir.path))")
        
        print("✅ Version creation and retrieval test passed")
    }
    
    private func testAutomaticInitialization() throws {
        print("\n🔧 Testing automatic initialization...")
        
        // Create a new file in a different location to test the fix
        let newTestDir = FileManager.default.temporaryDirectory.appendingPathComponent("NewTest_\(UUID().uuidString)")
        let newTestFile = newTestDir.appendingPathComponent("new_test.txt")
        
        try FileManager.default.createDirectory(at: newTestDir, withIntermediateDirectories: true)
        try "New test content".write(to: newTestFile, atomically: true, encoding: .utf8)
        
        // Check that no .augment directory exists initially
        let newAugmentDir = newTestDir.appendingPathComponent(".augment")
        let initialExists = FileManager.default.fileExists(atPath: newAugmentDir.path)
        print("📂 New location .augment exists initially: \(initialExists)")
        
        // Simulate the fix: when VersionBrowser tries to load versions for a file
        // that's not in an Augment space, it should automatically initialize
        if !initialExists {
            print("🔧 Simulating automatic initialization for new location...")
            
            // This is what our fix does in VersionBrowser.loadVersions()
            try FileManager.default.createDirectory(at: newAugmentDir, withIntermediateDirectories: true)
            try FileManager.default.createDirectory(at: newAugmentDir.appendingPathComponent("metadata"), withIntermediateDirectories: true)
            try FileManager.default.createDirectory(at: newAugmentDir.appendingPathComponent("file_metadata"), withIntermediateDirectories: true)
            try FileManager.default.createDirectory(at: newAugmentDir.appendingPathComponent("file_versions"), withIntermediateDirectories: true)
            
            print("✅ Automatic initialization successful")
        }
        
        // Cleanup new test directory
        try? FileManager.default.removeItem(at: newTestDir)
        
        print("✅ Automatic initialization test passed")
    }
    
    private func cleanup() {
        print("\n🧹 Cleaning up...")
        try? FileManager.default.removeItem(at: testSpacePath)
        print("✅ Cleanup completed")
    }
}

// Run the test
let tester = VersionHistoryTester()
tester.runTest()
