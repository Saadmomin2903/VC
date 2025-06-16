import SwiftUI

struct VersionBrowser: View {
    let file: FileItem
    @State private var versions: [FileVersion] = []
    @State private var selectedVersion: FileVersion?
    @State private var compareMode = false
    @State private var compareVersion: FileVersion?
    @State private var isRestoring = false
    @State private var restoreComment = ""

    // SIMPLIFIED VERSION: Always use real data
    @State private var useHardcodedData = false

    private let versionControl = VersionControl.shared
    private let previewEngine = PreviewEngine.shared
    private let diffEngine = DiffEngine.shared

    var body: some View {
        let _ = NSLog("🎨 VersionBrowser.body: **RENDERING** versions.count = \(versions.count)")
        let _ = NSLog("🎨 VersionBrowser.body: versions.isEmpty = \(versions.isEmpty)")

        VStack(spacing: 0) {
            // Toolbar
            HStack {
                Text("Version History: \(file.name)")
                    .font(.headline)

                Spacer()

                Toggle("Compare", isOn: $compareMode)
                    .toggleStyle(.switch)
                    .disabled(versions.count < 2)

                Button(action: {
                    // Refresh versions
                    loadVersions()
                }) {
                    Image(systemName: "arrow.clockwise")
                }

                if compareMode && selectedVersion != nil && compareVersion != nil {
                    Button("Compare") {
                        // Show diff view
                        // TODO: Implement diff view
                    }
                    .buttonStyle(.borderedProminent)
                } else if selectedVersion != nil {
                    Button("Restore") {
                        isRestoring = true
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
            .padding()
            .background(Color(NSColor.windowBackgroundColor))

            Divider()

            // Content
            HStack(spacing: 0) {
                // Version list
                if versions.isEmpty {
                    // ENHANCED DEBUG: Log empty state
                    let _ = NSLog(
                        "🔍 VersionBrowser.UI: Displaying EMPTY state - versions.count = \(versions.count)"
                    )

                    // Empty state
                    VStack(spacing: 16) {
                        Image(systemName: "clock.arrow.circlepath")
                            .font(.system(size: 48))
                            .foregroundColor(.gray)

                        Text("No Version History")
                            .font(.title2)
                            .fontWeight(.medium)

                        Text("This file doesn't have any versions yet.")
                            .font(.body)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)

                        VStack(alignment: .leading, spacing: 8) {
                            Text("To create versions:")
                                .font(.headline)
                                .foregroundColor(.primary)

                            Text("• Right-click the file and select 'Create Version Now'")
                                .font(.body)
                                .foregroundColor(.secondary)

                            Text("• Versions are automatically created when files are modified")
                                .font(.body)
                                .foregroundColor(.secondary)

                            Text("• Make sure the file is in an Augment space")
                                .font(.body)
                                .foregroundColor(.secondary)
                        }
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)

                        Button("Create Version Now") {
                            createVersionNow()
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .frame(width: 300)
                    .padding()
                } else {
                    // ENHANCED DEBUG: Log versions display
                    let _ = NSLog(
                        "🎉 VersionBrowser.UI: Displaying VERSIONS - versions.count = \(versions.count)"
                    )
                    let _ = NSLog(
                        "📋 VersionBrowser.UI: Version IDs: \(versions.map { $0.id.uuidString.prefix(8) })"
                    )

                    // COMPLETELY REWRITTEN VERSION LIST WITH EXPLICIT SIZING
                    VStack(spacing: 0) {
                        let _ = NSLog(
                            "🎨 VersionBrowser.VStack: **RENDERING VSTACK** with \(versions.count) versions"
                        )

                        // Header - Classic Mac Style
                        HStack {
                            Text("Versions (\(versions.count))")
                                .font(.headline)
                                .fontWeight(.medium)
                                .foregroundColor(.primary)
                            Spacer()
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(Color(NSColor.controlBackgroundColor))

                        Divider()

                        // Version List with ScrollView instead of List
                        ScrollView {
                            LazyVStack(spacing: 1) {
                                let _ = NSLog(
                                    "🎨 VersionBrowser.LazyVStack: **RENDERING LAZYVSTACK** with \(versions.count) items"
                                )
                                ForEach(versions) { version in
                                    let _ = NSLog(
                                        "🎨 VersionBrowser.ForEach: **CREATING ROW** for version \(version.id.uuidString.prefix(8))"
                                    )

                                    // SIMPLIFIED VERSION ROW WITH EXPLICIT SIZING
                                    VStack(alignment: .leading, spacing: 4) {
                                        let _ = NSLog(
                                            "🎨 VersionBrowser.SimpleRow: **RENDERING SIMPLE ROW** for \(version.id.uuidString.prefix(8))"
                                        )

                                        HStack {
                                            VStack(alignment: .leading, spacing: 4) {
                                                Text(formatDate(version.timestamp))
                                                    .font(.headline)
                                                    .foregroundColor(.primary)

                                                if let comment = version.comment, !comment.isEmpty {
                                                    Text(comment)
                                                        .font(.subheadline)
                                                        .foregroundColor(.secondary)
                                                        .lineLimit(2)
                                                } else {
                                                    Text("No comment")
                                                        .font(.subheadline)
                                                        .foregroundColor(.secondary)
                                                        .italic()
                                                }

                                                Text(formatSize(version.size))
                                                    .font(.caption)
                                                    .foregroundColor(.secondary)
                                            }

                                            Spacer()

                                            if selectedVersion?.id == version.id {
                                                Image(systemName: "checkmark.circle.fill")
                                                    .foregroundColor(.accentColor)
                                                    .font(.title3)
                                            }
                                        }
                                    }
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 10)
                                    .frame(minHeight: 70)
                                    .background(
                                        selectedVersion?.id == version.id
                                            ? Color.accentColor.opacity(0.1)
                                            : Color.clear
                                    )
                                    .overlay(
                                        Rectangle()
                                            .frame(height: 0.5)
                                            .foregroundColor(Color(NSColor.separatorColor)),
                                        alignment: .bottom
                                    )
                                    .onTapGesture {
                                        selectedVersion = version
                                        NSLog(
                                            "🎯 VersionBrowser: Selected version \(version.id.uuidString.prefix(8))"
                                        )
                                    }
                                    .contextMenu {
                                        Button("Restore to This Version") {
                                            selectedVersion = version
                                            isRestoring = true
                                        }

                                        if compareMode {
                                            Button("Compare From This Version") {
                                                compareVersion = version
                                            }

                                            Button("Compare To This Version") {
                                                selectedVersion = version
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        .frame(maxHeight: .infinity)
                    }
                    .frame(
                        minWidth: 600, idealWidth: 800, maxWidth: 1000, minHeight: 600,
                        idealHeight: 800, maxHeight: 1000
                    )
                    .background(Color(NSColor.controlBackgroundColor))
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color(NSColor.separatorColor), lineWidth: 1)
                    )
                }

                Divider()

                // Preview
                if compareMode && selectedVersion != nil && compareVersion != nil {
                    // Diff view
                    DiffView(fromVersion: compareVersion!, toVersion: selectedVersion!)
                } else if let version = selectedVersion {
                    // Version preview
                    VersionPreview(version: version)
                } else {
                    // No selection
                    VStack {
                        Image(systemName: "clock.arrow.circlepath")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 60, height: 60)
                            .foregroundColor(.gray)

                        Text("Select a version to preview")
                            .font(.title2)
                            .padding()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
        }
        .frame(width: 800, height: 600)
        .onAppear {
            NSLog("🎬 VersionBrowser.onAppear: **VIEW APPEARING** for file \(file.name)")
            NSLog("🎬 VersionBrowser.onAppear: File path: \(file.path)")
            NSLog("🎬 VersionBrowser.onAppear: Current versions.count: \(versions.count)")
            NSLog("🎬 VersionBrowser.onAppear: About to call loadVersions()...")
            loadVersions()
            NSLog(
                "🎬 VersionBrowser.onAppear: loadVersions() completed, versions.count: \(versions.count)"
            )
        }
        .sheet(isPresented: $isRestoring) {
            RestoreVersionView(
                version: selectedVersion!,
                comment: $restoreComment,
                onRestore: restoreVersion,
                onCancel: { isRestoring = false }
            )
        }
    }

    private func loadVersions() {
        NSLog("🚀 VersionBrowser.loadVersions: STARTING for \(file.path)")
        NSLog("🔧 VersionBrowser.loadVersions: **SIMPLIFIED MODE - Real data only**")

        // Check if file exists
        let fileURL = URL(fileURLWithPath: file.path)
        guard FileManager.default.fileExists(atPath: file.path) else {
            print("❌ VersionBrowser.loadVersions: ERROR - File does not exist: \(file.path)")
            versions = []
            return
        }
        print("✅ VersionBrowser.loadVersions: File exists")

        // Check if file is in an Augment space (has .augment directory)
        var currentPath = fileURL.deletingLastPathComponent()
        var foundAugmentSpace = false
        var spacePath: URL?

        print("🔍 VersionBrowser.loadVersions: Searching for .augment directory...")
        while currentPath.path != "/" {
            let augmentDir = currentPath.appendingPathComponent(".augment")
            print("   🔍 Checking: \(augmentDir.path)")
            if FileManager.default.fileExists(atPath: augmentDir.path) {
                foundAugmentSpace = true
                spacePath = currentPath
                print("   ✅ Found .augment directory!")
                break
            }
            currentPath = currentPath.deletingLastPathComponent()
        }

        if foundAugmentSpace {
            print(
                "✅ VersionBrowser.loadVersions: Found Augment space at: \(spacePath?.path ?? "unknown")"
            )
        } else {
            print(
                "❌ VersionBrowser.loadVersions: WARNING - File is not in an Augment space (no .augment directory found)"
            )
            print(
                "🔍 VersionBrowser.loadVersions: Searched from \(fileURL.deletingLastPathComponent().path) up to root"
            )

            // CRITICAL FIX: Initialize version control for the file's directory if not found
            let parentDir = fileURL.deletingLastPathComponent()
            print(
                "🔧 VersionBrowser.loadVersions: Attempting to initialize version control for: \(parentDir.path)"
            )
            if versionControl.initializeVersionControl(folderPath: parentDir) {
                print("✅ VersionBrowser.loadVersions: Successfully initialized version control")
                foundAugmentSpace = true
                spacePath = parentDir
            } else {
                print("❌ VersionBrowser.loadVersions: Failed to initialize version control")
            }
        }

        // Load versions from version control
        print("🔄 VersionBrowser.loadVersions: Calling versionControl.getVersions...")
        let loadedVersions = versionControl.getVersions(filePath: fileURL)
        print(
            "📊 VersionBrowser.loadVersions: Received \(loadedVersions.count) versions from VersionControl"
        )

        // CRITICAL FIX: Ensure UI updates happen on main thread - SINGLE UPDATE
        DispatchQueue.main.async {
            NSLog("🔄 VersionBrowser.loadVersions: **UPDATING UI STATE** on main thread")
            NSLog(
                "🔄 VersionBrowser.loadVersions: Processing \(loadedVersions.count) loaded versions"
            )
            // Process versions and update state ONCE
            var finalVersions: [FileVersion] = []

            if loadedVersions.isEmpty {
                print("⚠️ VersionBrowser.loadVersions: No versions found. Possible reasons:")
                print("  1. File is not in an Augment space (no .augment directory)")
                print("  2. No versions have been created for this file yet")
                print("  3. Version metadata may be corrupted or missing")

                if foundAugmentSpace, let space = spacePath {
                    // Check if metadata directory exists
                    let metadataDir = space.appendingPathComponent(".augment/file_metadata")
                    if FileManager.default.fileExists(atPath: metadataDir.path) {
                        print(
                            "✅ VersionBrowser.loadVersions: Metadata directory exists: \(metadataDir.path)"
                        )

                        // Check for file-specific metadata
                        do {
                            let contents = try FileManager.default.contentsOfDirectory(
                                at: metadataDir, includingPropertiesForKeys: nil)
                            print(
                                "📂 VersionBrowser.loadVersions: Metadata subdirectories: \(contents.map { $0.lastPathComponent })"
                            )
                        } catch {
                            print(
                                "❌ VersionBrowser.loadVersions: Error reading metadata directory: \(error)"
                            )
                        }
                    } else {
                        print(
                            "❌ VersionBrowser.loadVersions: Metadata directory does not exist: \(metadataDir.path)"
                        )
                    }

                    // CRITICAL FIX: Auto-create initial version if none exists
                    print("🔧 VersionBrowser.loadVersions: Auto-creating initial version for file")
                    if let initialVersion = self.versionControl.createFileVersion(
                        filePath: fileURL,
                        comment: "Initial version (auto-created)"
                    ) {
                        print(
                            "✅ VersionBrowser.loadVersions: Successfully created initial version: \(initialVersion.id)"
                        )
                        finalVersions = [initialVersion]
                        NSLog(
                            "🔄 VersionBrowser.loadVersions: **CREATED INITIAL VERSION** finalVersions.count = \(finalVersions.count)"
                        )
                    } else {
                        print("❌ VersionBrowser.loadVersions: Failed to create initial version")
                        finalVersions = []
                    }
                } else {
                    finalVersions = []
                }
            } else {
                print(
                    "✅ VersionBrowser.loadVersions: Successfully loaded \(loadedVersions.count) versions:"
                )
                for (index, version) in loadedVersions.enumerated() {
                    print(
                        "   \(index + 1). ID: \(version.id), Timestamp: \(version.timestamp), Comment: \(version.comment ?? "No comment")"
                    )
                }

                // Sort versions by timestamp (newest first)
                finalVersions = loadedVersions.sorted { $0.timestamp > $1.timestamp }
                print(
                    "🔄 VersionBrowser.loadVersions: Sorted \(finalVersions.count) versions by timestamp"
                )
                NSLog(
                    "🔄 VersionBrowser.loadVersions: **SORTED VERSIONS** finalVersions.count = \(finalVersions.count)"
                )
            }

            // SINGLE STATE UPDATE - This is the critical fix!
            NSLog(
                "🔄 VersionBrowser.loadVersions: **FINAL STATE UPDATE** from \(self.versions.count) to \(finalVersions.count)"
            )
            self.versions = finalVersions
            NSLog(
                "🔄 VersionBrowser.loadVersions: **STATE UPDATED** versions.count = \(self.versions.count)"
            )

            // Select the latest version
            self.selectedVersion = self.versions.first

            if let selected = self.selectedVersion {
                print("🎯 VersionBrowser.loadVersions: Selected version \(selected.id)")
            } else {
                print("🚫 VersionBrowser.loadVersions: No versions available for selection")
            }

            NSLog(
                "🏁 VersionBrowser.loadVersions: **COMPLETED** final versions.count = \(self.versions.count)"
            )
        }
    }

    private func restoreVersion() {
        guard let version = selectedVersion else { return }

        // Restore the version
        let success = versionControl.restoreVersion(
            filePath: URL(fileURLWithPath: file.path), version: version)

        if success {
            // Reload versions
            loadVersions()
        }

        // Close the restore sheet
        isRestoring = false
        restoreComment = ""
    }

    private func createVersionNow() {
        print("VersionBrowser: Creating version for \(file.path)")

        let fileURL = URL(fileURLWithPath: file.path)

        // Check if file exists
        guard FileManager.default.fileExists(atPath: file.path) else {
            print("VersionBrowser: Cannot create version - file does not exist: \(file.path)")
            return
        }

        // Create version with comment
        DispatchQueue.global(qos: .utility).async {
            if let newVersion = self.versionControl.createFileVersion(
                filePath: fileURL,
                comment: "Manual version created from version browser"
            ) {
                print("VersionBrowser: Successfully created version \(newVersion.id)")

                DispatchQueue.main.async {
                    // Reload versions to show the new one
                    self.loadVersions()
                }
            } else {
                print("VersionBrowser: Failed to create version for \(self.file.path)")

                DispatchQueue.main.async {
                    // Still reload to check if anything changed
                    self.loadVersions()
                }
            }
        }
    }

    // HELPER FUNCTIONS FOR SIMPLIFIED UI
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }

    private func formatSize(_ size: UInt64) -> String {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = [.useKB, .useMB, .useGB]
        formatter.countStyle = .file
        return formatter.string(fromByteCount: Int64(size))
    }
}

struct VersionRow: View {
    let version: FileVersion
    let isSelected: Bool

    var body: some View {
        let _ = NSLog(
            "🎨 VersionRow.body: **RENDERING ROW** for version \(version.id.uuidString.prefix(8))")
        let _ = NSLog("🎨 VersionRow.body: Date: \(formattedDate), Size: \(formattedSize)")

        HStack {
            VStack(alignment: .leading) {
                Text(formattedDate)
                    .font(.headline)

                if let comment = version.comment, !comment.isEmpty {
                    Text(comment)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }

                Text("\(formattedSize)")
                    .font(.caption)
                    .foregroundColor(.gray)
            }

            Spacer()

            if isSelected {
                Image(systemName: "checkmark")
                    .foregroundColor(.blue)
            }
        }
        .padding(.vertical, 4)
    }

    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: version.timestamp)
    }

    private var formattedSize: String {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = [.useKB, .useMB, .useGB]
        formatter.countStyle = .file
        return formatter.string(fromByteCount: Int64(version.size))
    }
}

struct VersionPreview: View {
    let version: FileVersion
    @State private var previewImage: NSImage?
    @State private var textContent: String?

    private let previewEngine = PreviewEngine.shared

    var body: some View {
        VStack {
            if let image = previewImage {
                Image(nsImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding()
            } else if let text = textContent {
                ScrollView {
                    Text(text)
                        .font(.system(.body, design: .monospaced))
                        .padding()
                }
            } else {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .scaleEffect(2.0)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear {
            loadPreview()
        }
    }

    private func loadPreview() {
        // Determine the file type
        let fileExtension = version.filePath.pathExtension.lowercased()

        // Load the file data
        guard let data = try? Data(contentsOf: version.storagePath) else { return }

        // Generate preview based on file type
        if [
            "txt", "md", "swift", "java", "c", "cpp", "h", "hpp", "py", "js", "html", "css", "xml",
            "json",
        ].contains(fileExtension) {
            // Text file
            if let content = String(data: data, encoding: .utf8) {
                textContent = content
            }
        } else {
            // Generate image preview
            previewImage = previewEngine.generatePreview(
                filePath: version.storagePath, size: CGSize(width: 800, height: 600))
        }
    }
}

struct DiffView: View {
    let fromVersion: FileVersion
    let toVersion: FileVersion
    @State private var diff: FileDiff?

    private let diffEngine = DiffEngine.shared

    var body: some View {
        VStack {
            if let diff = diff {
                switch diff.diffType {
                case .text:
                    TextDiffView(diff: diff)
                case .image:
                    ImageDiffView(diff: diff)
                case .binary:
                    BinaryDiffView(diff: diff)
                case .none:
                    Text("No differences")
                        .font(.title2)
                        .padding()
                }
            } else {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .scaleEffect(2.0)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear {
            loadDiff()
        }
    }

    private func loadDiff() {
        // Generate the diff
        diff = diffEngine.generateDiff(fromVersion: fromVersion, toVersion: toVersion)
    }
}

struct TextDiffView: View {
    let diff: FileDiff
    @State private var diffOperations: [DiffOperation] = []

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 2) {
                ForEach(diffOperations.indices, id: \.self) { index in
                    let operation = diffOperations[index]

                    HStack(spacing: 0) {
                        // Line number
                        Text("\(index + 1)")
                            .font(.system(.body, design: .monospaced))
                            .foregroundColor(.gray)
                            .frame(width: 40, alignment: .trailing)
                            .padding(.trailing, 8)

                        // Line content
                        Text(operation.content)
                            .font(.system(.body, design: .monospaced))
                            .padding(.vertical, 2)
                            .padding(.horizontal, 4)
                            .background(operation.backgroundColor)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
            }
            .padding()
        }
        .onAppear {
            loadDiffOperations()
        }
    }

    private func loadDiffOperations() {
        // Parse the diff data
        guard let operations = try? JSONDecoder().decode([DiffOperation].self, from: diff.diffData)
        else { return }
        diffOperations = operations
    }
}

struct ImageDiffView: View {
    let diff: FileDiff
    @State private var fromImage: NSImage?
    @State private var toImage: NSImage?
    @State private var showOverlay = false

    var body: some View {
        VStack {
            // Controls
            HStack {
                Spacer()

                Toggle("Show Overlay", isOn: $showOverlay)
                    .toggleStyle(.switch)
            }
            .padding()

            // Images
            if showOverlay {
                // Overlay view
                ZStack {
                    if let fromImage = fromImage {
                        Image(nsImage: fromImage)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .opacity(0.5)
                    }

                    if let toImage = toImage {
                        Image(nsImage: toImage)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .opacity(0.5)
                    }
                }
                .padding()
            } else {
                // Side-by-side view
                HStack {
                    VStack {
                        Text("Before")
                            .font(.headline)

                        if let fromImage = fromImage {
                            Image(nsImage: fromImage)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        }
                    }

                    VStack {
                        Text("After")
                            .font(.headline)

                        if let toImage = toImage {
                            Image(nsImage: toImage)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        }
                    }
                }
                .padding()
            }
        }
        .onAppear {
            loadImages()
        }
    }

    private func loadImages() {
        // Load the from image
        if let data = try? Data(contentsOf: diff.fromVersion.storagePath) {
            fromImage = NSImage(data: data)
        }

        // Load the to image
        if let data = try? Data(contentsOf: diff.toVersion.storagePath) {
            toImage = NSImage(data: data)
        }
    }
}

struct BinaryDiffView: View {
    let diff: FileDiff

    var body: some View {
        VStack {
            Image(systemName: "doc.text.magnifyingglass")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 60, height: 60)
                .foregroundColor(.gray)

            Text("Binary File Comparison")
                .font(.title2)
                .padding()

            Text(
                "The files are different, but a visual comparison is not available for this file type."
            )
            .foregroundColor(.gray)
            .multilineTextAlignment(.center)
            .padding()

            HStack {
                VStack(alignment: .leading) {
                    Text("Original Version")
                        .font(.headline)

                    Text("Date: \(formattedDate(diff.fromVersion.timestamp))")
                    Text("Size: \(formattedSize(diff.fromVersion.size))")
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)

                VStack(alignment: .leading) {
                    Text("New Version")
                        .font(.headline)

                    Text("Date: \(formattedDate(diff.toVersion.timestamp))")
                    Text("Size: \(formattedSize(diff.toVersion.size))")
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
            }
            .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }

    private func formattedSize(_ size: UInt64) -> String {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = [.useKB, .useMB, .useGB]
        formatter.countStyle = .file
        return formatter.string(fromByteCount: Int64(size))
    }
}

struct RestoreVersionView: View {
    let version: FileVersion
    @Binding var comment: String
    let onRestore: () -> Void
    let onCancel: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            Text("Restore Version")
                .font(.headline)

            Text("Are you sure you want to restore this version?")
                .foregroundColor(.gray)

            VStack(alignment: .leading) {
                Text("Version Date: \(formattedDate)")
                    .font(.subheadline)

                if let versionComment = version.comment, !versionComment.isEmpty {
                    Text("Version Comment: \(versionComment)")
                        .font(.subheadline)
                }
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(8)

            TextField("Comment (optional)", text: $comment)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            HStack {
                Button("Cancel") {
                    onCancel()
                }
                .keyboardShortcut(.escape)

                Spacer()

                Button("Restore") {
                    onRestore()
                }
                .keyboardShortcut(.return)
                .buttonStyle(.borderedProminent)
            }
        }
        .padding()
        .frame(width: 400)
    }

    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: version.timestamp)
    }
}

// MARK: - Helper Extensions

extension DiffOperation {
    var backgroundColor: Color {
        switch self.type {
        case .unchanged:
            return Color.clear
        case .added:
            return Color.green.opacity(0.2)
        case .removed:
            return Color.red.opacity(0.2)
        }
    }
}
