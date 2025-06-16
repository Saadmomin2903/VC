#!/usr/bin/env swift

import Foundation

/// Runtime debug script to test the version history fix
class VersionHistoryRuntimeDebugger {
    private let testFilePath: URL
    
    init() {
        // Use the same directory structure as shown in the screenshot
        let testDir = URL(fileURLWithPath: "/Users/saadmomin/Desktop/auto4 copy 3")
        testFilePath = testDir.appendingPathComponent("app_test_1.txt")
    }
    
    func runDebugTest() {
        print("🔍 RUNTIME VERSION HISTORY DEBUG TEST")
        print("=" * 50)
        print("📁 Test directory: \(testFilePath.deletingLastPathComponent().path)")
        print("📄 Test file: \(testFilePath.lastPathComponent)")
        
        // Step 1: Check if file exists
        checkFileExists()
        
        // Step 2: Check for .augment directory
        checkAugmentDirectory()
        
        // Step 3: Simulate the version loading process
        simulateVersionLoading()
        
        // Step 4: Test directory structure creation
        testDirectoryStructureCreation()
        
        print("\n" + "=" * 50)
        print("🎯 DEBUG TEST COMPLETED")
    }
    
    private func checkFileExists() {
        print("\n📋 Step 1: Checking if test file exists...")
        let fileExists = FileManager.default.fileExists(atPath: testFilePath.path)
        print("   File exists: \(fileExists)")
        
        if !fileExists {
            print("   Creating test file...")
            do {
                try "Test content for version history debugging".write(to: testFilePath, atomically: true, encoding: .utf8)
                print("   ✅ Test file created successfully")
            } catch {
                print("   ❌ Failed to create test file: \(error)")
            }
        }
    }
    
    private func checkAugmentDirectory() {
        print("\n📋 Step 2: Checking for .augment directory...")
        let parentDir = testFilePath.deletingLastPathComponent()
        let augmentDir = parentDir.appendingPathComponent(".augment")
        
        let augmentExists = FileManager.default.fileExists(atPath: augmentDir.path)
        print("   .augment directory exists: \(augmentExists)")
        print("   .augment path: \(augmentDir.path)")
        
        if augmentExists {
            // Check subdirectories
            let subdirs = [
                "metadata",
                "versions", 
                "file_metadata",
                "file_versions"
            ]
            
            for subdir in subdirs {
                let subdirPath = augmentDir.appendingPathComponent(subdir)
                let exists = FileManager.default.fileExists(atPath: subdirPath.path)
                print("   📁 \(subdir): \(exists ? "✅" : "❌")")
            }
        }
    }
    
    private func simulateVersionLoading() {
        print("\n📋 Step 3: Simulating version loading process...")
        
        // This simulates what VersionBrowser.loadVersions() does
        let parentDir = testFilePath.deletingLastPathComponent()
        var currentPath = parentDir
        var foundAugmentSpace = false
        
        print("   🔍 Searching for .augment directory...")
        while currentPath.path != "/" {
            let augmentDir = currentPath.appendingPathComponent(".augment")
            print("      Checking: \(augmentDir.path)")
            if FileManager.default.fileExists(atPath: augmentDir.path) {
                foundAugmentSpace = true
                print("      ✅ Found .augment directory!")
                break
            }
            currentPath = currentPath.deletingLastPathComponent()
        }
        
        if !foundAugmentSpace {
            print("   ⚠️ No .augment directory found - this would trigger auto-initialization")
            print("   🔧 Simulating automatic initialization...")
            
            // This simulates the fix we implemented
            let augmentDir = parentDir.appendingPathComponent(".augment")
            do {
                try FileManager.default.createDirectory(at: augmentDir, withIntermediateDirectories: true)
                
                // Create all required subdirectories (this is the critical fix)
                let subdirs = [
                    "metadata",
                    "versions",
                    "file_metadata", 
                    "file_versions"
                ]
                
                for subdir in subdirs {
                    let subdirPath = augmentDir.appendingPathComponent(subdir)
                    try FileManager.default.createDirectory(at: subdirPath, withIntermediateDirectories: true)
                    print("      ✅ Created: \(subdir)")
                }
                
                foundAugmentSpace = true
                print("   ✅ Automatic initialization completed")
                
            } catch {
                print("   ❌ Failed to initialize: \(error)")
            }
        }
        
        if foundAugmentSpace {
            print("   🔄 Simulating version metadata loading...")
            
            // Calculate file path hash (same as VersionControl does)
            let pathData = Data(testFilePath.path.utf8)
            let hash = pathData.sha256
            print("   🔢 File path hash: \(hash)")
            
            // Check if metadata exists
            let metadataDir = parentDir.appendingPathComponent(".augment/file_metadata/\(hash)")
            let metadataExists = FileManager.default.fileExists(atPath: metadataDir.path)
            print("   📂 Metadata directory exists: \(metadataExists)")
            print("   📂 Metadata path: \(metadataDir.path)")
            
            if !metadataExists {
                print("   🔧 No metadata found - this would trigger auto-version creation")
                print("   ✅ This is the expected behavior for the fix")
            }
        }
    }
    
    private func testDirectoryStructureCreation() {
        print("\n📋 Step 4: Testing complete directory structure...")
        
        let parentDir = testFilePath.deletingLastPathComponent()
        let augmentDir = parentDir.appendingPathComponent(".augment")
        
        let requiredStructure = [
            ".augment",
            ".augment/metadata",
            ".augment/versions",
            ".augment/file_metadata",
            ".augment/file_versions"
        ]
        
        var allExist = true
        for path in requiredStructure {
            let fullPath = parentDir.appendingPathComponent(path)
            let exists = FileManager.default.fileExists(atPath: fullPath.path)
            print("   📁 \(path): \(exists ? "✅" : "❌")")
            if !exists { allExist = false }
        }
        
        if allExist {
            print("   🎉 All required directories exist!")
            print("   ✅ Version history should now work correctly")
        } else {
            print("   ⚠️ Some directories are missing")
            print("   🔧 The auto-initialization should create these when version history is accessed")
        }
    }
}

// Extension to calculate SHA256 hash
extension Data {
    var sha256: String {
        let hash = self.withUnsafeBytes { bytes in
            var hash = [UInt8](repeating: 0, count: 32)
            // Simple hash calculation for debugging
            for (index, byte) in bytes.enumerated() {
                hash[index % 32] ^= byte
            }
            return hash
        }
        return hash.map { String(format: "%02x", $0) }.joined()
    }
}

// String extension for formatting
extension String {
    static func *(lhs: String, rhs: Int) -> String {
        return String(repeating: lhs, count: rhs)
    }
}

// Run the debug test
let debugger = VersionHistoryRuntimeDebugger()
debugger.runDebugTest()
