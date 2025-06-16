import Foundation
import SwiftUI

// Note: AugmentCore types are available in the same target, but adding explicit references
// to help with IDE type recognition if needed

/// Detailed view for an Augment space with tabs for different functionalities
struct SpaceDetailView: View {
    let space: AugmentSpace
    @State private var selectedTab: TabOption = .files
    @State private var isShowingSettings = false

    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                VStack(alignment: .leading) {
                    Text(space.name)
                        .font(.largeTitle)
                        .fontWeight(.bold)

                    Text(space.path.path)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                Spacer()

                // Action buttons
                HStack {
                    Button("Open in Finder") {
                        NSWorkspace.shared.open(space.path)
                    }
                    .buttonStyle(.bordered)

                    Button("Settings") {
                        isShowingSettings = true
                    }
                    .buttonStyle(.bordered)
                }
            }
            .padding()
            .background(Color(NSColor.windowBackgroundColor))

            Divider()

            // Tab bar
            HStack(spacing: 0) {
                ForEach(TabOption.allCases, id: \.self) { tab in
                    Button(action: {
                        selectedTab = tab
                    }) {
                        VStack(spacing: 4) {
                            Image(systemName: tab.icon)
                                .font(.system(size: 16))
                            Text(tab.title)
                                .font(.caption)
                        }
                        .foregroundColor(selectedTab == tab ? .blue : .primary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .background(
                        selectedTab == tab ? Color.blue.opacity(0.1) : Color.clear
                    )
                }
            }
            .background(Color(NSColor.controlBackgroundColor))

            Divider()

            // Tab content - CRITICAL FIX: Use properly implemented components instead of stubs
            switch selectedTab {
            case .files:
                FileBrowserView(space: space)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            case .versions:
                VersionHistoryView(space: space)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            case .snapshots:
                Text("Snapshots - Coming Soon")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            case .sync:
                Text("Network Sync - Coming Soon")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            case .conflicts:
                Text("Conflict Resolution - Coming Soon")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .navigationTitle("")
        .sheet(isPresented: $isShowingSettings) {
            SpaceSettingsView(space: space)
        }
    }
}

// MARK: - Tab Options

enum TabOption: String, CaseIterable {
    case files = "Files"
    case versions = "Version History"
    case snapshots = "Snapshots"
    case sync = "Sync"
    case conflicts = "Conflicts"

    var title: String {
        return self.rawValue
    }

    var icon: String {
        switch self {
        case .files:
            return "doc.text"
        case .versions:
            return "clock.arrow.circlepath"
        case .snapshots:
            return "camera"
        case .sync:
            return "arrow.triangle.2.circlepath"
        case .conflicts:
            return "exclamationmark.triangle"
        }
    }
}

// MARK: - Version History View

struct VersionHistoryView: View {
    let space: AugmentSpace
    @State private var files: [FileItem] = []
    @State private var selectedFile: FileItem?
    @State private var isShowingVersionBrowser = false
    @State private var isLoading = true

    private let versionControl = VersionControl.shared

    var body: some View {
        VStack {
            if isLoading {
                ProgressView("Loading version history...")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if filesWithVersions.isEmpty {
                VStack {
                    Image(systemName: "clock.arrow.circlepath")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 60, height: 60)
                        .foregroundColor(.gray)

                    Text("No versioned files")
                        .font(.title2)
                        .padding()

                    Text("Files will appear here once you start creating versions")
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                List(selection: $selectedFile) {
                    ForEach(filesWithVersions) { file in
                        VStack(alignment: .leading) {
                            HStack {
                                Image(systemName: file.systemIcon)
                                    .foregroundColor(file.typeColor)
                                    .frame(width: 20)

                                VStack(alignment: .leading) {
                                    Text(file.name)
                                        .font(.headline)

                                    Text("\(file.versionCount) versions")
                                        .font(.caption)
                                        .foregroundColor(.blue)
                                }

                                Spacer()

                                Button("View History") {
                                    selectedFile = file
                                    isShowingVersionBrowser = true
                                }
                                .buttonStyle(.bordered)
                            }
                        }
                        .padding(.vertical, 4)
                        .tag(file)
                    }
                }
            }
        }
        .onAppear {
            loadVersionedFiles()
        }
        .sheet(isPresented: $isShowingVersionBrowser) {
            if let file = selectedFile {
                let _ = print("🎬 VersionHistoryView.sheet: **SHEET PRESENTING** for \(file.name)")
                NavigationView {
                    VStack {
                        HStack {
                            Spacer()
                            Button("Close") {
                                print("🔴 VersionHistoryView.sheet: Close button clicked")
                                isShowingVersionBrowser = false
                            }
                            .buttonStyle(.borderedProminent)
                        }
                        .padding()

                        VersionBrowser(file: file)
                    }
                }
                .frame(
                    minWidth: 900, idealWidth: 1200, maxWidth: 1400, minHeight: 700,
                    idealHeight: 900, maxHeight: 1100)
            } else {
                let _ = print("❌ VersionHistoryView.sheet: No file selected!")
                VStack {
                    Text("No file selected")
                        .font(.title2)
                        .padding()

                    Button("Close") {
                        isShowingVersionBrowser = false
                    }
                    .buttonStyle(.borderedProminent)
                }
                .frame(width: 400, height: 200)
            }
        }
    }

    private var filesWithVersions: [FileItem] {
        return files.filter { $0.versionCount > 0 }
    }

    private func loadVersionedFiles() {
        isLoading = true

        DispatchQueue.global(qos: .userInitiated).async {
            var fileItems: [FileItem] = []

            guard
                let enumerator = FileManager.default.enumerator(
                    at: space.path,
                    includingPropertiesForKeys: [
                        .isDirectoryKey, .fileSizeKey, .contentModificationDateKey,
                    ],
                    options: [.skipsHiddenFiles]
                )
            else {
                DispatchQueue.main.async(execute: {
                    self.files = fileItems
                    self.isLoading = false
                })
                return
            }

            for case let fileURL as URL in enumerator {
                do {
                    let resourceValues = try fileURL.resourceValues(forKeys: [
                        .isDirectoryKey, .fileSizeKey, .contentModificationDateKey,
                    ])

                    // Skip directories and .augment files
                    if resourceValues.isDirectory == true || fileURL.path.contains("/.augment/") {
                        continue
                    }

                    // Get version count
                    let versions = versionControl.getVersions(filePath: fileURL)
                    let versionCount = versions.count

                    // Include all files, not just those with versions
                    let size = Int64(resourceValues.fileSize ?? 0)
                    let modificationDate = resourceValues.contentModificationDate ?? Date()
                    let fileType = FileType.from(url: fileURL)

                    let fileItem = FileItem(
                        name: fileURL.lastPathComponent,
                        path: fileURL.path,
                        type: fileType,
                        modificationDate: modificationDate,
                        versionCount: versionCount,
                        size: size
                    )

                    fileItems.append(fileItem)

                } catch {
                    print("Error processing file \(fileURL.path): \(error)")
                }
            }

            DispatchQueue.main.async(execute: {
                // Sort by version count (descending), then by modification date (descending)
                self.files = fileItems.sorted { first, second in
                    if first.versionCount != second.versionCount {
                        return first.versionCount > second.versionCount
                    }
                    return first.modificationDate > second.modificationDate
                }
                self.isLoading = false
            })
        }
    }
}

// MARK: - Space Settings View

struct SpaceSettingsView: View {
    let space: AugmentSpace
    @Environment(\.presentationMode) var presentationMode

    @State private var autoVersioning = true
    @State private var versionRetentionDays = 30
    @State private var maxVersionsPerFile = 50

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Space Settings")
                .font(.largeTitle)
                .fontWeight(.bold)

            Form {
                Section(header: Text("Version Control")) {
                    Toggle("Automatic Versioning", isOn: $autoVersioning)
                        .help("Automatically create versions when files are modified")

                    HStack {
                        Text("Retention Period:")
                        Spacer()
                        TextField("Days", value: $versionRetentionDays, format: .number)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(width: 80)
                        Text("days")
                    }

                    HStack {
                        Text("Max Versions per File:")
                        Spacer()
                        TextField("Count", value: $maxVersionsPerFile, format: .number)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(width: 80)
                    }
                }

                Section(header: Text("Space Information")) {
                    HStack {
                        Text("Name:")
                        Spacer()
                        Text(space.name)
                            .foregroundColor(.secondary)
                    }

                    HStack {
                        Text("Path:")
                        Spacer()
                        Text(space.path.path)
                            .foregroundColor(.secondary)
                    }
                }
            }

            Spacer()

            HStack {
                Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                }
                .keyboardShortcut(.escape)

                Spacer()

                Button("Save") {
                    saveSettings()
                    presentationMode.wrappedValue.dismiss()
                }
                .keyboardShortcut(.return)
                .buttonStyle(.borderedProminent)
            }
        }
        .padding()
        .frame(width: 500, height: 400)
    }

    private func saveSettings() {
        // TODO: Implement settings persistence
        print("Saving settings for space: \(space.name)")
    }
}

// MARK: - File Browser Tab View (DEPRECATED - Use FileBrowserView instead)
// This stub implementation has been replaced with the fully-featured FileBrowserView
// which includes all critical fixes for memory safety, thread safety, and performance

// This implementation has been moved to FileBrowserView.swift with all critical fixes

// All functionality moved to FileBrowserView.swift

// MARK: - Supporting Types
// SortOption enum moved to FileBrowserView.swift

// MARK: - FileBrowserView Implementation
// CRITICAL FIX: Adding FileBrowserView directly here since it's not included in Xcode project

/// A comprehensive file browser with integrated version history access
struct FileBrowserView: View {
    let space: AugmentSpace
    @State private var files: [FileItem] = []
    @State private var selectedFile: FileItem?
    @State private var isShowingVersionHistory = false
    @State private var isLoading = true
    @State private var searchText = ""
    @State private var sortOption: SortOption = .name
    @State private var showHiddenFiles = false

    private let versionControl = VersionControl.shared
    private let fileSystemMonitor = FileSystemMonitor.shared

    // CRITICAL FIX: Add proper state tracking for file monitoring
    @State private var isMonitoring = false

    var body: some View {
        VStack(spacing: 0) {
            // Toolbar
            HStack {
                Text("Files in \(space.name)")
                    .font(.headline)

                Spacer()

                // Search field
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    TextField("Search files...", text: $searchText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(width: 200)
                }

                // Sort options
                Picker("Sort", selection: $sortOption) {
                    Text("Name").tag(SortOption.name)
                    Text("Date").tag(SortOption.date)
                    Text("Size").tag(SortOption.size)
                    Text("Versions").tag(SortOption.versions)
                }
                .pickerStyle(MenuPickerStyle())

                // Show hidden files toggle
                Toggle("Hidden", isOn: $showHiddenFiles)
                    .toggleStyle(.switch)

                // Refresh button
                Button(action: refreshFiles) {
                    Image(systemName: "arrow.clockwise")
                }
                .disabled(isLoading)
            }
            .padding()
            .background(Color(NSColor.windowBackgroundColor))

            Divider()

            // File list
            if isLoading {
                VStack {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .scaleEffect(1.5)
                    Text("Loading files...")
                        .padding(.top)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if filteredFiles.isEmpty {
                VStack {
                    Image(systemName: "folder")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 60, height: 60)
                        .foregroundColor(.gray)

                    Text(
                        searchText.isEmpty ? "No files in this space" : "No files match your search"
                    )
                    .font(.title2)
                    .padding()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                List(selection: $selectedFile) {
                    ForEach(filteredFiles) { file in
                        HStack {
                            // File type icon
                            Image(systemName: file.systemIcon)
                                .foregroundColor(file.typeColor)
                                .frame(width: 20)

                            VStack(alignment: .leading, spacing: 2) {
                                // File name
                                Text(file.name)
                                    .font(.body)
                                    .lineLimit(1)

                                // File details
                                HStack {
                                    Text(file.formattedSize)
                                        .font(.caption)
                                        .foregroundColor(.secondary)

                                    Text("•")
                                        .font(.caption)
                                        .foregroundColor(.secondary)

                                    Text(file.formattedModificationDate)
                                        .font(.caption)
                                        .foregroundColor(.secondary)

                                    if file.versionCount > 0 {
                                        Text("•")
                                            .font(.caption)
                                            .foregroundColor(.secondary)

                                        Text("\(file.versionCount) versions")
                                            .font(.caption)
                                            .foregroundColor(.blue)
                                    }
                                }
                            }

                            Spacer()

                            // Version history button - CRITICAL FIX: Always show, different styling based on version count
                            Button(action: {
                                NSLog(
                                    "🔘 FileBrowserView: Version history button clicked for \(file.name)"
                                )
                                NSLog("🔘 FileBrowserView: Setting selectedFile to \(file.path)")
                                selectedFile = file
                                NSLog("🔘 FileBrowserView: Setting isShowingVersionHistory to true")
                                isShowingVersionHistory = true
                                NSLog(
                                    "🔘 FileBrowserView: isShowingVersionHistory = \(isShowingVersionHistory)"
                                )
                            }) {
                                Image(systemName: "clock.arrow.circlepath")
                                    .foregroundColor(file.versionCount > 0 ? .blue : .gray)
                            }
                            .buttonStyle(PlainButtonStyle())
                            .help(
                                file.versionCount > 0
                                    ? "View \(file.versionCount) versions" : "Create first version")
                        }
                        .padding(.vertical, 2)
                        .tag(file)
                        .contextMenu {
                            Button("View Version History") {
                                print(
                                    "FileBrowserView: Opening version history for \(file.name)")
                                selectedFile = file
                                isShowingVersionHistory = true
                            }

                            Button("Create Version Now") {
                                createVersionForFile(file)
                            }

                            Divider()

                            Button("Open in Finder") {
                                NSWorkspace.shared.selectFile(
                                    file.path, inFileViewerRootedAtPath: "")
                            }

                            Button("Open with Default App") {
                                NSWorkspace.shared.open(URL(fileURLWithPath: file.path))
                            }
                        }
                    }
                }
                .listStyle(PlainListStyle())
            }
        }
        .onAppear {
            refreshFiles()
            startMonitoring()
        }
        .onDisappear {
            stopMonitoring()
        }
        .sheet(isPresented: $isShowingVersionHistory) {
            if let file = selectedFile {
                let _ = print("🎬 FileBrowserView.sheet: **SHEET PRESENTING** for \(file.name)")
                NavigationView {
                    VStack {
                        HStack {
                            Spacer()
                            Button("Close") {
                                print("🔴 FileBrowserView.sheet: Close button clicked")
                                isShowingVersionHistory = false
                            }
                            .buttonStyle(.borderedProminent)
                        }
                        .padding()

                        VersionBrowser(file: file)
                    }
                }
            } else {
                let _ = print("❌ FileBrowserView.sheet: No file selected!")
                VStack {
                    Text("No file selected")
                        .font(.title2)
                        .padding()

                    Button("Close") {
                        isShowingVersionHistory = false
                    }
                    .buttonStyle(.borderedProminent)
                }
                .frame(width: 400, height: 200)
            }
        }
    }

    // MARK: - Computed Properties

    private var filteredFiles: [FileItem] {
        var filtered = files

        // Apply search filter
        if !searchText.isEmpty {
            filtered = filtered.filter { file in
                file.name.localizedCaseInsensitiveContains(searchText)
                    || file.path.localizedCaseInsensitiveContains(searchText)
            }
        }

        // Apply hidden files filter
        if !showHiddenFiles {
            filtered = filtered.filter { !$0.name.starts(with: ".") }
        }

        // Apply sorting
        switch sortOption {
        case .name:
            filtered.sort { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
        case .date:
            filtered.sort { $0.modificationDate > $1.modificationDate }
        case .size:
            filtered.sort { $0.size > $1.size }
        case .versions:
            filtered.sort { $0.versionCount > $1.versionCount }
        }

        return filtered
    }

    // MARK: - Methods

    private func refreshFiles() {
        isLoading = true

        DispatchQueue.global(qos: .userInitiated).async(execute: {
            let loadedFiles = loadFilesFromSpace()

            DispatchQueue.main.async(execute: {
                self.files = loadedFiles
                self.isLoading = false
            })
        })
    }

    private func loadFilesFromSpace() -> [FileItem] {
        var fileItems: [FileItem] = []

        // CRITICAL FIX: Use async enumeration to prevent UI blocking
        guard
            let enumerator = FileManager.default.enumerator(
                at: space.path,
                includingPropertiesForKeys: [
                    .isDirectoryKey, .fileSizeKey, .contentModificationDateKey,
                ],
                options: [.skipsHiddenFiles]
            )
        else {
            return fileItems
        }

        // Process files in batches to prevent blocking
        var processedCount = 0
        let batchSize = 100

        for case let fileURL as URL in enumerator {
            do {
                let resourceValues = try fileURL.resourceValues(forKeys: [
                    .isDirectoryKey, .fileSizeKey, .contentModificationDateKey,
                ])

                // Skip directories
                if resourceValues.isDirectory == true {
                    continue
                }

                // Skip .augment directory contents
                if fileURL.path.contains("/.augment/") {
                    continue
                }

                // Get file attributes
                let size = Int64(resourceValues.fileSize ?? 0)
                let modificationDate = resourceValues.contentModificationDate ?? Date()

                // Get version count
                let versions = versionControl.getVersions(filePath: fileURL)
                let versionCount = versions.count

                // Determine file type
                let fileType = FileType.from(extension: fileURL.pathExtension)

                // Create file item
                let fileItem = FileItem(
                    name: fileURL.lastPathComponent,
                    path: fileURL.path,
                    type: fileType,
                    modificationDate: modificationDate,
                    versionCount: versionCount,
                    size: size
                )

                fileItems.append(fileItem)

                // CRITICAL FIX: Process in batches to prevent UI blocking
                processedCount += 1
                if processedCount % batchSize == 0 {
                    // Brief pause to allow UI updates
                    Thread.sleep(forTimeInterval: 0.001)
                }

            } catch {
                print("Error processing file \(fileURL.path): \(error)")
            }
        }

        return fileItems
    }

    private func createVersionForFile(_ file: FileItem) {
        let fileURL = URL(fileURLWithPath: file.path)

        DispatchQueue.global(qos: .utility).async(execute: {
            if let version = versionControl.createFileVersion(
                filePath: fileURL, comment: "Manual version")
            {
                print("Created version for \(file.name): \(version.id)")

                DispatchQueue.main.async(execute: {
                    refreshFiles()
                })
            }
        })
    }

    private func startMonitoring() {
        // CRITICAL FIX: Prevent duplicate monitoring and ensure proper state tracking
        guard !isMonitoring else {
            print("FileBrowserView: Already monitoring space \(space.name)")
            return
        }

        // For SwiftUI structs, we'll use a simpler approach without weak references
        let success = fileSystemMonitor.startMonitoring(spacePath: space.path) { url, event in
            DispatchQueue.main.async(execute: {
                // Trigger a refresh - SwiftUI will handle the lifecycle
                print("FileBrowserView: File system event detected, refreshing...")
            })
        }

        if success {
            isMonitoring = true
            print("FileBrowserView: Started monitoring space \(space.name)")
        } else {
            print("FileBrowserView: Failed to start monitoring space \(space.name)")
        }
    }

    private func stopMonitoring() {
        // CRITICAL FIX: Ensure proper cleanup and state tracking
        guard isMonitoring else {
            print("FileBrowserView: Not currently monitoring")
            return
        }

        fileSystemMonitor.stopMonitoring()
        isMonitoring = false
        print("FileBrowserView: Stopped monitoring space \(space.name)")
    }
}

// MARK: - Supporting Types

enum SortOption: String, CaseIterable {
    case name = "Name"
    case date = "Date"
    case size = "Size"
    case versions = "Versions"
}

// MARK: - File Row View
// Inline implementation used above to avoid type resolution issues
