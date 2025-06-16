import Foundation
import os.log

/// Comprehensive logging system for Augment application
/// Provides structured logging with different levels and categories
public class AugmentLogger {

    // MARK: - Singleton for backward compatibility
    /// Shared instance for backward compatibility during transition
    public static let shared = AugmentLogger()

    // MARK: - Log Levels
    public enum LogLevel: Int, CaseIterable {
        case debug = 0
        case info = 1
        case warning = 2
        case error = 3
        case critical = 4

        var description: String {
            switch self {
            case .debug: return "DEBUG"
            case .info: return "INFO"
            case .warning: return "WARNING"
            case .error: return "ERROR"
            case .critical: return "CRITICAL"
            }
        }

        var osLogType: OSLogType {
            switch self {
            case .debug: return .debug
            case .info: return .info
            case .warning: return .default
            case .error: return .error
            case .critical: return .fault
            }
        }
    }

    // MARK: - Log Categories
    public enum LogCategory: String, CaseIterable {
        case general = "General"
        case fileSystem = "FileSystem"
        case versionControl = "VersionControl"
        case search = "Search"
        case backup = "Backup"
        case performance = "Performance"
        case security = "Security"
        case network = "Network"
        case ui = "UI"
        case database = "Database"
        case storage = "Storage"

        var subsystem: String {
            return "com.augment.app"
        }
    }

    // MARK: - Configuration
    private var minimumLogLevel: LogLevel = .info
    private var enableFileLogging: Bool = true
    private var enableConsoleLogging: Bool = true
    private var logFileURL: URL?

    // MARK: - OS Log instances
    private var osLogs: [LogCategory: OSLog] = [:]

    // MARK: - Thread Safety
    private let logQueue = DispatchQueue(
        label: "com.augment.logger",
        qos: .utility
    )

    // MARK: - File Logging
    private var logFileHandle: FileHandle?

    // MARK: - Initialization

    /// Private initializer
    private init() {
        setupOSLogs()
        setupFileLogging()
    }

    /// Public initializer for dependency injection
    public init(minimumLogLevel: LogLevel = .info, enableFileLogging: Bool = true) {
        self.minimumLogLevel = minimumLogLevel
        self.enableFileLogging = enableFileLogging
        setupOSLogs()
        if enableFileLogging {
            setupFileLogging()
        }
    }

    // MARK: - Setup Methods

    private func setupOSLogs() {
        for category in LogCategory.allCases {
            osLogs[category] = OSLog(subsystem: category.subsystem, category: category.rawValue)
        }
    }

    private func setupFileLogging() {
        guard enableFileLogging else { return }

        do {
            // Create logs directory in Application Support
            let appSupportURL = FileManager.default.urls(
                for: .applicationSupportDirectory,
                in: .userDomainMask
            ).first!
            let augmentLogsURL = appSupportURL.appendingPathComponent("Augment/Logs")

            try FileManager.default.createDirectory(
                at: augmentLogsURL,
                withIntermediateDirectories: true)

            // Create log file with timestamp
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd_HH-mm-ss"
            let timestamp = dateFormatter.string(from: Date())

            logFileURL = augmentLogsURL.appendingPathComponent("augment_\(timestamp).log")

            // Create the log file
            FileManager.default.createFile(atPath: logFileURL!.path, contents: nil)
            logFileHandle = FileHandle(forWritingAtPath: logFileURL!.path)

            // Write initial log entry
            let initialMessage = "=== Augment Logging Started at \(Date()) ===\n"
            writeToFile(initialMessage)

        } catch {
            print("AugmentLogger: Failed to setup file logging: \(error)")
            enableFileLogging = false
        }
    }

    // MARK: - Public Logging Methods

    /// Logs a debug message
    public func debug(
        _ message: String, category: LogCategory = .general,
        file: String = #file, function: String = #function, line: Int = #line
    ) {
        log(
            level: .debug, message: message, category: category, file: file, function: function,
            line: line)
    }

    /// Logs an info message
    public func info(
        _ message: String, category: LogCategory = .general,
        file: String = #file, function: String = #function, line: Int = #line
    ) {
        log(
            level: .info, message: message, category: category, file: file, function: function,
            line: line)
    }

    /// Logs a warning message
    public func warning(
        _ message: String, category: LogCategory = .general,
        file: String = #file, function: String = #function, line: Int = #line
    ) {
        log(
            level: .warning, message: message, category: category, file: file, function: function,
            line: line)
    }

    /// Logs an error message
    public func error(
        _ message: String, category: LogCategory = .general,
        file: String = #file, function: String = #function, line: Int = #line
    ) {
        log(
            level: .error, message: message, category: category, file: file, function: function,
            line: line)
    }

    /// Logs a critical message
    public func critical(
        _ message: String, category: LogCategory = .general,
        file: String = #file, function: String = #function, line: Int = #line
    ) {
        log(
            level: .critical, message: message, category: category, file: file, function: function,
            line: line)
    }

    /// Logs an error with associated Error object
    public func error(
        _ error: Error, message: String? = nil, category: LogCategory = .general,
        file: String = #file, function: String = #function, line: Int = #line
    ) {
        let errorMessage = message ?? "Error occurred"
        let fullMessage = "\(errorMessage): \(error.localizedDescription)"
        log(
            level: .error, message: fullMessage, category: category, file: file, function: function,
            line: line)
    }

    // MARK: - Core Logging Method

    private func log(
        level: LogLevel, message: String, category: LogCategory,
        file: String, function: String, line: Int
    ) {
        // Check if we should log this level
        guard level.rawValue >= minimumLogLevel.rawValue else { return }

        logQueue.async {
            let timestamp = self.formatTimestamp(Date())
            let fileName = URL(fileURLWithPath: file).lastPathComponent
            let location = "\(fileName):\(function):\(line)"

            let formattedMessage =
                "[\(timestamp)] [\(level.description)] [\(category.rawValue)] [\(location)] \(message)"

            // Console logging
            if self.enableConsoleLogging {
                print(formattedMessage)
            }

            // OS Log
            if let osLog = self.osLogs[category] {
                os_log("%{public}@", log: osLog, type: level.osLogType, formattedMessage)
            }

            // File logging
            if self.enableFileLogging {
                self.writeToFile(formattedMessage + "\n")
            }
        }
    }

    // MARK: - Utility Methods

    private func formatTimestamp(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        return formatter.string(from: date)
    }

    private func writeToFile(_ message: String) {
        guard let handle = logFileHandle,
            let data = message.data(using: .utf8)
        else { return }

        handle.write(data)
    }

    // MARK: - Configuration Methods

    /// Sets the minimum log level
    public func setMinimumLogLevel(_ level: LogLevel) {
        logQueue.async(flags: .barrier) {
            self.minimumLogLevel = level
        }
    }

    /// Enables or disables console logging
    public func setConsoleLogging(enabled: Bool) {
        logQueue.async(flags: .barrier) {
            self.enableConsoleLogging = enabled
        }
    }

    /// Gets the current log file URL
    public func getLogFileURL() -> URL? {
        return logFileURL
    }

    // MARK: - Performance Logging

    /// Measures and logs execution time of a block
    public func measureTime<T>(
        _ message: String,
        category: LogCategory = .performance,
        file: String = #file,
        function: String = #function,
        line: Int = #line,
        block: () throws -> T
    ) rethrows -> T {
        let startTime = CFAbsoluteTimeGetCurrent()
        let result = try block()
        let timeElapsed = CFAbsoluteTimeGetCurrent() - startTime

        info(
            "\(message) completed in \(String(format: "%.3f", timeElapsed))s",
            category: category, file: file, function: function, line: line)

        return result
    }

    /// Async version of measureTime
    @available(macOS 10.15, *)
    public func measureTimeAsync<T>(
        _ message: String,
        category: LogCategory = .performance,
        file: String = #file,
        function: String = #function,
        line: Int = #line,
        block: () async throws -> T
    ) async rethrows -> T {
        let startTime = CFAbsoluteTimeGetCurrent()
        let result = try await block()
        let timeElapsed = CFAbsoluteTimeGetCurrent() - startTime

        info(
            "\(message) completed in \(String(format: "%.3f", timeElapsed))s",
            category: category, file: file, function: function, line: line)

        return result
    }

    // MARK: - Cleanup

    deinit {
        logFileHandle?.closeFile()
    }

    /// Manually close the log file
    public func closeLogFile() {
        logQueue.async(flags: .barrier) {
            self.logFileHandle?.closeFile()
            self.logFileHandle = nil
        }
    }
}

// MARK: - Convenience Extensions

/// Protocol for classes that want to use logging
public protocol Loggable {
    var logger: AugmentLogger { get }
}

/// Default implementation for logging
extension Loggable {
    public var logger: AugmentLogger {
        return AugmentLogger.shared
    }
}
