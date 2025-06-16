#!/usr/bin/env swift

import Foundation

/// Manual test to create a version for the app_test_1.txt file
class ManualVersionTest {
    private let testFilePath: URL

    init() {
        testFilePath = URL(fileURLWithPath: "/Users/saadmomin/Desktop/auto4 copy 3/app_test_1.txt")
    }

    func runTest() {
        print("🧪 MANUAL VERSION CREATION TEST")
        print("=" * 50)
        print("📄 Target file: \(testFilePath.path)")

        // Step 1: Verify file exists
        guard FileManager.default.fileExists(atPath: testFilePath.path) else {
            print("❌ File does not exist!")
            return
        }
        print("✅ File exists")

        // Step 2: Check .augment directory structure
        let parentDir = testFilePath.deletingLastPathComponent()
        let augmentDir = parentDir.appendingPathComponent(".augment")

        print("\n📁 Checking directory structure...")
        let requiredDirs = [
            ".augment",
            ".augment/file_metadata",
            ".augment/file_versions",
        ]

        for dir in requiredDirs {
            let fullPath = parentDir.appendingPathComponent(dir)
            let exists = FileManager.default.fileExists(atPath: fullPath.path)
            print("   \(dir): \(exists ? "✅" : "❌")")

            if !exists {
                print("   🔧 Creating missing directory: \(dir)")
                do {
                    try FileManager.default.createDirectory(
                        at: fullPath, withIntermediateDirectories: true)
                    print("   ✅ Created successfully")
                } catch {
                    print("   ❌ Failed to create: \(error)")
                }
            }
        }

        // Step 3: Calculate file path hash (same as VersionControl)
        let pathData = Data(testFilePath.path.utf8)
        let hash = pathData.sha256
        print("\n🔢 File path hash: \(hash)")

        // Step 4: Check if metadata already exists
        let metadataDir = augmentDir.appendingPathComponent("file_metadata/\(hash)")
        let metadataExists = FileManager.default.fileExists(atPath: metadataDir.path)
        print("📂 Metadata directory exists: \(metadataExists)")
        print("📂 Metadata path: \(metadataDir.path)")

        if metadataExists {
            print("📋 Checking existing metadata files...")
            do {
                let contents = try FileManager.default.contentsOfDirectory(
                    at: metadataDir, includingPropertiesForKeys: nil)
                print("   Found \(contents.count) metadata files:")
                for file in contents {
                    print("   - \(file.lastPathComponent)")
                }
            } catch {
                print("   ❌ Error reading metadata directory: \(error)")
            }
        }

        // Step 5: Simulate version creation
        print("\n🔧 Simulating version creation...")

        // Read file data
        guard let fileData = try? Data(contentsOf: testFilePath) else {
            print("❌ Cannot read file data")
            return
        }

        let fileSize = fileData.count
        let contentHash = fileData.sha256
        print("📊 File size: \(fileSize) bytes")
        print("🔢 Content hash: \(contentHash)")

        // Create version ID and paths
        let versionId = UUID()
        let fileVersionsDir = augmentDir.appendingPathComponent("file_versions/\(hash)")
        let versionFile = fileVersionsDir.appendingPathComponent("\(versionId.uuidString).data")

        print("🆔 Version ID: \(versionId)")
        print("📁 Version storage dir: \(fileVersionsDir.path)")
        print("📄 Version file: \(versionFile.path)")

        // Create version storage directory
        do {
            try FileManager.default.createDirectory(
                at: fileVersionsDir, withIntermediateDirectories: true)
            print("✅ Created version storage directory")
        } catch {
            print("❌ Failed to create version storage directory: \(error)")
            return
        }

        // Write version data
        do {
            try fileData.write(to: versionFile)
            print("✅ Wrote version data to storage")
        } catch {
            print("❌ Failed to write version data: \(error)")
            return
        }

        // Create metadata
        let metadata: [String: Any] = [
            "id": versionId.uuidString,
            "filePath": testFilePath.path,
            "timestamp": ISO8601DateFormatter().string(from: Date()),
            "size": fileSize,
            "comment": "Manual test version",
            "contentHash": contentHash,
            "storagePath": versionFile.path,
        ]

        // Create metadata directory
        do {
            try FileManager.default.createDirectory(
                at: metadataDir, withIntermediateDirectories: true)
            print("✅ Created metadata directory")
        } catch {
            print("❌ Failed to create metadata directory: \(error)")
            return
        }

        // Write metadata file
        let metadataFile = metadataDir.appendingPathComponent("\(versionId.uuidString).json")
        do {
            let jsonData = try JSONSerialization.data(
                withJSONObject: metadata, options: .prettyPrinted)
            try jsonData.write(to: metadataFile)
            print("✅ Wrote metadata file: \(metadataFile.lastPathComponent)")
        } catch {
            print("❌ Failed to write metadata: \(error)")
            return
        }

        print("\n🎉 VERSION CREATION TEST COMPLETED SUCCESSFULLY!")
        print("📋 Summary:")
        print("   - Version ID: \(versionId)")
        print("   - File size: \(fileSize) bytes")
        print("   - Storage: \(versionFile.path)")
        print("   - Metadata: \(metadataFile.path)")

        // Verify the version can be read back
        print("\n🔍 Verification: Reading back the version...")
        if FileManager.default.fileExists(atPath: versionFile.path)
            && FileManager.default.fileExists(atPath: metadataFile.path)
        {
            print("✅ Version files exist and can be accessed")

            // Try to read the metadata back
            if let metadataData = try? Data(contentsOf: metadataFile),
                let readMetadata = try? JSONSerialization.jsonObject(with: metadataData)
                    as? [String: Any]
            {
                print("✅ Metadata can be read back successfully")
                print("   ID: \(readMetadata["id"] ?? "unknown")")
                print("   Comment: \(readMetadata["comment"] ?? "unknown")")
            } else {
                print("❌ Cannot read metadata back")
            }
        } else {
            print("❌ Version files are missing after creation")
        }
    }
}

// Extension for SHA256 hash calculation
extension Data {
    var sha256: String {
        let hash = self.withUnsafeBytes { bytes in
            var hash = [UInt8](repeating: 0, count: 32)
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
    static func * (lhs: String, rhs: Int) -> String {
        return String(repeating: lhs, count: rhs)
    }
}

// Run the test
let test = ManualVersionTest()
test.runTest()
