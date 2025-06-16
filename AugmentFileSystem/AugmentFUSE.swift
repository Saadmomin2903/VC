import Foundation

/// Errors that can occur in FUSE operations
public enum FUSEError: Error {
    case executableNotFound(String)
    case invalidExecutable(String)
    case mountFailed(String)
    case unmountFailed(String)
    case securityViolation(String)

    var localizedDescription: String {
        switch self {
        case .executableNotFound(let message):
            return "Executable not found: \(message)"
        case .invalidExecutable(let message):
            return "Invalid executable: \(message)"
        case .mountFailed(let message):
            return "Mount failed: \(message)"
        case .unmountFailed(let message):
            return "Unmount failed: \(message)"
        case .securityViolation(let message):
            return "Security violation: \(message)"
        }
    }
}

/// The main class for the Augment FUSE implementation
public class AugmentFUSE {
    /// Singleton instance
    public static let shared = AugmentFUSE()

    /// The list of mounted spaces
    private var mountedSpaces: [AugmentSpace] = []

    /// Private initializer for singleton pattern
    private init() {}

    /// CRITICAL FIX #4: Secure executable validation to prevent command injection
    /// Validates that an executable exists and is safe to run
    /// - Parameter executablePath: The path to the executable
    /// - Returns: True if the executable is valid and safe
    private func validateExecutable(at executablePath: String) throws -> Bool {
        let executableURL = URL(fileURLWithPath: executablePath)

        // Check if the executable exists
        guard FileManager.default.fileExists(atPath: executablePath) else {
            throw FUSEError.executableNotFound("Executable not found at path: \(executablePath)")
        }

        // Check if it's actually executable
        guard FileManager.default.isExecutableFile(atPath: executablePath) else {
            throw FUSEError.invalidExecutable("File is not executable: \(executablePath)")
        }

        // Security check: Only allow executables in trusted system directories
        let trustedPaths = [
            "/usr/bin/",
            "/usr/sbin/",
            "/usr/local/bin/",
            "/System/Library/",
            "/Applications/",
        ]

        let normalizedPath = executableURL.standardized.path
        let isTrusted = trustedPaths.contains { trustedPath in
            normalizedPath.hasPrefix(trustedPath)
        }

        guard isTrusted else {
            throw FUSEError.securityViolation("Executable not in trusted path: \(executablePath)")
        }

        // Additional security: Check for path traversal attempts
        if executablePath.contains("..") || executablePath.contains("//") {
            throw FUSEError.securityViolation(
                "Path traversal detected in executable path: \(executablePath)")
        }

        return true
    }

    /// Safely creates and configures a process with validated executable
    /// - Parameters:
    ///   - executablePath: The path to the executable
    ///   - arguments: The arguments to pass to the executable
    /// - Returns: A configured Process instance
    /// - Throws: FUSEError if validation fails
    private func createSecureProcess(executablePath: String, arguments: [String]) throws -> Process
    {
        // Validate the executable first
        try validateExecutable(at: executablePath)

        // Validate arguments to prevent injection
        for argument in arguments {
            if argument.contains(";") || argument.contains("&") || argument.contains("|")
                || argument.contains("`") || argument.contains("$")
            {
                throw FUSEError.securityViolation(
                    "Potentially dangerous character in argument: \(argument)")
            }
        }

        let process = Process()
        process.executableURL = URL(fileURLWithPath: executablePath)
        process.arguments = arguments

        // Security: Set environment to minimal safe set
        process.environment = [
            "PATH": "/usr/bin:/usr/sbin:/usr/local/bin",
            "HOME": NSHomeDirectory(),
            "USER": NSUserName(),
        ]

        return process
    }

    /// Mounts an Augment space
    /// - Parameter space: The space to mount
    /// - Returns: A boolean indicating success or failure
    public func mountSpace(_ space: AugmentSpace) -> Bool {
        // Check if the space is already mounted
        if mountedSpaces.contains(where: { $0.id == space.id }) {
            return true
        }

        // Create the mount point if it doesn't exist
        let mountPoint = space.path
        do {
            try FileManager.default.createDirectory(
                at: mountPoint, withIntermediateDirectories: true)
        } catch {
            print("Error creating mount point: \(error)")
            return false
        }

        // Mount the space using macFUSE
        let result = mountFUSE(space: space, mountPoint: mountPoint)
        if result {
            mountedSpaces.append(space)
        }

        return result
    }

    /// Unmounts an Augment space
    /// - Parameter space: The space to unmount
    /// - Returns: A boolean indicating success or failure
    public func unmountSpace(_ space: AugmentSpace) -> Bool {
        // Check if the space is mounted
        guard mountedSpaces.contains(where: { $0.id == space.id }) else {
            return true
        }

        // Unmount the space using macFUSE
        let result = unmountFUSE(mountPoint: space.path)
        if result {
            mountedSpaces.removeAll { $0.id == space.id }
        }

        return result
    }

    /// Mounts a space using macFUSE with secure process execution
    /// - Parameters:
    ///   - space: The space to mount
    ///   - mountPoint: The mount point
    /// - Returns: A boolean indicating success or failure
    private func mountFUSE(space: AugmentSpace, mountPoint: URL) -> Bool {
        // CRITICAL FIX #4: Use secure process creation with validation

        do {
            // Try multiple possible mount executables in order of preference
            let possibleExecutables = [
                "/usr/local/bin/mount_augment",  // Custom Augment mount helper
                "/usr/sbin/mount",  // System mount command
                "/usr/local/bin/mount_macfuse",  // macFUSE mount helper
            ]

            var mountProcess: Process?
            var executablePath: String?

            // Find the first available and valid executable
            for executable in possibleExecutables {
                do {
                    if try validateExecutable(at: executable) {
                        executablePath = executable
                        break
                    }
                } catch {
                    print("AugmentFUSE: Executable validation failed for \(executable): \(error)")
                    continue
                }
            }

            guard let validExecutable = executablePath else {
                print("AugmentFUSE: No valid mount executable found")
                return false
            }

            // Prepare secure arguments
            let arguments: [String]
            if validExecutable.contains("mount_augment") {
                arguments = [
                    "--source", space.path.path,
                    "--target", mountPoint.path,
                    "--space-id", space.id.uuidString,
                ]
            } else if validExecutable.contains("mount_macfuse") {
                arguments = [
                    "-t", "macfuse",
                    space.path.path,
                    mountPoint.path,
                ]
            } else {
                // Generic mount command
                arguments = [
                    "-t", "fuse",
                    space.path.path,
                    mountPoint.path,
                ]
            }

            // Create secure process
            mountProcess = try createSecureProcess(
                executablePath: validExecutable,
                arguments: arguments
            )

            guard let process = mountProcess else {
                print("AugmentFUSE: Failed to create mount process")
                return false
            }

            // Execute with timeout
            try process.run()

            // Wait for completion with timeout
            let timeoutSeconds = 30.0
            let startTime = Date()

            while process.isRunning && Date().timeIntervalSince(startTime) < timeoutSeconds {
                Thread.sleep(forTimeInterval: 0.1)
            }

            if process.isRunning {
                print("AugmentFUSE: Mount process timed out, terminating")
                process.terminate()
                return false
            }

            let success = process.terminationStatus == 0
            if success {
                print("AugmentFUSE: Successfully mounted space \(space.name) at \(mountPoint.path)")
            } else {
                print("AugmentFUSE: Mount failed with status \(process.terminationStatus)")
            }

            return success

        } catch let error as FUSEError {
            print("AugmentFUSE: Security error during mount: \(error.localizedDescription)")
            return false
        } catch {
            print("AugmentFUSE: Unexpected error during mount: \(error)")
            return false
        }
    }

    /// Unmounts a space using macFUSE with secure process execution
    /// - Parameter mountPoint: The mount point
    /// - Returns: A boolean indicating success or failure
    private func unmountFUSE(mountPoint: URL) -> Bool {
        // CRITICAL FIX #4: Use secure process creation with validation

        do {
            // Try multiple possible unmount executables in order of preference
            let possibleExecutables = [
                "/usr/sbin/diskutil",  // macOS diskutil (preferred)
                "/usr/sbin/umount",  // Standard Unix unmount
                "/usr/bin/umount",  // Alternative location
            ]

            var unmountProcess: Process?
            var executablePath: String?

            // Find the first available and valid executable
            for executable in possibleExecutables {
                do {
                    if try validateExecutable(at: executable) {
                        executablePath = executable
                        break
                    }
                } catch {
                    print("AugmentFUSE: Executable validation failed for \(executable): \(error)")
                    continue
                }
            }

            guard let validExecutable = executablePath else {
                print("AugmentFUSE: No valid unmount executable found")
                return false
            }

            // Prepare secure arguments based on executable
            let arguments: [String]
            if validExecutable.contains("diskutil") {
                arguments = ["unmount", mountPoint.path]
            } else {
                // Standard umount command
                arguments = [mountPoint.path]
            }

            // Create secure process
            unmountProcess = try createSecureProcess(
                executablePath: validExecutable,
                arguments: arguments
            )

            guard let process = unmountProcess else {
                print("AugmentFUSE: Failed to create unmount process")
                return false
            }

            // Execute with timeout
            try process.run()

            // Wait for completion with timeout
            let timeoutSeconds = 15.0
            let startTime = Date()

            while process.isRunning && Date().timeIntervalSince(startTime) < timeoutSeconds {
                Thread.sleep(forTimeInterval: 0.1)
            }

            if process.isRunning {
                print("AugmentFUSE: Unmount process timed out, terminating")
                process.terminate()
                return false
            }

            let success = process.terminationStatus == 0
            if success {
                print("AugmentFUSE: Successfully unmounted \(mountPoint.path)")
            } else {
                print("AugmentFUSE: Unmount failed with status \(process.terminationStatus)")
            }

            return success

        } catch let error as FUSEError {
            print("AugmentFUSE: Security error during unmount: \(error.localizedDescription)")
            return false
        } catch {
            print("AugmentFUSE: Unexpected error during unmount: \(error)")
            return false
        }
    }
}

/// The FUSE operations implementation
public class AugmentFUSEOperations {
    /// The space being mounted
    private let space: AugmentSpace

    /// The version control manager
    private let versionControl = VersionControl.shared

    /// Initializes a new FUSE operations instance
    /// - Parameter space: The space being mounted
    public init(space: AugmentSpace) {
        self.space = space
    }

    /// Gets the attributes of a file
    /// - Parameter path: The path to the file
    /// - Returns: The file attributes
    public func getattr(path: String) -> [FileAttributeKey: Any]? {
        // TODO: Implement getattr
        // This is a placeholder for the actual implementation

        // Get the full path
        let fullPath = URL(fileURLWithPath: path, relativeTo: space.path)

        // Check if the file exists
        guard FileManager.default.fileExists(atPath: fullPath.path) else {
            return nil
        }

        // Get the file attributes
        do {
            return try FileManager.default.attributesOfItem(atPath: fullPath.path)
        } catch {
            print("Error getting attributes: \(error)")
            return nil
        }
    }

    /// Reads the contents of a directory
    /// - Parameter path: The path to the directory
    /// - Returns: The directory contents
    public func readdir(path: String) -> [String]? {
        // TODO: Implement readdir
        // This is a placeholder for the actual implementation

        // Get the full path
        let fullPath = URL(fileURLWithPath: path, relativeTo: space.path)

        // Check if the directory exists
        guard FileManager.default.fileExists(atPath: fullPath.path) else {
            return nil
        }

        // Get the directory contents
        do {
            return try FileManager.default.contentsOfDirectory(atPath: fullPath.path)
        } catch {
            print("Error reading directory: \(error)")
            return nil
        }
    }

    /// Reads the contents of a file
    /// - Parameters:
    ///   - path: The path to the file
    ///   - offset: The offset to start reading from
    ///   - size: The number of bytes to read
    /// - Returns: The file contents
    public func read(path: String, offset: Int, size: Int) -> Data? {
        // TODO: Implement read
        // This is a placeholder for the actual implementation

        // Get the full path
        let fullPath = URL(fileURLWithPath: path, relativeTo: space.path)

        // Check if the file exists
        guard FileManager.default.fileExists(atPath: fullPath.path) else {
            return nil
        }

        // Read the file
        do {
            let data = try Data(contentsOf: fullPath)
            let endIndex = min(offset + size, data.count)
            return data.subdata(in: offset..<endIndex)
        } catch {
            print("Error reading file: \(error)")
            return nil
        }
    }

    /// Writes to a file
    /// - Parameters:
    ///   - path: The path to the file
    ///   - offset: The offset to start writing at
    ///   - data: The data to write
    /// - Returns: The number of bytes written
    public func write(path: String, offset: Int, data: Data) -> Int {
        // TODO: Implement write
        // This is a placeholder for the actual implementation

        // Get the full path
        let fullPath = URL(fileURLWithPath: path, relativeTo: space.path)

        // Check if the file exists
        guard FileManager.default.fileExists(atPath: fullPath.path) else {
            return -1
        }

        // Read the existing file
        do {
            var fileData = try Data(contentsOf: fullPath)

            // CRITICAL FIX #4 (Additional): Properly extend file data when needed
            let requiredSize = offset + data.count
            if fileData.count < requiredSize {
                // Properly extend the data by appending zeros
                let additionalBytes = requiredSize - fileData.count
                fileData.append(Data(count: additionalBytes))
            }

            // Validate offset and data bounds
            guard offset >= 0 && offset <= fileData.count else {
                print("Error: Invalid offset \(offset) for file size \(fileData.count)")
                return -1
            }

            guard data.count > 0 else {
                print("Error: No data to write")
                return 0
            }

            // Write the data safely
            let endIndex = offset + data.count
            guard endIndex <= fileData.count else {
                print("Error: Write would exceed file bounds")
                return -1
            }

            fileData.replaceSubrange(offset..<endIndex, with: data)

            // Save the file atomically
            let tempFile = fullPath.appendingPathExtension("tmp")
            try fileData.write(to: tempFile)

            // Atomic move to final location
            _ = try FileManager.default.replaceItem(
                at: fullPath, withItemAt: tempFile,
                backupItemName: nil, options: [],
                resultingItemURL: nil)

            // Create a new version
            _ = versionControl.createFileVersion(filePath: fullPath)

            return data.count
        } catch {
            print("Error writing file: \(error)")
            return -1
        }
    }

    /// Creates a file
    /// - Parameters:
    ///   - path: The path to the file
    ///   - mode: The file mode
    /// - Returns: A boolean indicating success or failure
    public func create(path: String, mode: Int) -> Bool {
        // TODO: Implement create
        // This is a placeholder for the actual implementation

        // Get the full path
        let fullPath = URL(fileURLWithPath: path, relativeTo: space.path)

        // Create the file
        return FileManager.default.createFile(
            atPath: fullPath.path, contents: nil, attributes: [.posixPermissions: mode])
    }

    /// Creates a directory
    /// - Parameters:
    ///   - path: The path to the directory
    ///   - mode: The directory mode
    /// - Returns: A boolean indicating success or failure
    public func mkdir(path: String, mode: Int) -> Bool {
        // TODO: Implement mkdir
        // This is a placeholder for the actual implementation

        // Get the full path
        let fullPath = URL(fileURLWithPath: path, relativeTo: space.path)

        // Create the directory
        do {
            try FileManager.default.createDirectory(
                at: fullPath, withIntermediateDirectories: false,
                attributes: [.posixPermissions: mode])
            return true
        } catch {
            print("Error creating directory: \(error)")
            return false
        }
    }

    /// Removes a file
    /// - Parameter path: The path to the file
    /// - Returns: A boolean indicating success or failure
    public func unlink(path: String) -> Bool {
        // TODO: Implement unlink
        // This is a placeholder for the actual implementation

        // Get the full path
        let fullPath = URL(fileURLWithPath: path, relativeTo: space.path)

        // Remove the file
        do {
            try FileManager.default.removeItem(at: fullPath)
            return true
        } catch {
            print("Error removing file: \(error)")
            return false
        }
    }

    /// Removes a directory
    /// - Parameter path: The path to the directory
    /// - Returns: A boolean indicating success or failure
    public func rmdir(path: String) -> Bool {
        // TODO: Implement rmdir
        // This is a placeholder for the actual implementation

        // Get the full path
        let fullPath = URL(fileURLWithPath: path, relativeTo: space.path)

        // Remove the directory
        do {
            try FileManager.default.removeItem(at: fullPath)
            return true
        } catch {
            print("Error removing directory: \(error)")
            return false
        }
    }

    /// Renames a file or directory
    /// - Parameters:
    ///   - from: The source path
    ///   - to: The destination path
    /// - Returns: A boolean indicating success or failure
    public func rename(from: String, to: String) -> Bool {
        // TODO: Implement rename
        // This is a placeholder for the actual implementation

        // Get the full paths
        let fromPath = URL(fileURLWithPath: from, relativeTo: space.path)
        let toPath = URL(fileURLWithPath: to, relativeTo: space.path)

        // Rename the file or directory
        do {
            try FileManager.default.moveItem(at: fromPath, to: toPath)
            return true
        } catch {
            print("Error renaming: \(error)")
            return false
        }
    }
}
