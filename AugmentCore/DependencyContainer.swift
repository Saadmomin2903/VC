import Foundation

/// Dependency injection container for managing Augment application dependencies
/// This replaces the singleton anti-pattern with proper dependency injection
public class DependencyContainer {

    // MARK: - Singleton for backward compatibility
    /// Shared instance for backward compatibility during transition
    public static let shared = DependencyContainer()

    // MARK: - Core Dependencies
    private var _metadataManager: MetadataManager?
    private var _versionControl: VersionControl?
    private var _searchEngine: SearchEngine?
    private var _fileSystemMonitor: FileSystemMonitor?
    private var _backupManager: BackupManager?
    private var _augmentFileSystem: AugmentFileSystem?
    private var _fileOperationInterceptor: FileOperationInterceptor?
    private var _storageManager: StorageManager?
    // private var _configuration: AugmentConfiguration?

    // MARK: - Thread Safety
    private let containerQueue = DispatchQueue(
        label: "com.augment.dependencycontainer",
        attributes: .concurrent
    )

    /// Private initializer
    private init() {}

    // MARK: - Dependency Factories

    /// Gets or creates MetadataManager instance
    public func metadataManager() -> MetadataManager {
        return containerQueue.sync {
            if let existing = _metadataManager {
                return existing
            }
            let instance = MetadataManager()
            _metadataManager = instance
            return instance
        }
    }

    /// Gets or creates VersionControl instance
    public func versionControl() -> VersionControl {
        return containerQueue.sync {
            if let existing = _versionControl {
                return existing
            }
            let instance = VersionControl(metadataManager: metadataManager())
            _versionControl = instance
            return instance
        }
    }

    /// Gets or creates SearchEngine instance
    public func searchEngine() -> SearchEngine {
        return containerQueue.sync {
            if let existing = _searchEngine {
                return existing
            }
            let instance = SearchEngine()
            _searchEngine = instance
            return instance
        }
    }

    /// Gets or creates FileSystemMonitor instance
    public func fileSystemMonitor() -> FileSystemMonitor {
        return containerQueue.sync {
            if let existing = _fileSystemMonitor {
                return existing
            }
            let instance = FileSystemMonitor()
            _fileSystemMonitor = instance
            return instance
        }
    }

    /// Gets or creates BackupManager instance
    public func backupManager() -> BackupManager {
        return containerQueue.sync {
            if let existing = _backupManager {
                return existing
            }
            let instance = BackupManager()
            _backupManager = instance
            return instance
        }
    }

    /// Gets or creates AugmentFileSystem instance
    public func augmentFileSystem() -> AugmentFileSystem {
        return containerQueue.sync {
            if let existing = _augmentFileSystem {
                return existing
            }
            let instance = AugmentFileSystem(versionControl: versionControl())
            _augmentFileSystem = instance
            return instance
        }
    }

    /// Gets or creates FileOperationInterceptor instance
    public func fileOperationInterceptor() -> FileOperationInterceptor {
        return containerQueue.sync {
            if let existing = _fileOperationInterceptor {
                return existing
            }
            let instance = FileOperationInterceptor(
                versionControl: versionControl(),
                fileSystemMonitor: fileSystemMonitor()
            )
            _fileOperationInterceptor = instance
            return instance
        }
    }

    /// Gets or creates StorageManager instance
    public func storageManager() -> StorageManager {
        return containerQueue.sync {
            if let existing = _storageManager {
                return existing
            }
            let instance = StorageManager()
            _storageManager = instance
            return instance
        }
    }

    /// Gets or creates AugmentConfiguration instance
    // public func configuration() -> AugmentConfiguration {
    //     return containerQueue.sync {
    //         if let existing = _configuration {
    //             return existing
    //         }
    //         let instance = AugmentConfiguration.shared
    //         _configuration = instance
    //         return instance
    //     }
    // }

    // MARK: - Testing Support

    /// Resets all dependencies - useful for testing
    public func reset() {
        containerQueue.async(flags: .barrier) {
            self._metadataManager = nil
            self._versionControl = nil
            self._searchEngine = nil
            self._fileSystemMonitor = nil
            self._backupManager = nil
            self._augmentFileSystem = nil
            self._fileOperationInterceptor = nil
            self._storageManager = nil
            // self._configuration = nil
        }
    }

    /// Creates a new container with fresh dependencies - useful for testing
    public static func createTestContainer() -> DependencyContainer {
        let container = DependencyContainer()
        return container
    }

    // MARK: - Dependency Injection Helpers

    /// Injects custom MetadataManager instance (for testing)
    public func inject(metadataManager: MetadataManager) {
        containerQueue.async(flags: .barrier) {
            self._metadataManager = metadataManager
        }
    }

    /// Injects custom VersionControl instance (for testing)
    public func inject(versionControl: VersionControl) {
        containerQueue.async(flags: .barrier) {
            self._versionControl = versionControl
        }
    }

    /// Injects custom SearchEngine instance (for testing)
    public func inject(searchEngine: SearchEngine) {
        containerQueue.async(flags: .barrier) {
            self._searchEngine = searchEngine
        }
    }

    /// Injects custom FileSystemMonitor instance (for testing)
    public func inject(fileSystemMonitor: FileSystemMonitor) {
        containerQueue.async(flags: .barrier) {
            self._fileSystemMonitor = fileSystemMonitor
        }
    }

    /// Injects custom BackupManager instance (for testing)
    public func inject(backupManager: BackupManager) {
        containerQueue.async(flags: .barrier) {
            self._backupManager = backupManager
        }
    }
}

// MARK: - Convenience Extensions

/// Protocol for dependency injection
public protocol DependencyInjectable {
    var dependencies: DependencyContainer { get }
}

/// Default implementation for dependency injection
extension DependencyInjectable {
    public var dependencies: DependencyContainer {
        return DependencyContainer.shared
    }
}
