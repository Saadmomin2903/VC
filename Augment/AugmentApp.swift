import Foundation
import SwiftUI

@main
struct AugmentApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @State private var isShowingPreferences = false
    @State private var fileToOpen: String?
    @State private var openVersionHistory = false
    @State private var openRestoreVersion = false

    init() {
        // Parse command-line arguments
        let arguments = CommandLine.arguments

        for (index, argument) in arguments.enumerated() {
            if argument == "--open-version-history" && index + 1 < arguments.count {
                fileToOpen = arguments[index + 1]
                openVersionHistory = true
            } else if argument == "--restore-version" && index + 1 < arguments.count {
                fileToOpen = arguments[index + 1]
                openRestoreVersion = true
            }
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView(
                fileToOpen: fileToOpen,
                openVersionHistory: openVersionHistory,
                openRestoreVersion: openRestoreVersion
            )
            .frame(minWidth: 800, minHeight: 600)
        }
        .windowStyle(HiddenTitleBarWindowStyle())
        .commands {
            CommandGroup(replacing: .appSettings) {
                Button("Preferences...") {
                    isShowingPreferences = true
                }
                .keyboardShortcut(",", modifiers: .command)
            }
        }

        // Add menu bar extra
        MenuBarExtra("Augment", systemImage: "clock.arrow.circlepath") {
            MenuBarView(isShowingPreferences: $isShowingPreferences)
        }

        // Add preferences window
        Window("Preferences", id: "preferences") {
            Text("Preferences")
        }
        .windowStyle(HiddenTitleBarWindowStyle())
        .windowResizability(.contentSize)
        .defaultPosition(.center)
        .defaultSize(CGSize(width: 500, height: 400))
        .keyboardShortcut(",", modifiers: .command)
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusBarItem: NSStatusItem?
    private var snapshotScheduler: Timer?

    func applicationDidFinishLaunching(_ notification: Notification) {
        // SIMPLIFIED VERSION: Disable auto versioning features
        print("🔧 AugmentApp: Starting in SIMPLIFIED mode (no auto versioning)")

        // Only register for URL events - disable auto monitoring
        NSAppleEventManager.shared().setEventHandler(
            self,
            andSelector: #selector(handleURLEvent(_:withReplyEvent:)),
            forEventClass: AEEventClass(kInternetEventClass),
            andEventID: AEEventID(kAEGetURL)
        )

        print("✅ AugmentApp: Simplified initialization completed")
    }

    @objc func handleURLEvent(
        _ event: NSAppleEventDescriptor, withReplyEvent replyEvent: NSAppleEventDescriptor
    ) {
        guard let urlString = event.paramDescriptor(forKeyword: keyDirectObject)?.stringValue,
            let url = URL(string: urlString)
        else {
            return
        }

        handleCustomURL(url)
    }

    private func handleCustomURL(_ url: URL) {
        guard url.scheme == "augment" else { return }

        switch url.host {
        case "version-history":
            if let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
                let queryItems = components.queryItems,
                let filePathItem = queryItems.first(where: { $0.name == "file" }),
                let filePath = filePathItem.value
            {

                // Bring app to front
                NSApp.activate(ignoringOtherApps: true)

                // Post notification to open version history
                NotificationCenter.default.post(
                    name: NSNotification.Name("OpenVersionHistory"),
                    object: filePath
                )
            }
        default:
            break
        }
    }

    private func initializeFileSystemMonitor() {
        // TODO: REFACTOR TO DEPENDENCY INJECTION - Currently using singletons for compatibility
        let fileSystem = AugmentFileSystem.shared
        let fileSystemMonitor = FileSystemMonitor.shared
        let fileOperationInterceptor = FileOperationInterceptor.shared

        // Get all spaces
        let spaces = fileSystem.getSpaces()

        // Initialize the file system monitor for each space
        for space in spaces {
            _ = fileSystemMonitor.startMonitoring(
                spacePath: space.path
            ) { (url, event) in
                // Handle file system events
                fileOperationInterceptor.handleFileSystemEvent(
                    url: url, event: event, space: space)
            }
        }
    }

    private func registerForFileSystemEvents() {
        // Register for file system events using the FileSystemMonitor
        // This is handled in initializeFileSystemMonitor
    }

    private func initializeSearchEngine() {
        // TODO: REFACTOR TO DEPENDENCY INJECTION - Currently using singletons for compatibility
        let fileSystem = AugmentFileSystem.shared
        let searchEngine = SearchEngine.shared

        // Get all spaces
        let spaces = fileSystem.getSpaces()

        // Index each space serially to prevent race conditions
        // Use a single background queue to serialize the indexing operations
        DispatchQueue.global(qos: .background).async {
            print("SearchEngine: Starting indexing of \(spaces.count) spaces...")

            for (index, space) in spaces.enumerated() {
                print("SearchEngine: Indexing space \(index + 1)/\(spaces.count): \(space.name)")

                do {
                    let success = SearchEngine.shared.indexSpace(spacePath: space.path)
                    if success {
                        print("SearchEngine: Successfully indexed space: \(space.name)")
                    } else {
                        print("SearchEngine: Failed to index space: \(space.name)")
                    }
                } catch {
                    print("SearchEngine: Error indexing space \(space.name): \(error)")
                }
            }

            print("SearchEngine: Completed indexing all spaces")
        }
    }

    private func startSnapshotScheduler() {
        // Create a timer that runs every hour to check for scheduled snapshots
        snapshotScheduler = Timer.scheduledTimer(withTimeInterval: 60 * 60, repeats: true) {
            [weak self] _ in
            self?.checkScheduledSnapshots()
        }
    }

    private func checkScheduledSnapshots() {
        // This will be handled by the SnapshotScheduler in SnapshotManager
    }
}

struct MenuBarView: View {
    @State private var spaces: [AugmentSpace] = []
    @State private var isCreatingNewSpace = false
    @State private var newSpaceName = ""
    @State private var newSpaceLocation = ""
    @Binding var isShowingPreferences: Bool

    // TODO: REFACTOR TO DEPENDENCY INJECTION - Currently using singletons for compatibility
    private let fileSystem = AugmentFileSystem.shared

    var body: some View {
        VStack(alignment: .leading) {
            Text("Augment Spaces")
                .font(.headline)
                .padding(.bottom, 5)

            Divider()

            if spaces.isEmpty {
                Text("No spaces available")
                    .foregroundColor(.gray)
                    .padding(.vertical, 5)
            } else {
                ForEach(spaces) { space in
                    Button(space.name) {
                        openSpace(space)
                    }
                }
            }

            Divider()

            Button("Create New Space...") {
                isCreatingNewSpace = true
            }

            Button("Open Space...") {
                openSpaceDialog()
            }

            Divider()

            Button("Preferences...") {
                isShowingPreferences = true
                NSApp.activate(ignoringOtherApps: true)
            }

            Divider()

            Button("Quit") {
                NSApplication.shared.terminate(nil)
            }
        }
        .padding()
        .frame(width: 200)
        .onAppear {
            loadSpaces()
        }
        .sheet(isPresented: $isCreatingNewSpace) {
            NewSpaceView(
                isPresented: $isCreatingNewSpace,
                spaceName: $newSpaceName,
                spaceLocation: $newSpaceLocation,
                onCreateSpace: createNewSpace
            )
        }
    }

    private func loadSpaces() {
        // Load spaces from the file system
        spaces = fileSystem.getSpaces()
    }

    private func openSpace(_ space: AugmentSpace) {
        // Open the main app window
        NSApp.activate(ignoringOtherApps: true)

        // TODO: Navigate to the space in the main window
    }

    private func openSpaceDialog() {
        // Create an open panel
        let openPanel = NSOpenPanel()
        openPanel.canChooseDirectories = true
        openPanel.canChooseFiles = false
        openPanel.allowsMultipleSelection = false
        openPanel.message = "Select a folder to open as an Augment space"

        // Show the panel
        openPanel.begin { response in
            if response == .OK, let url = openPanel.url {
                // Create a space for the selected folder
                if let space = fileSystem.createSpace(name: url.lastPathComponent, path: url) {
                    spaces.append(space)
                    openSpace(space)
                }
            }
        }
    }

    private func createNewSpace() {
        guard !newSpaceName.isEmpty, !newSpaceLocation.isEmpty else { return }

        // Create the space using the file system
        if let newSpace = fileSystem.createSpace(
            name: newSpaceName,
            path: URL(fileURLWithPath: newSpaceLocation)
        ) {
            spaces.append(newSpace)
            openSpace(newSpace)
        }

        // Reset form
        newSpaceName = ""
        newSpaceLocation = ""
        isCreatingNewSpace = false
    }
}
