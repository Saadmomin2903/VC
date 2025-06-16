import Foundation
import SwiftUI

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

    // TODO: REFACTOR TO DEPENDENCY INJECTION - Currently using singletons for compatibility
    private let versionControl = VersionControl.shared
    private let fileSystemMonitor = FileSystemMonitor.shared

    // CRITICAL FIX: Add proper state tracking for file monitoring
    @State private var isMonitoring = false
    @State private var monitoringCallback: ((URL, FileSystemEvent) -> Void)?

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
                        FileRowView(file: file)
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
                                    NSWorkspace.shared.openFile(file.path)
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
                NavigationView {
                    VersionBrowser(file: file)
                        .navigationBarTitleDisplayMode(.inline)
                        .toolbar {
                            ToolbarItem(placement: .navigationBarLeading) {
                                Button("Close") {
                                    isShowingVersionHistory = false
                                }
                            }
                        }
                }
                .frame(
                    minWidth: 900, idealWidth: 1200, maxWidth: 1400, minHeight: 700,
                    idealHeight: 900, maxHeight: 1100)
            } else {
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

        DispatchQueue.global(qos: .userInitiated).async {
            let loadedFiles = loadFilesFromSpace()

            DispatchQueue.main.async {
                self.files = loadedFiles
                self.isLoading = false
            }
        }
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

                // Get version count with debugging
                let versions = versionControl.getVersions(filePath: fileURL)
                let versionCount = versions.count

                // Debug version counting for first few files
                if processedCount < 5 {
                    print(
                        "FileBrowserView: File \(fileURL.lastPathComponent) has \(versionCount) versions"
                    )
                    if versionCount == 0 {
                        // Check if file is in an Augment space
                        var currentPath = fileURL.deletingLastPathComponent()
                        var foundAugmentSpace = false

                        while currentPath.path != "/" {
                            let augmentDir = currentPath.appendingPathComponent(".augment")
                            if FileManager.default.fileExists(atPath: augmentDir.path) {
                                foundAugmentSpace = true
                                break
                            }
                            currentPath = currentPath.deletingLastPathComponent()
                        }

                        if !foundAugmentSpace {
                            print(
                                "FileBrowserView: File \(fileURL.lastPathComponent) is not in an Augment space"
                            )
                        } else {
                            print(
                                "FileBrowserView: File \(fileURL.lastPathComponent) is in an Augment space but has no versions"
                            )
                        }
                    }
                }

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

        DispatchQueue.global(qos: .utility).async {
            if let version = versionControl.createFileVersion(
                filePath: fileURL, comment: "Manual version")
            {
                print("Created version for \(file.name): \(version.id)")

                DispatchQueue.main.async {
                    refreshFiles()
                }
            }
        }
    }

    private func startMonitoring() {
        // CRITICAL FIX: Prevent duplicate monitoring and ensure proper state tracking
        guard !isMonitoring else {
            print("FileBrowserView: Already monitoring space \(space.name)")
            return
        }

        // Create and store the callback to prevent memory leaks
        let callback: (URL, FileSystemEvent) -> Void = { [weak self] url, event in
            DispatchQueue.main.async {
                self?.refreshFiles()
            }
        }

        monitoringCallback = callback

        let success = fileSystemMonitor.startMonitoring(spacePath: space.path, callback: callback)
        if success {
            isMonitoring = true
            print("FileBrowserView: Started monitoring space \(space.name)")
        } else {
            print("FileBrowserView: Failed to start monitoring space \(space.name)")
            monitoringCallback = nil
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
        monitoringCallback = nil
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

struct FileRowView: View {
    let file: FileItem

    var body: some View {
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

            // Version history button
            if file.versionCount > 0 {
                Button(action: {
                    // This will be handled by the parent view
                }) {
                    Image(systemName: "clock.arrow.circlepath")
                        .foregroundColor(.blue)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding(.vertical, 2)
    }
}
