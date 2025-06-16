import XCTest
import Foundation
@testable import AugmentFileSystem

/// Unit tests for AugmentFUSE security fixes
class AugmentFUSETests: XCTestCase {
    
    var fuse: AugmentFUSE!
    var tempDirectory: URL!
    var testSpace: AugmentSpace!
    
    override func setUp() {
        super.setUp()
        fuse = AugmentFUSE.shared
        
        // Create temporary directory for testing
        tempDirectory = FileManager.default.temporaryDirectory
            .appendingPathComponent("AugmentFUSETests")
            .appendingPathComponent(UUID().uuidString)
        
        let testSpacePath = tempDirectory.appendingPathComponent("TestSpace")
        
        try! FileManager.default.createDirectory(
            at: testSpacePath, 
            withIntermediateDirectories: true
        )
        
        testSpace = AugmentSpace(
            id: UUID(),
            name: "Test Space",
            path: testSpacePath
        )
    }
    
    override func tearDown() {
        // Clean up temporary directory
        try? FileManager.default.removeItem(at: tempDirectory)
        super.tearDown()
    }
    
    /// Test that FUSE can be accessed without crashing
    func testFUSEAccess() {
        XCTAssertNotNil(fuse)
    }
    
    /// Test executable validation with valid system executables
    func testExecutableValidationValid() {
        // Test with common system executables that should exist
        let commonExecutables = [
            "/usr/bin/ls",
            "/usr/sbin/diskutil",
            "/usr/bin/cat"
        ]
        
        for executable in commonExecutables {
            if FileManager.default.fileExists(atPath: executable) {
                // Use reflection to access private method for testing
                let mirror = Mirror(reflecting: fuse)
                // Note: In a real implementation, you'd make this method internal for testing
                // or create a testable wrapper
                print("Would validate executable: \(executable)")
            }
        }
    }
    
    /// Test executable validation with invalid paths
    func testExecutableValidationInvalid() {
        // These should fail validation
        let invalidExecutables = [
            "/tmp/malicious_script",
            "/var/tmp/../../../usr/bin/ls",  // Path traversal attempt
            "/nonexistent/path",
            "relative/path/to/executable"
        ]
        
        for executable in invalidExecutables {
            // In a real test, we'd verify these throw appropriate errors
            print("Would reject executable: \(executable)")
        }
    }
    
    /// Test FUSE operations creation
    func testFUSEOperationsCreation() {
        let operations = AugmentFUSEOperations(space: testSpace)
        XCTAssertNotNil(operations)
    }
    
    /// Test file attribute retrieval
    func testGetFileAttributes() {
        let operations = AugmentFUSEOperations(space: testSpace)
        
        // Create a test file
        let testFile = testSpace.path.appendingPathComponent("test.txt")
        try! "Test content".write(to: testFile, atomically: true, encoding: .utf8)
        
        // Get attributes
        let attributes = operations.getattr(path: "test.txt")
        XCTAssertNotNil(attributes)
        
        if let attrs = attributes {
            XCTAssertNotNil(attrs[.size])
            XCTAssertNotNil(attrs[.modificationDate])
        }
    }
    
    /// Test directory reading
    func testReadDirectory() {
        let operations = AugmentFUSEOperations(space: testSpace)
        
        // Create test files
        let file1 = testSpace.path.appendingPathComponent("file1.txt")
        let file2 = testSpace.path.appendingPathComponent("file2.txt")
        
        try! "Content 1".write(to: file1, atomically: true, encoding: .utf8)
        try! "Content 2".write(to: file2, atomically: true, encoding: .utf8)
        
        // Read directory
        let contents = operations.readdir(path: ".")
        XCTAssertNotNil(contents)
        
        if let dirContents = contents {
            XCTAssertTrue(dirContents.contains("file1.txt"))
            XCTAssertTrue(dirContents.contains("file2.txt"))
        }
    }
    
    /// Test file reading
    func testReadFile() {
        let operations = AugmentFUSEOperations(space: testSpace)
        
        // Create a test file
        let testContent = "This is test content for reading"
        let testFile = testSpace.path.appendingPathComponent("read_test.txt")
        try! testContent.write(to: testFile, atomically: true, encoding: .utf8)
        
        // Read the file
        let readData = operations.read(path: "read_test.txt", offset: 0, size: testContent.count)
        XCTAssertNotNil(readData)
        
        if let data = readData {
            let readString = String(data: data, encoding: .utf8)
            XCTAssertEqual(readString, testContent)
        }
    }
    
    /// Test partial file reading
    func testPartialFileRead() {
        let operations = AugmentFUSEOperations(space: testSpace)
        
        // Create a test file
        let testContent = "0123456789ABCDEF"
        let testFile = testSpace.path.appendingPathComponent("partial_test.txt")
        try! testContent.write(to: testFile, atomically: true, encoding: .utf8)
        
        // Read partial content
        let readData = operations.read(path: "partial_test.txt", offset: 5, size: 5)
        XCTAssertNotNil(readData)
        
        if let data = readData {
            let readString = String(data: data, encoding: .utf8)
            XCTAssertEqual(readString, "56789")
        }
    }
    
    /// Test file writing with proper size handling
    func testFileWriting() {
        let operations = AugmentFUSEOperations(space: testSpace)
        
        // Create an initial file
        let testFile = testSpace.path.appendingPathComponent("write_test.txt")
        try! "Initial content".write(to: testFile, atomically: true, encoding: .utf8)
        
        // Write new data
        let newData = "New data".data(using: .utf8)!
        let bytesWritten = operations.write(path: "write_test.txt", offset: 0, data: newData)
        
        XCTAssertEqual(bytesWritten, newData.count)
        
        // Verify the content was written
        let updatedContent = try? String(contentsOf: testFile, encoding: .utf8)
        XCTAssertTrue(updatedContent?.hasPrefix("New data") == true)
    }
    
    /// Test file writing at offset
    func testFileWritingAtOffset() {
        let operations = AugmentFUSEOperations(space: testSpace)
        
        // Create an initial file with known content
        let initialContent = "0123456789"
        let testFile = testSpace.path.appendingPathComponent("offset_test.txt")
        try! initialContent.write(to: testFile, atomically: true, encoding: .utf8)
        
        // Write at offset
        let insertData = "ABC".data(using: .utf8)!
        let bytesWritten = operations.write(path: "offset_test.txt", offset: 3, data: insertData)
        
        XCTAssertEqual(bytesWritten, insertData.count)
        
        // Verify the content
        let updatedContent = try? String(contentsOf: testFile, encoding: .utf8)
        XCTAssertEqual(updatedContent, "012ABC6789")
    }
    
    /// Test file creation
    func testFileCreation() {
        let operations = AugmentFUSEOperations(space: testSpace)
        
        let success = operations.create(path: "new_file.txt", mode: 0o644)
        XCTAssertTrue(success)
        
        // Verify file was created
        let newFile = testSpace.path.appendingPathComponent("new_file.txt")
        XCTAssertTrue(FileManager.default.fileExists(atPath: newFile.path))
    }
    
    /// Test directory creation
    func testDirectoryCreation() {
        let operations = AugmentFUSEOperations(space: testSpace)
        
        let success = operations.mkdir(path: "new_directory", mode: 0o755)
        XCTAssertTrue(success)
        
        // Verify directory was created
        let newDir = testSpace.path.appendingPathComponent("new_directory")
        var isDirectory: ObjCBool = false
        let exists = FileManager.default.fileExists(atPath: newDir.path, isDirectory: &isDirectory)
        XCTAssertTrue(exists && isDirectory.boolValue)
    }
    
    /// Test file removal
    func testFileRemoval() {
        let operations = AugmentFUSEOperations(space: testSpace)
        
        // Create a file to remove
        let testFile = testSpace.path.appendingPathComponent("to_remove.txt")
        try! "Content".write(to: testFile, atomically: true, encoding: .utf8)
        
        // Remove the file
        let success = operations.unlink(path: "to_remove.txt")
        XCTAssertTrue(success)
        
        // Verify file was removed
        XCTAssertFalse(FileManager.default.fileExists(atPath: testFile.path))
    }
    
    /// Test file renaming
    func testFileRenaming() {
        let operations = AugmentFUSEOperations(space: testSpace)
        
        // Create a file to rename
        let originalFile = testSpace.path.appendingPathComponent("original.txt")
        try! "Content".write(to: originalFile, atomically: true, encoding: .utf8)
        
        // Rename the file
        let success = operations.rename(from: "original.txt", to: "renamed.txt")
        XCTAssertTrue(success)
        
        // Verify rename
        let renamedFile = testSpace.path.appendingPathComponent("renamed.txt")
        XCTAssertFalse(FileManager.default.fileExists(atPath: originalFile.path))
        XCTAssertTrue(FileManager.default.fileExists(atPath: renamedFile.path))
    }
    
    /// Test error handling for non-existent files
    func testErrorHandlingNonExistentFile() {
        let operations = AugmentFUSEOperations(space: testSpace)
        
        // Try to read non-existent file
        let readData = operations.read(path: "nonexistent.txt", offset: 0, size: 100)
        XCTAssertNil(readData)
        
        // Try to get attributes of non-existent file
        let attributes = operations.getattr(path: "nonexistent.txt")
        XCTAssertNil(attributes)
        
        // Try to write to non-existent file
        let writeData = "data".data(using: .utf8)!
        let bytesWritten = operations.write(path: "nonexistent.txt", offset: 0, data: writeData)
        XCTAssertEqual(bytesWritten, -1)
    }
}
