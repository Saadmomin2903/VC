#!/usr/bin/env swift

import CryptoKit
import Foundation

// Simple test to verify version loading logic
func testVersionLoading() {
    print("🧪 Testing Version Loading Logic")
    print(String(repeating: "=", count: 40))

    let testFilePath = "/Users/saadmomin/Desktop/auto4 copy 3/app_test_1.txt"
    let fileURL = URL(fileURLWithPath: testFilePath)

    print("📁 Test File: \(testFilePath)")
    print("✅ File exists: \(FileManager.default.fileExists(atPath: testFilePath))")

    // Check for .augment directory
    var currentPath = fileURL.deletingLastPathComponent()
    var foundAugmentSpace = false
    var spacePath: URL?

    print("\n🔍 Searching for .augment directory:")
    while currentPath.path != "/" {
        let augmentDir = currentPath.appendingPathComponent(".augment")
        print("   Checking: \(augmentDir.path)")
        if FileManager.default.fileExists(atPath: augmentDir.path) {
            foundAugmentSpace = true
            spacePath = currentPath
            print("   ✅ Found!")
            break
        }
        currentPath = currentPath.deletingLastPathComponent()
    }

    if foundAugmentSpace, let space = spacePath {
        print("\n✅ Augment space found at: \(space.path)")

        // Check metadata structure
        let metadataDir = space.appendingPathComponent(".augment/file_metadata")
        print("📂 Metadata directory: \(metadataDir.path)")
        print("📂 Directory exists: \(FileManager.default.fileExists(atPath: metadataDir.path))")

        if FileManager.default.fileExists(atPath: metadataDir.path) {
            do {
                let contents = try FileManager.default.contentsOfDirectory(
                    at: metadataDir, includingPropertiesForKeys: nil)
                print("📁 Subdirectories found: \(contents.count)")

                for subdir in contents {
                    print("   📁 \(subdir.lastPathComponent)")

                    // Check if this contains JSON files
                    do {
                        let jsonFiles = try FileManager.default.contentsOfDirectory(
                            at: subdir, includingPropertiesForKeys: nil)
                        let jsonCount = jsonFiles.filter { $0.pathExtension == "json" }.count
                        print("      📄 JSON files: \(jsonCount)")
                    } catch {
                        print("      ❌ Error reading subdirectory: \(error)")
                    }
                }
            } catch {
                print("❌ Error reading metadata directory: \(error)")
            }
        }

        // Calculate expected hash
        let pathData = Data(testFilePath.utf8)
        let hash = pathData.sha256
        print("\n🔢 Expected hash for file path: \(hash)")

        // Check if hash directory exists
        let hashDir = metadataDir.appendingPathComponent(hash)
        print("📁 Hash directory: \(hashDir.path)")
        print("📁 Hash directory exists: \(FileManager.default.fileExists(atPath: hashDir.path))")

    } else {
        print("❌ No Augment space found")
    }
}

extension Data {
    var sha256: String {
        let hash = SHA256.hash(data: self)
        return hash.compactMap { String(format: "%02x", $0) }.joined()
    }
}

testVersionLoading()
