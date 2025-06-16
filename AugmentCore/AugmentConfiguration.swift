import Foundation

/// Centralized configuration management for Augment application
/// Provides type-safe, validated configuration with hot-reloading support
public class AugmentConfiguration: ObservableObject {

    // MARK: - Singleton for backward compatibility
    public static let shared = AugmentConfiguration()

    // MARK: - Configuration Categories

    /// File system monitoring configuration
    @Published public var fileSystemMonitoring = FileSystemMonitoringConfig()

    /// Performance and optimization settings
    @Published public var performance = PerformanceConfig()

    /// Storage management configuration
    @Published public var storage = StorageConfig()

    /// Search and indexing configuration
    @Published public var search = SearchConfig()

    /// User interface configuration
    @Published public var userInterface = UserInterfaceConfig()

    /// Network and synchronization configuration
    @Published public var network = NetworkConfig()

    /// Security and privacy configuration
    @Published public var security = SecurityConfig()

    /// Logging and debugging configuration
    @Published public var logging = LoggingConfig()

    // MARK: - Configuration Persistence
    private let userDefaults = UserDefaults.standard
    private let configurationKey = "AugmentConfiguration"

    // MARK: - Initialization

    public init() {
        loadConfiguration()
        setupConfigurationObservers()
    }

    // MARK: - Configuration Management

    /// Loads configuration from persistent storage
    public func loadConfiguration() {
        if let data = userDefaults.data(forKey: configurationKey),
            let config = try? JSONDecoder().decode(ConfigurationData.self, from: data)
        {
            applyConfiguration(config)
        }
    }

    /// Saves current configuration to persistent storage
    public func saveConfiguration() {
        let config = ConfigurationData(
            fileSystemMonitoring: fileSystemMonitoring,
            performance: performance,
            storage: storage,
            search: search,
            userInterface: userInterface,
            network: network,
            security: security,
            logging: logging
        )

        if let data = try? JSONEncoder().encode(config) {
            userDefaults.set(data, forKey: configurationKey)
        }
    }

    /// Resets configuration to default values
    public func resetToDefaults() {
        fileSystemMonitoring = FileSystemMonitoringConfig()
        performance = PerformanceConfig()
        storage = StorageConfig()
        search = SearchConfig()
        userInterface = UserInterfaceConfig()
        network = NetworkConfig()
        security = SecurityConfig()
        logging = LoggingConfig()

        saveConfiguration()
    }

    /// Validates current configuration
    public func validateConfiguration() -> [ConfigurationError] {
        var errors: [ConfigurationError] = []

        // Validate file system monitoring
        if fileSystemMonitoring.throttleInterval < 0.1 {
            errors.append(
                .invalidValue(
                    "fileSystemMonitoring.throttleInterval", "Must be at least 0.1 seconds"))
        }

        // Validate performance settings
        if performance.fileBatchSize < 1 {
            errors.append(.invalidValue("performance.fileBatchSize", "Must be at least 1"))
        }

        // Validate storage settings
        if storage.defaultMaxSizeGB < 0.1 {
            errors.append(.invalidValue("storage.defaultMaxSizeGB", "Must be at least 0.1 GB"))
        }

        // Validate search settings
        if search.maxResults < 1 {
            errors.append(.invalidValue("search.maxResults", "Must be at least 1"))
        }

        return errors
    }

    // MARK: - Hot Reloading Support

    private func setupConfigurationObservers() {
        // Observe changes and auto-save
        NotificationCenter.default.addObserver(
            forName: UserDefaults.didChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.saveConfiguration()
        }
    }

    private func applyConfiguration(_ config: ConfigurationData) {
        fileSystemMonitoring = config.fileSystemMonitoring
        performance = config.performance
        storage = config.storage
        search = config.search
        userInterface = config.userInterface
        network = config.network
        security = config.security
        logging = config.logging
    }
}

// MARK: - Configuration Structures

/// File system monitoring configuration
public struct FileSystemMonitoringConfig: Codable {
    /// Throttle interval for version creation (seconds)
    public var throttleInterval: TimeInterval = 5.0

    /// Maximum number of monitored spaces
    public var maxMonitoredSpaces: Int = 50

    /// FSEvents latency (seconds)
    public var fsEventsLatency: TimeInterval = 1.0

    /// Throttling cleanup frequency (entries)
    public var throttlingCleanupThreshold: Int = 20

    /// Emergency cleanup threshold (entries)
    public var emergencyCleanupThreshold: Int = 1000

    /// Throttling entry expiration time (seconds)
    public var throttlingEntryExpiration: TimeInterval = 300

    /// Default file exclusion patterns
    public var defaultExcludePatterns: [String] = [
        "*.tmp", "*.temp", "~$*", ".DS_Store", "Thumbs.db", "*.swp", "*.lock",
    ]
}

/// Performance and optimization configuration
public struct PerformanceConfig: Codable {
    /// File batch processing size
    public var fileBatchSize: Int = 100

    /// UI update pause interval (seconds)
    public var uiUpdatePauseInterval: TimeInterval = 0.001

    /// Memory cleanup threshold (entries)
    public var memoryCleanupThreshold: Int = 20

    /// Emergency memory cleanup threshold (entries)
    public var emergencyMemoryCleanupThreshold: Int = 1000

    /// Maximum performance history size
    public var maxPerformanceHistorySize: Int = 1000

    /// Maximum completed operations to track
    public var maxCompletedOperations: Int = 500

    /// Memory usage warning threshold (bytes)
    public var memoryWarningThreshold: Int64 = 100 * 1024 * 1024  // 100MB

    /// CPU usage warning threshold (percentage)
    public var cpuWarningThreshold: Double = 80.0

    /// Response time warning threshold (seconds)
    public var responseTimeWarningThreshold: TimeInterval = 5.0

    /// Performance monitoring interval (seconds)
    public var monitoringInterval: TimeInterval = 30.0
}

/// Storage management configuration
public struct StorageConfig: Codable {
    /// Default maximum storage size per space (GB)
    public var defaultMaxSizeGB: Double = 10.0

    /// Default storage warning threshold (0.0 to 1.0)
    public var defaultWarningThreshold: Double = 0.8

    /// Default maximum version age (days)
    public var defaultMaxVersionAgeDays: Int = 365

    /// Default cleanup frequency (hours)
    public var defaultCleanupFrequencyHours: Int = 24

    /// Storage monitoring interval (seconds)
    public var monitoringInterval: TimeInterval = 300

    /// Automatic cleanup enabled by default
    public var autoCleanupEnabledByDefault: Bool = true

    /// Storage notifications enabled by default
    public var notificationsEnabledByDefault: Bool = true
}

/// Search and indexing configuration
public struct SearchConfig: Codable {
    /// Maximum search results to return
    public var maxResults: Int = 1000

    /// Search index timeout (seconds)
    public var indexTimeout: TimeInterval = 30.0

    /// Minimum query length for search
    public var minQueryLength: Int = 2

    /// Maximum query length for search
    public var maxQueryLength: Int = 100

    /// Search result relevance threshold
    public var relevanceThreshold: Double = 0.1

    /// Index rebuild interval (hours)
    public var indexRebuildInterval: Int = 168  // 1 week

    /// Enable content indexing by default
    public var contentIndexingEnabledByDefault: Bool = true
}

/// User interface configuration
public struct UserInterfaceConfig: Codable {
    /// Default window width
    public var defaultWindowWidth: Double = 800

    /// Default window height
    public var defaultWindowHeight: Double = 600

    /// Minimum window width
    public var minWindowWidth: Double = 600

    /// Minimum window height
    public var minWindowHeight: Double = 400

    /// Animation duration (seconds)
    public var animationDuration: TimeInterval = 0.3

    /// Refresh interval for UI updates (seconds)
    public var refreshInterval: TimeInterval = 1.0

    /// Maximum items to display in lists
    public var maxListItems: Int = 1000

    /// Enable animations by default
    public var animationsEnabledByDefault: Bool = true
}

/// Network and synchronization configuration
public struct NetworkConfig: Codable {
    /// Default sync frequency (minutes)
    public var defaultSyncFrequencyMinutes: Int = 60

    /// Network timeout (seconds)
    public var networkTimeout: TimeInterval = 30.0

    /// Maximum retry attempts
    public var maxRetryAttempts: Int = 3

    /// Retry delay (seconds)
    public var retryDelay: TimeInterval = 5.0

    /// Enable network sync by default
    public var syncEnabledByDefault: Bool = false

    /// Maximum upload size (bytes)
    public var maxUploadSize: Int64 = 100 * 1024 * 1024  // 100MB
}

/// Security and privacy configuration
public struct SecurityConfig: Codable {
    /// Enable security audit logging
    public var auditLoggingEnabled: Bool = true

    /// Security event retention (days)
    public var securityEventRetentionDays: Int = 90

    /// Enable file access validation
    public var fileAccessValidationEnabled: Bool = true

    /// Enable encryption for sensitive data
    public var encryptionEnabled: Bool = true

    /// Security scan interval (hours)
    public var securityScanInterval: Int = 24
}

/// Logging and debugging configuration
public struct LoggingConfig: Codable {
    /// Enable file logging
    public var fileLoggingEnabled: Bool = true

    /// Enable console logging
    public var consoleLoggingEnabled: Bool = true

    /// Log file retention (days)
    public var logRetentionDays: Int = 30

    /// Maximum log file size (bytes)
    public var maxLogFileSize: Int64 = 10 * 1024 * 1024  // 10MB

    /// Default log level
    public var defaultLogLevel: String = "info"

    /// Enable performance logging
    public var performanceLoggingEnabled: Bool = true
}

// MARK: - Configuration Data Container

/// Container for all configuration data (for persistence)
private struct ConfigurationData: Codable {
    let fileSystemMonitoring: FileSystemMonitoringConfig
    let performance: PerformanceConfig
    let storage: StorageConfig
    let search: SearchConfig
    let userInterface: UserInterfaceConfig
    let network: NetworkConfig
    let security: SecurityConfig
    let logging: LoggingConfig
}

// MARK: - Configuration Errors

/// Configuration validation errors
public enum ConfigurationError: Error, LocalizedError {
    case invalidValue(String, String)
    case missingConfiguration(String)
    case validationFailed(String)

    public var errorDescription: String? {
        switch self {
        case .invalidValue(let key, let message):
            return "Invalid value for \(key): \(message)"
        case .missingConfiguration(let key):
            return "Missing configuration for \(key)"
        case .validationFailed(let message):
            return "Configuration validation failed: \(message)"
        }
    }
}

// MARK: - Configuration Extensions

extension AugmentConfiguration {

    /// Gets a configuration value by key path
    public func getValue<T>(keyPath: KeyPath<AugmentConfiguration, T>) -> T {
        return self[keyPath: keyPath]
    }

    /// Sets a configuration value by writable key path
    public func setValue<T>(keyPath: WritableKeyPath<AugmentConfiguration, T>, value: T) {
        self[keyPath: keyPath] = value
        saveConfiguration()
    }

    /// Exports configuration to JSON string
    public func exportConfiguration() -> String? {
        let config = ConfigurationData(
            fileSystemMonitoring: fileSystemMonitoring,
            performance: performance,
            storage: storage,
            search: search,
            userInterface: userInterface,
            network: network,
            security: security,
            logging: logging
        )

        guard let data = try? JSONEncoder().encode(config) else { return nil }
        return String(data: data, encoding: .utf8)
    }

    /// Imports configuration from JSON string
    public func importConfiguration(from jsonString: String) -> Bool {
        guard let data = jsonString.data(using: .utf8),
            let config = try? JSONDecoder().decode(ConfigurationData.self, from: data)
        else {
            return false
        }

        let errors = validateImportedConfiguration(config)
        guard errors.isEmpty else {
            return false
        }

        applyConfiguration(config)
        saveConfiguration()
        return true
    }

    private func validateImportedConfiguration(_ config: ConfigurationData) -> [ConfigurationError]
    {
        var errors: [ConfigurationError] = []

        // Validate imported configuration
        if config.fileSystemMonitoring.throttleInterval < 0.1 {
            errors.append(.invalidValue("throttleInterval", "Must be at least 0.1 seconds"))
        }

        if config.performance.fileBatchSize < 1 {
            errors.append(.invalidValue("fileBatchSize", "Must be at least 1"))
        }

        if config.storage.defaultMaxSizeGB < 0.1 {
            errors.append(.invalidValue("defaultMaxSizeGB", "Must be at least 0.1 GB"))
        }

        return errors
    }
}

// MARK: - Configuration Convenience Methods

extension AugmentConfiguration {

    /// Quick access to commonly used values
    public var fileMonitoringThrottleInterval: TimeInterval {
        return fileSystemMonitoring.throttleInterval
    }

    public var fileBatchProcessingSize: Int {
        return performance.fileBatchSize
    }

    public var defaultStorageMaxSizeBytes: Int64 {
        return Int64(storage.defaultMaxSizeGB * 1024 * 1024 * 1024)
    }

    public var maxSearchResults: Int {
        return search.maxResults
    }

    public var defaultWindowSize: (width: Double, height: Double) {
        return (userInterface.defaultWindowWidth, userInterface.defaultWindowHeight)
    }

    /// Environment-specific configurations
    public func configureForDevelopment() {
        logging.consoleLoggingEnabled = true
        logging.defaultLogLevel = "debug"
        performance.monitoringInterval = 10.0
        saveConfiguration()
    }

    public func configureForProduction() {
        logging.consoleLoggingEnabled = false
        logging.defaultLogLevel = "info"
        performance.monitoringInterval = 30.0
        security.auditLoggingEnabled = true
        saveConfiguration()
    }

    public func configureForTesting() {
        logging.fileLoggingEnabled = false
        logging.consoleLoggingEnabled = true
        performance.monitoringInterval = 1.0
        storage.monitoringInterval = 1.0
        saveConfiguration()
    }
}
