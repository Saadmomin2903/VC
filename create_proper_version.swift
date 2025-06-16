#!/usr/bin/env swift

import CryptoKit
import Foundation

/// Creates a proper version using the same SHA256 hash as the app
class ProperVersionCreator {
    private let testFilePath: URL

    init() {
        testFilePath = URL(fileURLWithPath: "/Users/saadmomin/Desktop/auto4 copy 3/app_test_1.txt")
    }

    func createVersion() {
        print("🔧 CREATING PROPER VERSION WITH SHA256 HASH")
        print("=" * 50)
        print("📄 Target file: \(testFilePath.path)")

        // Step 1: Verify file exists
        guard FileManager.default.fileExists(atPath: testFilePath.path) else {
            print("❌ File does not exist!")
            return
        }
        print("✅ File exists")

        // Step 2: Calculate proper SHA256 hash (same as VersionControl)
        let pathData = Data(testFilePath.path.utf8)
        let hash = SHA256.hash(data: pathData)
        let filePathHash = hash.compactMap { String(format: "%02x", $0) }.joined()
        print("🔢 Proper SHA256 hash: \(filePathHash)")

        // Step 3: Set up directory structure
        let parentDir = testFilePath.deletingLastPathComponent()
        let augmentDir = parentDir.appendingPathComponent(".augment")
        let fileMetadataDir = augmentDir.appendingPathComponent("file_metadata/\(filePathHash)")
        let fileVersionsDir = augmentDir.appendingPathComponent("file_versions/\(filePathHash)")

        print("📁 Metadata directory: \(fileMetadataDir.path)")
        print("📁 Versions directory: \(fileVersionsDir.path)")

        // Step 4: Create directories
        do {
            try FileManager.default.createDirectory(
                at: fileMetadataDir, withIntermediateDirectories: true)
            try FileManager.default.createDirectory(
                at: fileVersionsDir, withIntermediateDirectories: true)
            print("✅ Created directories")
        } catch {
            print("❌ Failed to create directories: \(error)")
            return
        }

        // Step 5: Read file data
        guard let fileData = try? Data(contentsOf: testFilePath) else {
            print("❌ Cannot read file data")
            return
        }

        let fileSize = fileData.count
        let contentHash = SHA256.hash(data: fileData)
        let contentHashString = contentHash.compactMap { String(format: "%02x", $0) }.joined()

        print("📊 File size: \(fileSize) bytes")
        print("🔢 Content hash: \(contentHashString)")

        // Step 6: Create version
        let versionId = UUID()
        let versionFile = fileVersionsDir.appendingPathComponent("\(versionId.uuidString).data")
        let metadataFile = fileMetadataDir.appendingPathComponent("\(versionId.uuidString).json")

        print("🆔 Version ID: \(versionId)")
        print("📄 Version file: \(versionFile.path)")
        print("📄 Metadata file: \(metadataFile.path)")

        // Step 7: Write version data
        do {
            try fileData.write(to: versionFile)
            print("✅ Wrote version data")
        } catch {
            print("❌ Failed to write version data: \(error)")
            return
        }

        // Step 8: Create FileVersion object (matching the actual structure)
        let fileVersion = FileVersionData(
            id: versionId,
            filePath: testFilePath,
            timestamp: Date(),
            size: UInt64(fileSize),
            comment: "Proper test version with SHA256",
            contentHash: contentHashString,
            storagePath: versionFile
        )

        // Step 9: Write metadata
        do {
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            encoder.outputFormatting = .prettyPrinted
            let jsonData = try encoder.encode(fileVersion)
            try jsonData.write(to: metadataFile)
            print("✅ Wrote metadata file")
        } catch {
            print("❌ Failed to write metadata: \(error)")
            return
        }

        print("\n🎉 PROPER VERSION CREATED SUCCESSFULLY!")
        print("📋 Summary:")
        print("   - Version ID: \(versionId)")
        print("   - File path hash: \(filePathHash)")
        print("   - Content hash: \(contentHashString)")
        print("   - File size: \(fileSize) bytes")

        // Step 10: Verify the version can be read back
        print("\n🔍 Verification:")
        if FileManager.default.fileExists(atPath: versionFile.path)
            && FileManager.default.fileExists(atPath: metadataFile.path)
        {
            print("✅ Version files exist")

            // Try to read metadata back
            if let metadataData = try? Data(contentsOf: metadataFile),
                let decodedVersion = try? JSONDecoder().decode(
                    FileVersionData.self, from: metadataData)
            {
                print("✅ Metadata can be decoded successfully")
                print("   ID: \(decodedVersion.id)")
                print("   Comment: \(decodedVersion.comment)")
                print("   Timestamp: \(decodedVersion.timestamp)")
            } else {
                print("❌ Cannot decode metadata")
            }
        } else {
            print("❌ Version files are missing")
        }

        print("\n🚀 Now try accessing version history in the app!")
    }
}

// Codable structure matching FileVersion
struct FileVersionData: Codable {
    let id: UUID
    let filePath: URL
    let timestamp: Date
    let size: UInt64
    let comment: String
    let contentHash: String
    let storagePath: URL

    enum CodingKeys: String, CodingKey {
        case id
        case filePath
        case timestamp
        case size
        case comment
        case contentHash
        case storagePath
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(filePath.path, forKey: .filePath)
        try container.encode(timestamp, forKey: .timestamp)
        try container.encode(size, forKey: .size)
        try container.encode(comment, forKey: .comment)
        try container.encode(contentHash, forKey: .contentHash)
        try container.encode(storagePath.path, forKey: .storagePath)
    }
}

// String extension for formatting
extension String {
    static func * (lhs: String, rhs: Int) -> String {
        return String(repeating: lhs, count: rhs)
    }
}

// Run the version creator
let creator = ProperVersionCreator()
creator.createVersion()
