import Foundation
import os.signpost

/// Performance monitoring system for Augment application
/// Tracks performance metrics, memory usage, and system resources
public class PerformanceMonitor {
    
    // MARK: - Singleton for backward compatibility
    /// Shared instance for backward compatibility during transition
    public static let shared = PerformanceMonitor()
    
    // MARK: - Performance Metrics
    public struct PerformanceMetrics {
        public let timestamp: Date
        public let memoryUsage: UInt64 // in bytes
        public let cpuUsage: Double // percentage
        public let diskUsage: UInt64 // in bytes
        public let activeOperations: Int
        public let averageResponseTime: TimeInterval // in seconds
        
        public init(timestamp: Date = Date(), memoryUsage: UInt64, cpuUsage: Double, 
                   diskUsage: UInt64, activeOperations: Int, averageResponseTime: TimeInterval) {
            self.timestamp = timestamp
            self.memoryUsage = memoryUsage
            self.cpuUsage = cpuUsage
            self.diskUsage = diskUsage
            self.activeOperations = activeOperations
            self.averageResponseTime = averageResponseTime
        }
    }
    
    // MARK: - Operation Tracking
    public struct OperationMetrics {
        public let operationName: String
        public let startTime: CFAbsoluteTime
        public let endTime: CFAbsoluteTime?
        public let duration: TimeInterval?
        public let success: Bool?
        public let errorMessage: String?
        
        public var isCompleted: Bool {
            return endTime != nil
        }
        
        public init(operationName: String, startTime: CFAbsoluteTime = CFAbsoluteTimeGetCurrent()) {
            self.operationName = operationName
            self.startTime = startTime
            self.endTime = nil
            self.duration = nil
            self.success = nil
            self.errorMessage = nil
        }
        
        fileprivate init(operationName: String, startTime: CFAbsoluteTime, endTime: CFAbsoluteTime, 
                        success: Bool, errorMessage: String?) {
            self.operationName = operationName
            self.startTime = startTime
            self.endTime = endTime
            self.duration = endTime - startTime
            self.success = success
            self.errorMessage = errorMessage
        }
    }
    
    // MARK: - Properties
    private var activeOperations: [UUID: OperationMetrics] = [:]
    private var completedOperations: [OperationMetrics] = []
    private var performanceHistory: [PerformanceMetrics] = []
    
    // MARK: - Configuration
    private let maxHistorySize: Int = 1000
    private let maxCompletedOperations: Int = 500
    
    // MARK: - Thread Safety
    private let monitorQueue = DispatchQueue(
        label: "com.augment.performancemonitor",
        qos: .utility,
        attributes: .concurrent
    )
    
    // MARK: - OS Signpost
    private let signpostLog = OSLog(subsystem: "com.augment.app", category: "Performance")
    
    // MARK: - Monitoring Timer
    private var monitoringTimer: Timer?
    private var isMonitoring: Bool = false
    
    // MARK: - Logger
    private let logger: AugmentLogger
    
    // MARK: - Initialization
    
    /// Private initializer
    private init() {
        self.logger = AugmentLogger.shared
    }
    
    /// Public initializer for dependency injection
    public init(logger: AugmentLogger = AugmentLogger.shared) {
        self.logger = logger
    }
    
    // MARK: - Monitoring Control
    
    /// Starts performance monitoring
    public func startMonitoring(interval: TimeInterval = 30.0) {
        monitorQueue.async(flags: .barrier) {
            guard !self.isMonitoring else {
                self.logger.warning("Performance monitoring is already running", category: .performance)
                return
            }
            
            self.isMonitoring = true
            
            DispatchQueue.main.async {
                self.monitoringTimer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { _ in
                    self.collectPerformanceMetrics()
                }
            }
            
            self.logger.info("Performance monitoring started with \(interval)s interval", category: .performance)
        }
    }
    
    /// Stops performance monitoring
    public func stopMonitoring() {
        monitorQueue.async(flags: .barrier) {
            guard self.isMonitoring else {
                self.logger.warning("Performance monitoring is not running", category: .performance)
                return
            }
            
            self.isMonitoring = false
            
            DispatchQueue.main.async {
                self.monitoringTimer?.invalidate()
                self.monitoringTimer = nil
            }
            
            self.logger.info("Performance monitoring stopped", category: .performance)
        }
    }
    
    // MARK: - Operation Tracking
    
    /// Starts tracking an operation
    /// - Parameter operationName: Name of the operation
    /// - Returns: UUID to track the operation
    public func startOperation(_ operationName: String) -> UUID {
        let operationId = UUID()
        let metrics = OperationMetrics(operationName: operationName)
        
        monitorQueue.async(flags: .barrier) {
            self.activeOperations[operationId] = metrics
        }
        
        // OS Signpost
        os_signpost(.begin, log: signpostLog, name: "Operation", "%{public}@", operationName)
        
        logger.debug("Started operation: \(operationName)", category: .performance)
        
        return operationId
    }
    
    /// Ends tracking an operation
    /// - Parameters:
    ///   - operationId: UUID of the operation
    ///   - success: Whether the operation succeeded
    ///   - errorMessage: Optional error message if operation failed
    public func endOperation(_ operationId: UUID, success: Bool = true, errorMessage: String? = nil) {
        monitorQueue.async(flags: .barrier) {
            guard let activeMetrics = self.activeOperations.removeValue(forKey: operationId) else {
                self.logger.warning("Attempted to end unknown operation: \(operationId)", category: .performance)
                return
            }
            
            let endTime = CFAbsoluteTimeGetCurrent()
            let completedMetrics = OperationMetrics(
                operationName: activeMetrics.operationName,
                startTime: activeMetrics.startTime,
                endTime: endTime,
                success: success,
                errorMessage: errorMessage
            )
            
            self.completedOperations.append(completedMetrics)
            
            // Maintain size limit
            if self.completedOperations.count > self.maxCompletedOperations {
                self.completedOperations.removeFirst(self.completedOperations.count - self.maxCompletedOperations)
            }
            
            // OS Signpost
            os_signpost(.end, log: self.signpostLog, name: "Operation", "%{public}@", activeMetrics.operationName)
            
            let duration = completedMetrics.duration ?? 0
            let status = success ? "succeeded" : "failed"
            self.logger.info("Operation \(activeMetrics.operationName) \(status) in \(String(format: "%.3f", duration))s", 
                           category: .performance)
            
            if !success, let error = errorMessage {
                self.logger.error("Operation \(activeMetrics.operationName) failed: \(error)", category: .performance)
            }
        }
    }
    
    /// Measures execution time of a synchronous block
    public func measure<T>(_ operationName: String, block: () throws -> T) rethrows -> T {
        let operationId = startOperation(operationName)
        
        do {
            let result = try block()
            endOperation(operationId, success: true)
            return result
        } catch {
            endOperation(operationId, success: false, errorMessage: error.localizedDescription)
            throw error
        }
    }
    
    /// Measures execution time of an asynchronous block
    @available(macOS 10.15, *)
    public func measureAsync<T>(_ operationName: String, block: () async throws -> T) async rethrows -> T {
        let operationId = startOperation(operationName)
        
        do {
            let result = try await block()
            endOperation(operationId, success: true)
            return result
        } catch {
            endOperation(operationId, success: false, errorMessage: error.localizedDescription)
            throw error
        }
    }
    
    // MARK: - Metrics Collection
    
    private func collectPerformanceMetrics() {
        monitorQueue.async {
            let metrics = PerformanceMetrics(
                memoryUsage: self.getMemoryUsage(),
                cpuUsage: self.getCPUUsage(),
                diskUsage: self.getDiskUsage(),
                activeOperations: self.activeOperations.count,
                averageResponseTime: self.calculateAverageResponseTime()
            )
            
            self.performanceHistory.append(metrics)
            
            // Maintain size limit
            if self.performanceHistory.count > self.maxHistorySize {
                self.performanceHistory.removeFirst(self.performanceHistory.count - self.maxHistorySize)
            }
            
            // Log performance metrics
            self.logger.debug(
                "Performance: Memory=\(self.formatBytes(metrics.memoryUsage)), " +
                "CPU=\(String(format: "%.1f", metrics.cpuUsage))%, " +
                "Disk=\(self.formatBytes(metrics.diskUsage)), " +
                "Active Ops=\(metrics.activeOperations), " +
                "Avg Response=\(String(format: "%.3f", metrics.averageResponseTime))s",
                category: .performance
            )
            
            // Check for performance issues
            self.checkPerformanceThresholds(metrics)
        }
    }
    
    // MARK: - System Metrics
    
    private func getMemoryUsage() -> UInt64 {
        var info = mach_task_basic_info()
        var count = mach_msg_type_number_t(MemoryLayout<mach_task_basic_info>.size)/4
        
        let kerr: kern_return_t = withUnsafeMutablePointer(to: &info) {
            $0.withMemoryRebound(to: integer_t.self, capacity: 1) {
                task_info(mach_task_self_,
                         task_flavor_t(MACH_TASK_BASIC_INFO),
                         $0,
                         &count)
            }
        }
        
        if kerr == KERN_SUCCESS {
            return info.resident_size
        } else {
            return 0
        }
    }
    
    private func getCPUUsage() -> Double {
        // Simplified CPU usage - in a real implementation, you'd want more accurate measurement
        return 0.0
    }
    
    private func getDiskUsage() -> UInt64 {
        // Get disk usage for the application's documents directory
        do {
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let resourceValues = try documentsURL.resourceValues(forKeys: [.volumeAvailableCapacityKey])
            return UInt64(resourceValues.volumeAvailableCapacity ?? 0)
        } catch {
            return 0
        }
    }
    
    private func calculateAverageResponseTime() -> TimeInterval {
        let recentOperations = completedOperations.suffix(10)
        guard !recentOperations.isEmpty else { return 0.0 }
        
        let totalTime = recentOperations.compactMap { $0.duration }.reduce(0, +)
        return totalTime / Double(recentOperations.count)
    }
    
    // MARK: - Performance Analysis
    
    private func checkPerformanceThresholds(_ metrics: PerformanceMetrics) {
        // Memory threshold (100MB)
        if metrics.memoryUsage > 100 * 1024 * 1024 {
            logger.warning("High memory usage detected: \(formatBytes(metrics.memoryUsage))", category: .performance)
        }
        
        // CPU threshold (80%)
        if metrics.cpuUsage > 80.0 {
            logger.warning("High CPU usage detected: \(String(format: "%.1f", metrics.cpuUsage))%", category: .performance)
        }
        
        // Response time threshold (5 seconds)
        if metrics.averageResponseTime > 5.0 {
            logger.warning("Slow response time detected: \(String(format: "%.3f", metrics.averageResponseTime))s", category: .performance)
        }
        
        // Too many active operations (50)
        if metrics.activeOperations > 50 {
            logger.warning("High number of active operations: \(metrics.activeOperations)", category: .performance)
        }
    }
    
    // MARK: - Public API
    
    /// Gets current performance metrics
    public func getCurrentMetrics() -> PerformanceMetrics? {
        return monitorQueue.sync {
            return performanceHistory.last
        }
    }
    
    /// Gets performance history
    public func getPerformanceHistory(limit: Int? = nil) -> [PerformanceMetrics] {
        return monitorQueue.sync {
            if let limit = limit {
                return Array(performanceHistory.suffix(limit))
            }
            return performanceHistory
        }
    }
    
    /// Gets active operations
    public func getActiveOperations() -> [OperationMetrics] {
        return monitorQueue.sync {
            return Array(activeOperations.values)
        }
    }
    
    /// Gets completed operations
    public func getCompletedOperations(limit: Int? = nil) -> [OperationMetrics] {
        return monitorQueue.sync {
            if let limit = limit {
                return Array(completedOperations.suffix(limit))
            }
            return completedOperations
        }
    }
    
    // MARK: - Utility Methods
    
    private func formatBytes(_ bytes: UInt64) -> String {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = [.useKB, .useMB, .useGB]
        formatter.countStyle = .memory
        return formatter.string(fromByteCount: Int64(bytes))
    }
    
    /// Resets all performance data
    public func reset() {
        monitorQueue.async(flags: .barrier) {
            self.activeOperations.removeAll()
            self.completedOperations.removeAll()
            self.performanceHistory.removeAll()
            self.logger.info("Performance monitor data reset", category: .performance)
        }
    }
}
