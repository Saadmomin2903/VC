import XCTest
import Foundation
@testable import Augment

/// Comprehensive tests for AugmentConfiguration functionality
class AugmentConfigurationTests: XCTestCase {
    
    var configuration: AugmentConfiguration!
    
    override func setUp() {
        super.setUp()
        
        // Create a fresh configuration instance for testing
        configuration = AugmentConfiguration()
        
        // Reset to defaults to ensure clean state
        configuration.resetToDefaults()
    }
    
    override func tearDown() {
        configuration = nil
        super.tearDown()
    }
    
    // MARK: - Initialization Tests
    
    func testConfigurationInitialization() {
        XCTAssertNotNil(configuration)
        XCTAssertNotNil(configuration.fileSystemMonitoring)
        XCTAssertNotNil(configuration.performance)
        XCTAssertNotNil(configuration.storage)
        XCTAssertNotNil(configuration.search)
        XCTAssertNotNil(configuration.userInterface)
        XCTAssertNotNil(configuration.network)
        XCTAssertNotNil(configuration.security)
        XCTAssertNotNil(configuration.logging)
    }
    
    func testDefaultValues() {
        // Test file system monitoring defaults
        XCTAssertEqual(configuration.fileSystemMonitoring.throttleInterval, 5.0)
        XCTAssertEqual(configuration.fileSystemMonitoring.maxMonitoredSpaces, 50)
        XCTAssertEqual(configuration.fileSystemMonitoring.fsEventsLatency, 1.0)
        
        // Test performance defaults
        XCTAssertEqual(configuration.performance.fileBatchSize, 100)
        XCTAssertEqual(configuration.performance.memoryCleanupThreshold, 20)
        XCTAssertEqual(configuration.performance.emergencyMemoryCleanupThreshold, 1000)
        
        // Test storage defaults
        XCTAssertEqual(configuration.storage.defaultMaxSizeGB, 10.0)
        XCTAssertEqual(configuration.storage.defaultWarningThreshold, 0.8)
        XCTAssertEqual(configuration.storage.defaultMaxVersionAgeDays, 365)
        
        // Test search defaults
        XCTAssertEqual(configuration.search.maxResults, 1000)
        XCTAssertEqual(configuration.search.indexTimeout, 30.0)
        XCTAssertEqual(configuration.search.minQueryLength, 2)
    }
    
    // MARK: - Configuration Persistence Tests
    
    func testSaveAndLoadConfiguration() {
        // Modify some values
        configuration.fileSystemMonitoring.throttleInterval = 10.0
        configuration.performance.fileBatchSize = 200
        configuration.storage.defaultMaxSizeGB = 20.0
        
        // Save configuration
        configuration.saveConfiguration()
        
        // Create new instance and load
        let newConfiguration = AugmentConfiguration()
        newConfiguration.loadConfiguration()
        
        // Verify values were persisted
        XCTAssertEqual(newConfiguration.fileSystemMonitoring.throttleInterval, 10.0)
        XCTAssertEqual(newConfiguration.performance.fileBatchSize, 200)
        XCTAssertEqual(newConfiguration.storage.defaultMaxSizeGB, 20.0)
    }
    
    func testResetToDefaults() {
        // Modify some values
        configuration.fileSystemMonitoring.throttleInterval = 15.0
        configuration.performance.fileBatchSize = 500
        configuration.storage.defaultMaxSizeGB = 50.0
        
        // Reset to defaults
        configuration.resetToDefaults()
        
        // Verify values are back to defaults
        XCTAssertEqual(configuration.fileSystemMonitoring.throttleInterval, 5.0)
        XCTAssertEqual(configuration.performance.fileBatchSize, 100)
        XCTAssertEqual(configuration.storage.defaultMaxSizeGB, 10.0)
    }
    
    // MARK: - Configuration Validation Tests
    
    func testValidConfiguration() {
        let errors = configuration.validateConfiguration()
        XCTAssertTrue(errors.isEmpty, "Default configuration should be valid")
    }
    
    func testInvalidThrottleInterval() {
        configuration.fileSystemMonitoring.throttleInterval = 0.05 // Too small
        
        let errors = configuration.validateConfiguration()
        XCTAssertFalse(errors.isEmpty)
        
        let hasThrottleError = errors.contains { error in
            if case .invalidValue(let key, _) = error {
                return key.contains("throttleInterval")
            }
            return false
        }
        XCTAssertTrue(hasThrottleError)
    }
    
    func testInvalidFileBatchSize() {
        configuration.performance.fileBatchSize = 0 // Invalid
        
        let errors = configuration.validateConfiguration()
        XCTAssertFalse(errors.isEmpty)
        
        let hasBatchSizeError = errors.contains { error in
            if case .invalidValue(let key, _) = error {
                return key.contains("fileBatchSize")
            }
            return false
        }
        XCTAssertTrue(hasBatchSizeError)
    }
    
    func testInvalidStorageSize() {
        configuration.storage.defaultMaxSizeGB = 0.05 // Too small
        
        let errors = configuration.validateConfiguration()
        XCTAssertFalse(errors.isEmpty)
        
        let hasStorageError = errors.contains { error in
            if case .invalidValue(let key, _) = error {
                return key.contains("defaultMaxSizeGB")
            }
            return false
        }
        XCTAssertTrue(hasStorageError)
    }
    
    func testInvalidSearchResults() {
        configuration.search.maxResults = 0 // Invalid
        
        let errors = configuration.validateConfiguration()
        XCTAssertFalse(errors.isEmpty)
        
        let hasSearchError = errors.contains { error in
            if case .invalidValue(let key, _) = error {
                return key.contains("maxResults")
            }
            return false
        }
        XCTAssertTrue(hasSearchError)
    }
    
    // MARK: - Import/Export Tests
    
    func testExportConfiguration() {
        // Modify some values
        configuration.fileSystemMonitoring.throttleInterval = 7.5
        configuration.performance.fileBatchSize = 150
        
        let jsonString = configuration.exportConfiguration()
        XCTAssertNotNil(jsonString)
        XCTAssertTrue(jsonString!.contains("7.5"))
        XCTAssertTrue(jsonString!.contains("150"))
    }
    
    func testImportValidConfiguration() {
        let jsonString = """
        {
            "fileSystemMonitoring": {
                "throttleInterval": 8.0,
                "maxMonitoredSpaces": 75,
                "fsEventsLatency": 1.5,
                "throttlingCleanupThreshold": 25,
                "emergencyCleanupThreshold": 1200,
                "throttlingEntryExpiration": 400,
                "defaultExcludePatterns": ["*.tmp", "*.temp"]
            },
            "performance": {
                "fileBatchSize": 250,
                "uiUpdatePauseInterval": 0.002,
                "memoryCleanupThreshold": 30,
                "emergencyMemoryCleanupThreshold": 1500,
                "maxPerformanceHistorySize": 1200,
                "maxCompletedOperations": 600,
                "memoryWarningThreshold": 120000000,
                "cpuWarningThreshold": 85.0,
                "responseTimeWarningThreshold": 6.0,
                "monitoringInterval": 35.0
            },
            "storage": {
                "defaultMaxSizeGB": 15.0,
                "defaultWarningThreshold": 0.75,
                "defaultMaxVersionAgeDays": 400,
                "defaultCleanupFrequencyHours": 48,
                "monitoringInterval": 600,
                "autoCleanupEnabledByDefault": true,
                "notificationsEnabledByDefault": true
            },
            "search": {
                "maxResults": 1500,
                "indexTimeout": 45.0,
                "minQueryLength": 3,
                "maxQueryLength": 120,
                "relevanceThreshold": 0.15,
                "indexRebuildInterval": 200,
                "contentIndexingEnabledByDefault": true
            },
            "userInterface": {
                "defaultWindowWidth": 900,
                "defaultWindowHeight": 700,
                "minWindowWidth": 650,
                "minWindowHeight": 450,
                "animationDuration": 0.4,
                "refreshInterval": 1.5,
                "maxListItems": 1200,
                "animationsEnabledByDefault": true
            },
            "network": {
                "defaultSyncFrequencyMinutes": 90,
                "networkTimeout": 45.0,
                "maxRetryAttempts": 5,
                "retryDelay": 7.0,
                "syncEnabledByDefault": false,
                "maxUploadSize": 120000000
            },
            "security": {
                "auditLoggingEnabled": true,
                "securityEventRetentionDays": 120,
                "fileAccessValidationEnabled": true,
                "encryptionEnabled": true,
                "securityScanInterval": 48
            },
            "logging": {
                "fileLoggingEnabled": true,
                "consoleLoggingEnabled": true,
                "logRetentionDays": 45,
                "maxLogFileSize": 15000000,
                "defaultLogLevel": "debug",
                "performanceLoggingEnabled": true
            }
        }
        """
        
        let success = configuration.importConfiguration(from: jsonString)
        XCTAssertTrue(success)
        
        // Verify imported values
        XCTAssertEqual(configuration.fileSystemMonitoring.throttleInterval, 8.0)
        XCTAssertEqual(configuration.performance.fileBatchSize, 250)
        XCTAssertEqual(configuration.storage.defaultMaxSizeGB, 15.0)
        XCTAssertEqual(configuration.search.maxResults, 1500)
    }
    
    func testImportInvalidConfiguration() {
        let invalidJsonString = """
        {
            "fileSystemMonitoring": {
                "throttleInterval": 0.05
            },
            "performance": {
                "fileBatchSize": 0
            }
        }
        """
        
        let success = configuration.importConfiguration(from: invalidJsonString)
        XCTAssertFalse(success, "Should reject invalid configuration")
    }
    
    func testImportMalformedJSON() {
        let malformedJson = "{ invalid json }"
        
        let success = configuration.importConfiguration(from: malformedJson)
        XCTAssertFalse(success, "Should reject malformed JSON")
    }
    
    // MARK: - Convenience Methods Tests
    
    func testConvenienceAccessors() {
        configuration.fileSystemMonitoring.throttleInterval = 12.5
        configuration.performance.fileBatchSize = 300
        configuration.storage.defaultMaxSizeGB = 25.0
        configuration.search.maxResults = 2000
        
        XCTAssertEqual(configuration.fileMonitoringThrottleInterval, 12.5)
        XCTAssertEqual(configuration.fileBatchProcessingSize, 300)
        XCTAssertEqual(configuration.defaultStorageMaxSizeBytes, 25 * 1024 * 1024 * 1024)
        XCTAssertEqual(configuration.maxSearchResults, 2000)
        
        let windowSize = configuration.defaultWindowSize
        XCTAssertEqual(windowSize.width, configuration.userInterface.defaultWindowWidth)
        XCTAssertEqual(windowSize.height, configuration.userInterface.defaultWindowHeight)
    }
    
    // MARK: - Environment Configuration Tests
    
    func testDevelopmentConfiguration() {
        configuration.configureForDevelopment()
        
        XCTAssertTrue(configuration.logging.consoleLoggingEnabled)
        XCTAssertEqual(configuration.logging.defaultLogLevel, "debug")
        XCTAssertEqual(configuration.performance.monitoringInterval, 10.0)
    }
    
    func testProductionConfiguration() {
        configuration.configureForProduction()
        
        XCTAssertFalse(configuration.logging.consoleLoggingEnabled)
        XCTAssertEqual(configuration.logging.defaultLogLevel, "info")
        XCTAssertEqual(configuration.performance.monitoringInterval, 30.0)
        XCTAssertTrue(configuration.security.auditLoggingEnabled)
    }
    
    func testTestingConfiguration() {
        configuration.configureForTesting()
        
        XCTAssertFalse(configuration.logging.fileLoggingEnabled)
        XCTAssertTrue(configuration.logging.consoleLoggingEnabled)
        XCTAssertEqual(configuration.performance.monitoringInterval, 1.0)
        XCTAssertEqual(configuration.storage.monitoringInterval, 1.0)
    }
}
