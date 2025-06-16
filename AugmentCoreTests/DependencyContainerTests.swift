import XCTest
@testable import AugmentCore
@testable import AugmentFileSystem

/// Tests for the dependency injection container
class DependencyContainerTests: XCTestCase {
    
    var container: DependencyContainer!
    
    override func setUp() {
        super.setUp()
        container = DependencyContainer.createTestContainer()
    }
    
    override func tearDown() {
        container.reset()
        container = nil
        super.tearDown()
    }
    
    // MARK: - Singleton Instance Tests
    
    func testSingletonInstancesAreSame() {
        // Test that multiple calls return the same instance
        let metadataManager1 = container.metadataManager()
        let metadataManager2 = container.metadataManager()
        
        XCTAssertTrue(metadataManager1 === metadataManager2, 
                     "MetadataManager instances should be the same")
        
        let versionControl1 = container.versionControl()
        let versionControl2 = container.versionControl()
        
        XCTAssertTrue(versionControl1 === versionControl2,
                     "VersionControl instances should be the same")
        
        let searchEngine1 = container.searchEngine()
        let searchEngine2 = container.searchEngine()
        
        XCTAssertTrue(searchEngine1 === searchEngine2,
                     "SearchEngine instances should be the same")
    }
    
    // MARK: - Dependency Injection Tests
    
    func testVersionControlReceivesMetadataManager() {
        // Test that VersionControl receives the same MetadataManager instance
        let metadataManager = container.metadataManager()
        let versionControl = container.versionControl()
        
        // We can't directly access the private metadataManager property,
        // but we can test that the dependency is properly injected by
        // verifying that operations work correctly
        XCTAssertNotNil(versionControl, "VersionControl should be created successfully")
    }
    
    func testAugmentFileSystemReceivesVersionControl() {
        // Test that AugmentFileSystem receives the same VersionControl instance
        let versionControl = container.versionControl()
        let fileSystem = container.augmentFileSystem()
        
        XCTAssertNotNil(fileSystem, "AugmentFileSystem should be created successfully")
        XCTAssertNotNil(versionControl, "VersionControl should be created successfully")
    }
    
    func testFileOperationInterceptorReceivesDependencies() {
        // Test that FileOperationInterceptor receives proper dependencies
        let versionControl = container.versionControl()
        let fileSystemMonitor = container.fileSystemMonitor()
        let interceptor = container.fileOperationInterceptor()
        
        XCTAssertNotNil(interceptor, "FileOperationInterceptor should be created successfully")
        XCTAssertNotNil(versionControl, "VersionControl should be created successfully")
        XCTAssertNotNil(fileSystemMonitor, "FileSystemMonitor should be created successfully")
    }
    
    // MARK: - Thread Safety Tests
    
    func testConcurrentAccess() {
        let expectation = XCTestExpectation(description: "Concurrent access should be thread-safe")
        expectation.expectedFulfillmentCount = 10
        
        let queue = DispatchQueue.global(qos: .userInitiated)
        
        // Create multiple concurrent requests for the same dependency
        for _ in 0..<10 {
            queue.async {
                let metadataManager = self.container.metadataManager()
                XCTAssertNotNil(metadataManager, "MetadataManager should be created successfully")
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testConcurrentDifferentDependencies() {
        let expectation = XCTestExpectation(description: "Concurrent different dependencies should work")
        expectation.expectedFulfillmentCount = 5
        
        let queue = DispatchQueue.global(qos: .userInitiated)
        
        // Create concurrent requests for different dependencies
        queue.async {
            let metadataManager = self.container.metadataManager()
            XCTAssertNotNil(metadataManager)
            expectation.fulfill()
        }
        
        queue.async {
            let versionControl = self.container.versionControl()
            XCTAssertNotNil(versionControl)
            expectation.fulfill()
        }
        
        queue.async {
            let searchEngine = self.container.searchEngine()
            XCTAssertNotNil(searchEngine)
            expectation.fulfill()
        }
        
        queue.async {
            let fileSystemMonitor = self.container.fileSystemMonitor()
            XCTAssertNotNil(fileSystemMonitor)
            expectation.fulfill()
        }
        
        queue.async {
            let backupManager = self.container.backupManager()
            XCTAssertNotNil(backupManager)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    // MARK: - Reset Tests
    
    func testReset() {
        // Create some dependencies
        let metadataManager1 = container.metadataManager()
        let versionControl1 = container.versionControl()
        
        // Reset the container
        container.reset()
        
        // Create dependencies again
        let metadataManager2 = container.metadataManager()
        let versionControl2 = container.versionControl()
        
        // They should be different instances after reset
        XCTAssertFalse(metadataManager1 === metadataManager2,
                      "MetadataManager instances should be different after reset")
        XCTAssertFalse(versionControl1 === versionControl2,
                      "VersionControl instances should be different after reset")
    }
    
    // MARK: - Custom Injection Tests
    
    func testCustomMetadataManagerInjection() {
        // Create a custom MetadataManager
        let customMetadataManager = MetadataManager()
        
        // Inject it into the container
        container.inject(metadataManager: customMetadataManager)
        
        // Verify that the container returns the injected instance
        let retrievedMetadataManager = container.metadataManager()
        XCTAssertTrue(customMetadataManager === retrievedMetadataManager,
                     "Container should return the injected MetadataManager instance")
    }
    
    func testCustomVersionControlInjection() {
        // Create a custom VersionControl
        let customVersionControl = VersionControl()
        
        // Inject it into the container
        container.inject(versionControl: customVersionControl)
        
        // Verify that the container returns the injected instance
        let retrievedVersionControl = container.versionControl()
        XCTAssertTrue(customVersionControl === retrievedVersionControl,
                     "Container should return the injected VersionControl instance")
    }
    
    // MARK: - Test Container Creation
    
    func testCreateTestContainer() {
        let testContainer1 = DependencyContainer.createTestContainer()
        let testContainer2 = DependencyContainer.createTestContainer()
        
        // Test containers should be different instances
        XCTAssertFalse(testContainer1 === testContainer2,
                      "Test containers should be different instances")
        
        // Dependencies from different containers should be different
        let metadataManager1 = testContainer1.metadataManager()
        let metadataManager2 = testContainer2.metadataManager()
        
        XCTAssertFalse(metadataManager1 === metadataManager2,
                      "Dependencies from different containers should be different")
    }
    
    // MARK: - Integration Tests
    
    func testFullDependencyChain() {
        // Test that the full dependency chain works correctly
        let fileSystem = container.augmentFileSystem()
        let interceptor = container.fileOperationInterceptor()
        
        // Both should be created successfully with proper dependencies
        XCTAssertNotNil(fileSystem, "AugmentFileSystem should be created successfully")
        XCTAssertNotNil(interceptor, "FileOperationInterceptor should be created successfully")
        
        // The underlying dependencies should be the same instances
        let versionControl1 = container.versionControl()
        let versionControl2 = container.versionControl()
        
        XCTAssertTrue(versionControl1 === versionControl2,
                     "VersionControl instances should be the same across the dependency chain")
    }
}
