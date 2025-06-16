#!/usr/bin/env swift

import Foundation

// Add the current directory to the module search path
let currentDir = FileManager.default.currentDirectoryPath
let augmentCorePath = "\(currentDir)/AugmentCore"

// Import the AugmentCore module
import AugmentCore

/// Debug script to test version history functionality
class VersionHistoryDebugger {
    private let fileManager = FileManager.default
    private let versionControl = VersionControl.shared
    private var testSpace: URL!
    
    func runDebugTest() {
        print("🔍 Starting Version History Debug Test...")
        
        // Create a temporary test space
        setupTestSpace()
        
        // Create test files with versions
        createTestFilesWithVersions()
        
        // Test version retrieval
        testVersionRetrieval()
        
        // Cleanup
        cleanup()
        
        print("✅ Debug test completed!")
    }
    
    private func setupTestSpace() {
        print("\n📁 Setting up test space...")
        
        let tempDir = fileManager.temporaryDirectory
        testSpace = tempDir.appendingPathComponent("VersionHistoryDebugTest")
        
        // Remove existing test space if it exists
        try? fileManager.removeItem(at: testSpace)
        
        // Create new test space
        try! fileManager.createDirectory(at: testSpace, withIntermediateDirectories: true)
        
        // Initialize version control
        let success = versionControl.initializeVersionControl(folderPath: testSpace)
        print("   Version control initialized: \(success)")
        
        // Check if .augment directory was created
        let augmentDir = testSpace.appendingPathComponent(".augment")
        let augmentExists = fileManager.fileExists(atPath: augmentDir.path)
        print("   .augment directory exists: \(augmentExists)")
        
        if augmentExists {
            do {
                let contents = try fileManager.contentsOfDirectory(at: augmentDir, includingPropertiesForKeys: nil)
                print("   .augment contents: \(contents.map { $0.lastPathComponent })")
            } catch {
                print("   Error reading .augment contents: \(error)")
            }
        }
    }
    
    private func createTestFilesWithVersions() {
        print("\n📝 Creating test files with versions...")
        
        // Create test file 1
        let testFile1 = testSpace.appendingPathComponent("test1.txt")
        
        // Version 1
        try! "This is version 1 of test file 1".write(to: testFile1, atomically: true, encoding: .utf8)
        let version1 = versionControl.createFileVersion(filePath: testFile1, comment: "Initial version")
        print("   Created version 1 for test1.txt: \(version1?.id.uuidString ?? "FAILED")")
        
        // Wait a moment to ensure different timestamps
        Thread.sleep(forTimeInterval: 1.0)
        
        // Version 2
        try! "This is version 2 of test file 1 - updated content".write(to: testFile1, atomically: true, encoding: .utf8)
        let version2 = versionControl.createFileVersion(filePath: testFile1, comment: "Updated content")
        print("   Created version 2 for test1.txt: \(version2?.id.uuidString ?? "FAILED")")
        
        // Wait a moment to ensure different timestamps
        Thread.sleep(forTimeInterval: 1.0)
        
        // Version 3
        try! "This is version 3 of test file 1 - final content".write(to: testFile1, atomically: true, encoding: .utf8)
        let version3 = versionControl.createFileVersion(filePath: testFile1, comment: "Final content")
        print("   Created version 3 for test1.txt: \(version3?.id.uuidString ?? "FAILED")")
        
        // Create test file 2
        let testFile2 = testSpace.appendingPathComponent("test2.txt")
        try! "This is test file 2".write(to: testFile2, atomically: true, encoding: .utf8)
        let version2_1 = versionControl.createFileVersion(filePath: testFile2, comment: "Test file 2 version")
        print("   Created version 1 for test2.txt: \(version2_1?.id.uuidString ?? "FAILED")")
    }
    
    private func testVersionRetrieval() {
        print("\n🔍 Testing version retrieval...")
        
        let testFile1 = testSpace.appendingPathComponent("test1.txt")
        let testFile2 = testSpace.appendingPathComponent("test2.txt")
        
        // Test file 1 versions
        print("   Testing test1.txt versions:")
        let versions1 = versionControl.getVersions(filePath: testFile1)
        print("   Found \(versions1.count) versions for test1.txt")
        
        for (index, version) in versions1.enumerated() {
            print("     Version \(index + 1):")
            print("       ID: \(version.id)")
            print("       Timestamp: \(version.timestamp)")
            print("       Comment: \(version.comment ?? "No comment")")
            print("       Storage path: \(version.storagePath.path)")
            print("       Storage exists: \(fileManager.fileExists(atPath: version.storagePath.path))")
        }
        
        // Test file 2 versions
        print("   Testing test2.txt versions:")
        let versions2 = versionControl.getVersions(filePath: testFile2)
        print("   Found \(versions2.count) versions for test2.txt")
        
        for (index, version) in versions2.enumerated() {
            print("     Version \(index + 1):")
            print("       ID: \(version.id)")
            print("       Timestamp: \(version.timestamp)")
            print("       Comment: \(version.comment ?? "No comment")")
            print("       Storage path: \(version.storagePath.path)")
            print("       Storage exists: \(fileManager.fileExists(atPath: version.storagePath.path))")
        }
        
        // Check metadata directories
        print("\n📂 Checking metadata structure:")
        let metadataDir = testSpace.appendingPathComponent(".augment/file_metadata")
        if fileManager.fileExists(atPath: metadataDir.path) {
            do {
                let contents = try fileManager.contentsOfDirectory(at: metadataDir, includingPropertiesForKeys: nil)
                print("   file_metadata contents: \(contents.map { $0.lastPathComponent })")
                
                for dir in contents {
                    if dir.hasDirectoryPath {
                        let subContents = try fileManager.contentsOfDirectory(at: dir, includingPropertiesForKeys: nil)
                        print("     \(dir.lastPathComponent): \(subContents.map { $0.lastPathComponent })")
                    }
                }
            } catch {
                print("   Error reading metadata: \(error)")
            }
        } else {
            print("   file_metadata directory does not exist!")
        }
    }
    
    private func cleanup() {
        print("\n🧹 Cleaning up...")
        try? fileManager.removeItem(at: testSpace)
        print("   Test space removed")
    }
}

// Run the debug test
let debugger = VersionHistoryDebugger()
debugger.runDebugTest()
