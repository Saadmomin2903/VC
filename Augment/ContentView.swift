import Foundation
import SwiftUI

struct ContentView: View {
    @State private var selectedSpace: AugmentSpace?
    @State private var spaces: [AugmentSpace] = []
    @State private var isCreatingNewSpace = false
    @State private var newSpaceName = ""
    @State private var newSpaceLocation = ""
    @State private var isSearching = false
    @State private var isShowingConflicts = false
    @State private var activeConflicts: [FileConflict] = []
    @State private var isShowingVersionHistory = false
    @State private var isShowingRestoreVersion = false
    @State private var selectedFile: FileItem?

    var fileToOpen: String?
    var openVersionHistory: Bool
    var openRestoreVersion: Bool

    // TODO: REFACTOR TO DEPENDENCY INJECTION - Currently using singletons for compatibility
    private let fileSystem = AugmentFileSystem.shared
    private let conflictManager = ConflictManager.shared
    private let versionControl = VersionControl.shared

    init(
        fileToOpen: String? = nil, openVersionHistory: Bool = false,
        openRestoreVersion: Bool = false
    ) {
        self.fileToOpen = fileToOpen
        self.openVersionHistory = openVersionHistory
        self.openRestoreVersion = openRestoreVersion
    }

    var body: some View {
        NavigationView {
            // Sidebar with spaces list
            List(selection: $selectedSpace) {
                Section(header: Text("SPACES")) {
                    ForEach(spaces) { space in
                        NavigationLink(destination: SpaceDetailView(space: space)) {
                            Label(space.name, systemImage: "folder")
                        }
                        .contextMenu {
                            Button("Browse Files & Version History") {
                                selectedSpace = space
                            }

                            Button("Search in Space") {
                                selectedSpace = space
                                isSearching = true
                            }

                            Divider()

                            Button("Open in Finder") {
                                NSWorkspace.shared.open(space.path)
                            }

                            Button("View Snapshots") {
                                selectedSpace = space
                                // Navigate to snapshots tab in SpaceDetailView
                            }

                            Divider()

                            Button("Rename") {
                                // TODO: Implement rename functionality
                            }

                            Button("Delete") {
                                deleteSpace(space)
                            }
                            .foregroundColor(.red)
                        }
                    }
                }

                if !activeConflicts.isEmpty {
                    Section(header: Text("CONFLICTS")) {
                        ForEach(activeConflicts, id: \.id) { conflict in
                            Button(action: {
                                isShowingConflicts = true
                            }) {
                                Label(
                                    conflict.filePath.lastPathComponent,
                                    systemImage: "exclamationmark.triangle"
                                )
                                .foregroundColor(.orange)
                            }
                        }
                    }
                }
            }
            .listStyle(SidebarListStyle())
            .frame(minWidth: 200)
            // Toolbar temporarily removed to fix compilation
            // TODO: Re-add toolbar with proper SwiftUI syntax

            // Default view when no space is selected
            if selectedSpace == nil {
                VStack(spacing: 20) {
                    Image(systemName: "clock.arrow.circlepath")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100)
                        .foregroundColor(.blue)

                    Text("Welcome to Augment")
                        .font(.largeTitle)
                        .fontWeight(.bold)

                    VStack(spacing: 8) {
                        Text("Comprehensive File Version History")
                            .font(.title2)
                            .foregroundColor(.primary)

                        Text("• Automatic version creation when files are modified")
                            .foregroundColor(.secondary)
                        Text("• Complete version history with timestamps and comments")
                            .foregroundColor(.secondary)
                        Text("• Side-by-side file comparison and diff viewing")
                            .foregroundColor(.secondary)
                        Text("• Safe file rollback with automatic backups")
                            .foregroundColor(.secondary)
                        Text("• Integrated search across all your spaces")
                            .foregroundColor(.secondary)
                    }
                    .multilineTextAlignment(.leading)

                    Text(
                        "Select a space from the sidebar to browse files and view version history, or create a new space to get started."
                    )
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                    HStack(spacing: 16) {
                        Button("Create New Space") {
                            isCreatingNewSpace = true
                        }
                        .buttonStyle(.borderedProminent)

                        Button("Search Files") {
                            isSearching = true
                        }
                        .buttonStyle(.bordered)
                        .disabled(spaces.isEmpty)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding()
            }
        }
        .sheet(isPresented: $isCreatingNewSpace) {
            NewSpaceView(
                isPresented: $isCreatingNewSpace,
                spaceName: $newSpaceName,
                spaceLocation: $newSpaceLocation,
                onCreateSpace: createNewSpace
            )
        }
        .sheet(isPresented: $isSearching) {
            if !spaces.isEmpty {
                SearchView(spaces: spaces)
            }
        }
        .sheet(isPresented: $isShowingConflicts) {
            if let conflict = activeConflicts.first {
                ConflictResolutionView(conflict: conflict)
            }
        }
        .onAppear {
            loadSpaces()
            checkForConflicts()
            handleFileToOpen()
        }
        .onReceive(
            NotificationCenter.default.publisher(for: NSNotification.Name("OpenVersionHistory"))
        ) { notification in
            if let filePath = notification.object as? String {
                openVersionHistoryForFile(filePath)
            }
        }
        .sheet(isPresented: $isShowingVersionHistory) {
            if let file = selectedFile {
                VersionBrowser(file: file)
            }
        }
        .sheet(isPresented: $isShowingRestoreVersion) {
            if let file = selectedFile {
                VersionBrowser(file: file)
            }
        }
    }

    private func loadSpaces() {
        // CRITICAL FIX #10: Remove hardcoded production data and implement safe space loading

        // Load spaces from the file system
        spaces = fileSystem.getSpaces()

        // If no spaces exist, create safe example spaces only if the directories actually exist
        if spaces.isEmpty {
            print("ContentView: No existing spaces found, creating example spaces...")

            // Try to create example spaces with safe, existing paths using proper initialization
            let potentialPaths = [
                (
                    name: "Documents",
                    path: FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
                        .first
                ),
                (
                    name: "Desktop",
                    path: FileManager.default.urls(for: .desktopDirectory, in: .userDomainMask)
                        .first
                ),
                (
                    name: "Downloads",
                    path: FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask)
                        .first
                ),
            ]

            for (name, pathURL) in potentialPaths {
                if let url = pathURL,
                    FileManager.default.fileExists(atPath: url.path),
                    FileManager.default.isReadableFile(atPath: url.path)
                {
                    // Only add if we can actually access the directory
                    do {
                        _ = try FileManager.default.contentsOfDirectory(
                            at: url, includingPropertiesForKeys: nil)

                        // CRITICAL FIX: Use fileSystem.createSpace() to properly initialize version control
                        // This ensures .augment directory structure is created
                        if let exampleSpace = fileSystem.createSpace(name: name, path: url) {
                            spaces.append(exampleSpace)
                            print(
                                "ContentView: Successfully created example space '\(name)' with version control"
                            )
                        } else {
                            print(
                                "ContentView: Failed to create example space '\(name)' - may already exist"
                            )
                            // Check if space already exists in fileSystem
                            if let existingSpace = fileSystem.getSpace(path: url) {
                                spaces.append(existingSpace)
                                print("ContentView: Found existing space '\(name)'")
                            }
                        }
                    } catch {
                        print("ContentView: Cannot access \(name) directory: \(error)")
                        // Skip this directory if we can't access it
                    }
                }
            }

            if !spaces.isEmpty {
                print(
                    "ContentView: Created \(spaces.count) example spaces with proper version control initialization"
                )
            } else {
                print(
                    "ContentView: No valid example spaces found - user will need to create spaces manually"
                )
            }
        }
    }

    private func createNewSpace() {
        // CRITICAL FIX #15: Add comprehensive input validation for space creation

        // Validate space name
        guard !newSpaceName.isEmpty else {
            print("ContentView: Space name cannot be empty")
            return
        }

        guard newSpaceName.count <= 100 else {
            print("ContentView: Space name too long (max 100 characters)")
            return
        }

        // Validate space name doesn't contain invalid characters
        let invalidCharacters = CharacterSet(charactersIn: "/<>:\"|?*")
        guard newSpaceName.rangeOfCharacter(from: invalidCharacters) == nil else {
            print("ContentView: Space name contains invalid characters")
            return
        }

        // Validate space location
        guard !newSpaceLocation.isEmpty else {
            print("ContentView: Space location cannot be empty")
            return
        }

        // Validate the path exists and is accessible
        let spaceURL = URL(fileURLWithPath: newSpaceLocation)
        guard FileManager.default.fileExists(atPath: spaceURL.path) else {
            print("ContentView: Space location does not exist: \(newSpaceLocation)")
            return
        }

        guard FileManager.default.isReadableFile(atPath: spaceURL.path) else {
            print("ContentView: Space location is not readable: \(newSpaceLocation)")
            return
        }

        // Check if it's a directory
        var isDirectory: ObjCBool = false
        guard FileManager.default.fileExists(atPath: spaceURL.path, isDirectory: &isDirectory),
            isDirectory.boolValue
        else {
            print("ContentView: Space location is not a directory: \(newSpaceLocation)")
            return
        }

        // Check if space with same name already exists
        guard !spaces.contains(where: { $0.name == newSpaceName }) else {
            print("ContentView: Space with name '\(newSpaceName)' already exists")
            return
        }

        // Check if space with same path already exists
        guard !spaces.contains(where: { $0.path.path == spaceURL.path }) else {
            print("ContentView: Space with path '\(spaceURL.path)' already exists")
            return
        }

        // Create the space using the file system with validated inputs
        if let newSpace = fileSystem.createSpace(name: newSpaceName, path: spaceURL) {
            spaces.append(newSpace)
            selectedSpace = newSpace
            print("ContentView: Successfully created space '\(newSpaceName)' at '\(spaceURL.path)'")
        } else {
            print("ContentView: Failed to create space '\(newSpaceName)' at '\(spaceURL.path)'")
        }

        // Reset form
        newSpaceName = ""
        newSpaceLocation = ""
        isCreatingNewSpace = false
    }

    private func deleteSpace(_ space: AugmentSpace) {
        // Delete the space using the file system
        if fileSystem.deleteSpace(space: space) {
            spaces.removeAll { $0.id == space.id }

            if selectedSpace?.id == space.id {
                selectedSpace = nil
            }
        }
    }

    private func checkForConflicts() {
        // Check for conflicts in all spaces
        activeConflicts = []

        for space in spaces {
            let spaceConflicts = conflictManager.getActiveConflicts(spacePath: space.path)
            activeConflicts.append(contentsOf: spaceConflicts)
        }
    }

    private func handleFileToOpen() {
        guard let filePath = fileToOpen else { return }

        // Create a file item for the file
        let url = URL(fileURLWithPath: filePath)

        // Get the file attributes
        guard let attributes = try? FileManager.default.attributesOfItem(atPath: filePath) else {
            return
        }

        // Get the modification date
        let modificationDate = attributes[.modificationDate] as? Date ?? Date()

        // Get the versions
        let versions = versionControl.getVersions(filePath: url)

        // Create a file item
        let fileItem = FileItem(
            id: UUID(),
            name: url.lastPathComponent,
            path: url.path,
            type: getFileType(url: url),
            modificationDate: modificationDate,
            versionCount: versions.count
        )

        // Set the selected file
        selectedFile = fileItem

        // Open the appropriate view
        if openVersionHistory {
            isShowingVersionHistory = true
        } else if openRestoreVersion {
            isShowingRestoreVersion = true
        }
    }

    private func getFileType(url: URL) -> FileType {
        return FileType.from(url: url)
    }

    private func openVersionHistoryForFile(_ filePath: String) {
        // Create a file item for the file
        let url = URL(fileURLWithPath: filePath)

        // Get the file attributes
        guard let attributes = try? FileManager.default.attributesOfItem(atPath: filePath) else {
            return
        }

        // Get the modification date
        let modificationDate = attributes[.modificationDate] as? Date ?? Date()

        // Get the versions
        let versions = versionControl.getVersions(filePath: url)

        // Create a file item
        let fileItem = FileItem(
            id: UUID(),
            name: url.lastPathComponent,
            path: url.path,
            type: getFileType(url: url),
            modificationDate: modificationDate,
            versionCount: versions.count
        )

        // Set the selected file and show version history
        selectedFile = fileItem
        isShowingVersionHistory = true
    }
}

struct NewSpaceView: View {
    @Binding var isPresented: Bool
    @Binding var spaceName: String
    @Binding var spaceLocation: String
    var onCreateSpace: () -> Void

    @State private var isSelectingLocation = false

    var body: some View {
        VStack(spacing: 20) {
            Text("Create New Augment Space")
                .font(.headline)

            Form {
                TextField("Space Name", text: $spaceName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                HStack {
                    TextField("Location", text: $spaceLocation)
                        .textFieldStyle(RoundedBorderTextFieldStyle())

                    Button("Browse...") {
                        isSelectingLocation = true
                    }
                }

                HStack {
                    Spacer()

                    Button("Cancel") {
                        isPresented = false
                    }
                    .keyboardShortcut(.escape)

                    Button("Create") {
                        onCreateSpace()
                    }
                    .keyboardShortcut(.return)
                    .disabled(spaceName.isEmpty || spaceLocation.isEmpty)
                }
            }
            .padding()
        }
        .frame(width: 400, height: 200)
        .fileImporter(
            isPresented: $isSelectingLocation,
            allowedContentTypes: [.folder],
            allowsMultipleSelection: false
        ) { result in
            if case .success(let urls) = result, let url = urls.first {
                // Start accessing security-scoped resource
                if url.startAccessingSecurityScopedResource() {
                    spaceLocation = url.path

                    // Store bookmark for persistent access
                    do {
                        let bookmarkData = try url.bookmarkData(
                            options: .withSecurityScope,
                            includingResourceValuesForKeys: nil,
                            relativeTo: nil
                        )
                        UserDefaults.standard.set(
                            bookmarkData, forKey: "folder_bookmark_\(url.path)")
                    } catch {
                        print("Failed to create bookmark: \(error)")
                    }
                } else {
                    print("Failed to access security-scoped resource")
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
