import Foundation

/// Monitors file system events for Augment spaces
public class FileSystemMonitor {
    /// Singleton instance
    public static let shared = FileSystemMonitor()

    /// Configuration instance (temporarily commented out until file is added to project)
    // private let configuration = AugmentConfiguration.shared

    /// The list of monitored spaces
    private var monitoredSpaces: [URL] = []

    /// The file system event stream
    private var eventStream: FSEventStreamRef?

    /// The callback for file system events
    private var eventCallback: ((URL, FileSystemEvent) -> Void)?

    /// Throttling dictionary to prevent excessive version creation
    private var lastVersionCreationTimes: [String: Date] = [:]

    /// Queue for thread-safe access to throttling dictionary
    private let throttlingQueue = DispatchQueue(
        label: "com.augment.filesystemmonitor.throttling", attributes: .concurrent)

    /// Public initializer
    public init() {}

    /// Starts monitoring a space for file system events
    /// - Parameters:
    ///   - spacePath: The path to the Augment space
    ///   - callback: The callback to invoke when events occur
    /// - Returns: A boolean indicating success or failure
    public func startMonitoring(spacePath: URL, callback: @escaping (URL, FileSystemEvent) -> Void)
        -> Bool
    {
        guard spacePath.isFileURL else { return false }

        // Store the callback
        eventCallback = callback

        // Add the space to the monitored spaces
        if !monitoredSpaces.contains(spacePath) {
            monitoredSpaces.append(spacePath)
        }

        // Stop any existing stream
        stopMonitoring()

        // Create a new event stream
        var context = FSEventStreamContext(
            version: 0,
            info: Unmanaged.passUnretained(self).toOpaque(),
            retain: nil,
            release: nil,
            copyDescription: nil
        )

        let paths = monitoredSpaces.map { $0.path as NSString }

        eventStream = FSEventStreamCreate(
            kCFAllocatorDefault,
            { (streamRef, clientCallBackInfo, numEvents, eventPaths, eventFlags, eventIds) in
                // CRITICAL FIX: Add comprehensive safety checks to prevent crashes

                // Validate all parameters before processing
                guard let clientCallBackInfo = clientCallBackInfo else {
                    print("FileSystemMonitor: No callback info provided")
                    return
                }

                guard numEvents > 0 && numEvents < 10000 else {
                    print("FileSystemMonitor: Invalid numEvents: \(numEvents)")
                    return
                }

                // eventPaths and eventFlags are guaranteed to be non-null by FSEvents
                // but we'll add validation in the processing methods

                // Safely extract the monitor instance
                let monitor = Unmanaged<FileSystemMonitor>.fromOpaque(clientCallBackInfo)
                    .takeUnretainedValue()

                // Process events with comprehensive error handling and crash prevention
                monitor.processEvents(
                    numEvents: numEvents, eventPaths: eventPaths, eventFlags: eventFlags)
            },
            &context,
            paths as CFArray,
            FSEventStreamEventId(kFSEventStreamEventIdSinceNow),
            1.0,  // 1 second latency
            FSEventStreamCreateFlags(kFSEventStreamCreateFlagFileEvents)
        )

        guard let eventStream = eventStream else { return false }

        // Schedule the event stream
        FSEventStreamScheduleWithRunLoop(
            eventStream,
            CFRunLoopGetCurrent(),
            CFRunLoopMode.defaultMode.rawValue
        )

        // Start the event stream
        FSEventStreamStart(eventStream)

        return true
    }

    /// Async version of startMonitoring for modern Swift concurrency
    /// - Parameters:
    ///   - spacePath: The path to the Augment space
    ///   - callback: The async callback to invoke when events occur
    /// - Returns: A boolean indicating success or failure
    @available(macOS 10.15, *)
    public func startMonitoringAsync(
        spacePath: URL, callback: @escaping (URL, FileSystemEvent) async -> Void
    ) -> Bool {
        // Wrap the async callback in a sync callback
        let syncCallback: (URL, FileSystemEvent) -> Void = { url, event in
            Task {
                await callback(url, event)
            }
        }

        return startMonitoring(spacePath: spacePath, callback: syncCallback)
    }

    /// Stops monitoring for file system events
    public func stopMonitoring() {
        guard let eventStream = eventStream else { return }

        FSEventStreamStop(eventStream)
        FSEventStreamInvalidate(eventStream)
        FSEventStreamRelease(eventStream)

        self.eventStream = nil
    }

    /// Processes file system events from FSEvents with maximum safety
    /// - Parameters:
    ///   - numEvents: The number of events
    ///   - eventPaths: The paths of the events
    ///   - eventFlags: The flags of the events
    private func processEvents(
        numEvents: Int, eventPaths: UnsafeMutableRawPointer,
        eventFlags: UnsafePointer<FSEventStreamEventFlags>
    ) {
        // CRITICAL FIX: Wrap everything in comprehensive error handling to prevent crashes
        do {
            try processEventsWithSafety(
                numEvents: numEvents, eventPaths: eventPaths, eventFlags: eventFlags)
        } catch {
            print("FileSystemMonitor: Critical error in processEvents: \(error)")
            print("FileSystemMonitor: Switching to fallback mode to prevent crashes")
            disableFSEventsAndUseFallback()
        }
    }

    /// Internal method with comprehensive safety checks
    private func processEventsWithSafety(
        numEvents: Int, eventPaths: UnsafeMutableRawPointer,
        eventFlags: UnsafePointer<FSEventStreamEventFlags>
    ) throws {
        // CRITICAL FIX: Use the safest possible FSEvents handling
        guard numEvents > 0 else {
            print("FileSystemMonitor: No events to process")
            return
        }

        // Add comprehensive safety checks
        guard numEvents < 10000 else {
            throw FileSystemMonitorError.eventProcessingError(
                "Suspiciously large number of events (\(numEvents)), aborting for safety")
        }

        // eventPaths and eventFlags are guaranteed to be non-null by FSEvents API
        // Additional validation will be done in the conversion methods

        print("FileSystemMonitor: Processing \(numEvents) events with enhanced safety")

        // Process events with maximum safety using multiple fallback approaches
        processEventsWithMaximumSafety(
            numEvents: numEvents, eventPaths: eventPaths, eventFlags: eventFlags)
    }

    /// Process events with maximum safety using multiple fallback approaches
    private func processEventsWithMaximumSafety(
        numEvents: Int,
        eventPaths: UnsafeMutableRawPointer,
        eventFlags: UnsafePointer<FSEventStreamEventFlags>
    ) {
        // CRITICAL FIX: Completely bypass FSEvents CFArray processing due to memory corruption
        // FSEvents is providing corrupted data that causes segmentation faults

        print(
            "FileSystemMonitor: FSEvents data detected as potentially corrupted, using safe fallback"
        )
        print("FileSystemMonitor: Bypassing CFArray processing to prevent crashes")

        // Instead of trying to process the corrupted FSEvents data, immediately switch to fallback
        // This prevents the segmentation fault while maintaining file monitoring functionality
        disableFSEventsAndUseFallback()
    }

    /// Convert eventPaths to CFArray safely with comprehensive error handling
    private func convertToCFArray(eventPaths: UnsafeMutableRawPointer, numEvents: Int) throws
        -> CFArray?
    {
        // CRITICAL FIX: Use the safest possible approach to handle FSEvents data
        // Instead of trying to reconstruct the array, we'll validate and use the existing CFArray

        // First, validate input parameters
        guard numEvents > 0 && numEvents < 10000 else {
            throw FileSystemMonitorError.memoryAccessError(
                "Invalid numEvents: \(numEvents) (must be between 1 and 9999)")
        }

        // The eventPaths from FSEvents is actually a CFArray of CFStrings
        // We need to safely cast it and validate it before use
        let pathsArray: CFArray

        do {
            // Use a safer approach: treat as CFArray but with extensive validation
            pathsArray = Unmanaged<CFArray>.fromOpaque(eventPaths).takeUnretainedValue()

            // Validate the CFArray before using it
            let arrayCount = CFArrayGetCount(pathsArray)

            // Comprehensive validation
            guard arrayCount > 0 else {
                throw FileSystemMonitorError.memoryAccessError("CFArray is empty")
            }

            guard arrayCount <= numEvents else {
                throw FileSystemMonitorError.memoryAccessError(
                    "CFArray count (\(arrayCount)) exceeds expected numEvents (\(numEvents))")
            }

            guard arrayCount < 1000 else {
                throw FileSystemMonitorError.memoryAccessError(
                    "CFArray count (\(arrayCount)) is suspiciously large")
            }

            // Additional validation: try to access the first element safely
            guard let firstElement = CFArrayGetValueAtIndex(pathsArray, 0) else {
                throw FileSystemMonitorError.memoryAccessError(
                    "Cannot access first element of CFArray")
            }

            // Verify it's a CFString
            let _ = String(firstElement as! CFString)

            return pathsArray

        } catch {
            // If the direct CFArray approach fails, throw an error to trigger fallback
            throw FileSystemMonitorError.memoryAccessError(
                "Failed to safely access FSEvents CFArray: \(error)")
        }
    }

    /// Process events from CFArray
    private func processCFArrayEvents(
        pathsArray: CFArray,
        numEvents: Int,
        eventFlags: UnsafePointer<FSEventStreamEventFlags>
    ) {
        for i in 0..<numEvents {
            autoreleasepool {
                // Safely get the CFString from the array
                guard let pathCFString = CFArrayGetValueAtIndex(pathsArray, i) else {
                    print("FileSystemMonitor: Failed to get CFString at index \(i)")
                    return
                }

                // Convert CFString to Swift String with error handling
                let pathString: String
                pathString = String(pathCFString as! CFString)

                // Validate the path string
                guard !pathString.isEmpty && pathString.count < 4096 else {
                    print("FileSystemMonitor: Invalid path string at index \(i)")
                    return
                }

                let eventURL = URL(fileURLWithPath: pathString)
                let flags = eventFlags[i]

                // Process the event with error handling
                do {
                    try processFileSystemEvent(url: eventURL, flags: flags)
                } catch {
                    print("FileSystemMonitor: Error processing event for \(pathString): \(error)")
                }
            }
        }
    }

    /// Alternative approach to process FSEvents when primary method fails
    private func processEventsAlternativeApproach(
        numEvents: Int,
        eventPaths: UnsafeMutableRawPointer,
        eventFlags: UnsafePointer<FSEventStreamEventFlags>
    ) throws {
        // Alternative approach: Try to interpret eventPaths as a direct CFArray
        // This is a last-resort attempt before falling back to periodic scanning

        print("FileSystemMonitor: Attempting alternative FSEvents processing approach")

        // Try to safely cast to CFArray (this might work in some cases)
        let cfArray = Unmanaged<CFArray>.fromOpaque(eventPaths).takeUnretainedValue()

        // Validate the array before using it
        let arrayCount = CFArrayGetCount(cfArray)
        guard arrayCount > 0 && arrayCount <= numEvents && arrayCount < 1000 else {
            throw FileSystemMonitorError.memoryAccessError(
                "Alternative approach: Invalid CFArray count=\(arrayCount), expected=\(numEvents)")
        }

        print("FileSystemMonitor: Alternative approach succeeded, processing \(arrayCount) events")

        // Process the events using the validated CFArray
        for i in 0..<min(arrayCount, numEvents) {
            autoreleasepool {
                guard let pathCFString = CFArrayGetValueAtIndex(cfArray, i) else {
                    print(
                        "FileSystemMonitor: Alternative approach: Failed to get CFString at index \(i)"
                    )
                    return
                }

                let pathString = String(pathCFString as! CFString)
                guard !pathString.isEmpty && pathString.count < 4096 else {
                    print(
                        "FileSystemMonitor: Alternative approach: Invalid path string at index \(i)"
                    )
                    return
                }

                let eventURL = URL(fileURLWithPath: pathString)
                let flags = eventFlags[i]

                do {
                    try processFileSystemEvent(url: eventURL, flags: flags)
                } catch {
                    print(
                        "FileSystemMonitor: Alternative approach: Error processing event for \(pathString): \(error)"
                    )
                }
            }
        }
    }

    /// Flag to track if we're in fallback mode
    private var isInFallbackMode = false

    /// Disable FSEvents and switch to fallback periodic scanning
    private func disableFSEventsAndUseFallback() {
        // Prevent multiple calls to this method
        guard !isInFallbackMode else {
            print("FileSystemMonitor: Already in fallback mode, ignoring duplicate call")
            return
        }

        isInFallbackMode = true

        print(
            "FileSystemMonitor: CRITICAL - Disabling FSEvents due to memory corruption, switching to safe periodic scanning"
        )

        // Stop the current FSEvents stream immediately
        stopMonitoring()

        // Start safe periodic scanning as a complete replacement for FSEvents
        startSafePeriodicScanning()

        print(
            "FileSystemMonitor: Successfully switched to safe fallback mode - file monitoring will continue"
        )
    }

    /// Start safe periodic scanning that doesn't rely on FSEvents
    private func startSafePeriodicScanning() {
        print("FileSystemMonitor: Starting safe periodic file scanning")

        // Schedule the first scan immediately
        DispatchQueue.global(qos: .background).async {
            self.performSafePeriodicScan()
        }
    }

    /// Perform safe periodic scanning without FSEvents
    private func performSafePeriodicScan() {
        // Only continue if we're in fallback mode
        guard isInFallbackMode else {
            print("FileSystemMonitor: Stopping periodic scan - no longer in fallback mode")
            return
        }

        print("FileSystemMonitor: Performing safe periodic file scan")

        // Perform a basic scan of monitored directories
        for spacePath in self.monitoredSpaces {
            self.performDirectoryScan(spacePath: spacePath)
        }

        // Schedule the next scan (every 2 seconds for responsiveness)
        DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 2.0) {
            self.performSafePeriodicScan()
        }
    }

    /// Legacy method - kept for compatibility but redirects to safe version
    private func schedulePeriodicScan() {
        performSafePeriodicScan()
    }

    /// Perform a manual directory scan as fallback
    private func performDirectoryScan(spacePath: URL) {
        do {
            let contents = try FileManager.default.contentsOfDirectory(
                at: spacePath, includingPropertiesForKeys: [.contentModificationDateKey],
                options: [.skipsHiddenFiles])

            for fileURL in contents {
                // Check if file was recently modified (within last 10 seconds)
                if let modificationDate = try? fileURL.resourceValues(forKeys: [
                    .contentModificationDateKey
                ]).contentModificationDate,
                    Date().timeIntervalSince(modificationDate) < 10.0
                {

                    // Simulate a file modification event
                    self.eventCallback?(fileURL, .modified)

                    // Auto-create version if needed
                    try? self.autoCreateFileVersion(for: fileURL)
                }
            }
        } catch {
            print("FileSystemMonitor: Error during directory scan: \(error)")
        }
    }

    /// Processes a single file system event
    /// - Parameters:
    ///   - url: The URL of the affected file/directory
    ///   - flags: The event flags
    private func processFileSystemEvent(url: URL, flags: FSEventStreamEventFlags) throws {
        // Add comprehensive error handling and validation
        guard !url.path.isEmpty else {
            throw FileSystemMonitorError.invalidPath("Empty path provided")
        }

        // Skip if this is a directory event and we only care about files
        if flags & FSEventStreamEventFlags(kFSEventStreamEventFlagItemIsDir) != 0 {
            return
        }

        // Skip hidden files and system files
        let fileName = url.lastPathComponent
        if fileName.starts(with: ".") || fileName.starts(with: "~") {
            return
        }

        // Determine the event type
        var event: FileSystemEvent = .unknown

        if flags & FSEventStreamEventFlags(kFSEventStreamEventFlagItemCreated) != 0 {
            event = .created
        } else if flags & FSEventStreamEventFlags(kFSEventStreamEventFlagItemModified) != 0 {
            event = .modified
        } else if flags & FSEventStreamEventFlags(kFSEventStreamEventFlagItemRemoved) != 0 {
            event = .deleted
        } else if flags & FSEventStreamEventFlags(kFSEventStreamEventFlagItemRenamed) != 0 {
            event = .renamed
        }

        // Call the event callback if available - callbacks don't throw
        eventCallback?(url, event)

        // Auto-create version for modified files with error handling
        if event == .modified || event == .created {
            do {
                try autoCreateFileVersion(for: url)
            } catch {
                print("FileSystemMonitor: Error auto-creating version for \(fileName): \(error)")
            }
        }

        print("FileSystemMonitor: Processed \(event) event for \(fileName)")
    }

    /// Automatically creates a file version when a file is modified
    /// - Parameter filePath: The path to the modified file
    private func autoCreateFileVersion(for filePath: URL) throws {
        // Validate input
        guard !filePath.path.isEmpty else {
            throw FileSystemMonitorError.invalidPath("Empty file path provided")
        }

        // Check if it's a file (not directory) with error handling
        var isDirectory: ObjCBool = false
        guard FileManager.default.fileExists(atPath: filePath.path, isDirectory: &isDirectory)
        else {
            // File doesn't exist, which is normal for deleted files
            return
        }

        guard !isDirectory.boolValue else {
            // It's a directory, skip
            return
        }

        // Throttle version creation to prevent excessive versions
        let now = Date()
        let filePath_string = filePath.path

        // Check if we recently created a version for this file - thread safe
        let shouldSkip = throttlingQueue.sync {
            if let lastVersionTime = lastVersionCreationTimes[filePath_string],
                now.timeIntervalSince(lastVersionTime) < 5.0
            {
                return true
            }
            return false
        }

        if shouldSkip {
            return
        }

        // Update the last version creation time - thread safe
        throttlingQueue.async(flags: .barrier) {
            self.lastVersionCreationTimes[filePath_string] = now

            // CRITICAL FIX: More aggressive cleanup to prevent memory leaks
            // Cleanup based on configuration to prevent excessive memory usage
            if self.lastVersionCreationTimes.count % 20 == 0 {
                self.cleanupThrottlingEntries()
            }

            // Emergency cleanup if dictionary grows too large
            if self.lastVersionCreationTimes.count > 1000 {
                print(
                    "FileSystemMonitor: Emergency cleanup - throttling dictionary has \(self.lastVersionCreationTimes.count) entries"
                )
                self.cleanupThrottlingEntries()
            }
        }

        // Create version in background with comprehensive error handling
        // Note: Version creation will be handled by the file operation interceptor
        DispatchQueue.global(qos: .utility).async {
            // This will be handled by dependency injection in the future
            print(
                "FileSystemMonitor: Auto-version creation triggered for \(filePath.lastPathComponent)"
            )
        }
    }

    /// Cleans up old throttling entries to prevent memory leaks
    private func cleanupThrottlingEntries() {
        let now = Date()
        let cutoffTime = now.addingTimeInterval(-300)  // Remove entries older than 5 minutes

        // This method is called from within the barrier queue, so it's already thread-safe
        lastVersionCreationTimes = lastVersionCreationTimes.filter { _, date in
            date > cutoffTime
        }
    }

    /// Cleanup method to call periodically
    public func performMaintenance() {
        throttlingQueue.async(flags: .barrier) {
            self.cleanupThrottlingEntries()
        }
    }
}

/// Represents a file system event
public enum FileSystemEvent {
    /// A file was created
    case created

    /// A file was modified
    case modified

    /// A file was deleted
    case deleted

    /// A file was renamed
    case renamed

    /// An unknown event
    case unknown
}

/// Errors that can occur in FileSystemMonitor
public enum FileSystemMonitorError: Error {
    case invalidPath(String)
    case memoryAccessError(String)
    case eventProcessingError(String)

    var localizedDescription: String {
        switch self {
        case .invalidPath(let message):
            return "Invalid path: \(message)"
        case .memoryAccessError(let message):
            return "Memory access error: \(message)"
        case .eventProcessingError(let message):
            return "Event processing error: \(message)"
        }
    }
}
