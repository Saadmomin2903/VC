import SwiftUI

/// The type of conflict resolution for UI
enum ConflictResolutionUIType: String, CaseIterable {
    case keepLocal = "Keep Local"
    case keepRemote = "Keep Remote"
    case keepBoth = "Keep Both"
    case custom = "Custom"

    var description: String {
        switch self {
        case .keepLocal:
            return "Keep the local version and discard remote changes"
        case .keepRemote:
            return "Keep the remote version and discard local changes"
        case .keepBoth:
            return "Keep both versions with different names"
        case .custom:
            return "Manually edit the content to resolve conflicts"
        }
    }
}

struct ConflictResolutionView: View {
    let conflict: FileConflict
    @State private var resolution: ConflictResolution = .useLocal
    @State private var customContent: String = ""
    @State private var localContent: String = ""
    @State private var remoteContent: String = ""
    @State private var isTextFile: Bool = true
    @State private var localImage: NSImage?
    @State private var remoteImage: NSImage?
    @State private var isResolving = false

    private let conflictManager = ConflictManager.shared

    var body: some View {
        VStack(spacing: 0) {
            // Toolbar
            HStack {
                Text("Resolve Conflict: \(conflict.filePath.lastPathComponent)")
                    .font(.headline)

                Spacer()

                Button("Resolve") {
                    resolveConflict()
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
            .background(Color(NSColor.windowBackgroundColor))

            Divider()

            // Content
            VStack {
                // Resolution options
                HStack {
                    Text("Resolution:")
                        .font(.headline)

                    Picker("", selection: $resolution) {
                        Text("Use Local Version").tag(ConflictResolution.useLocal)
                        Text("Use Remote Version").tag(ConflictResolution.useRemote)
                        Text("Merge Both Versions").tag(ConflictResolution.merge)
                        Text("Keep Both as Copies").tag(ConflictResolution.createCopy)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .frame(width: 400)
                }
                .padding()

                // File content
                if isTextFile {
                    // Text file conflict
                    if resolution == .merge {
                        // Merge resolution - show both versions for comparison
                        VStack {
                            Text("Merge Resolution")
                                .font(.headline)
                                .frame(maxWidth: .infinity, alignment: .leading)

                            Text(
                                "Review both versions below. The system will attempt to merge them automatically."
                            )
                            .font(.caption)
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .padding()
                    }

                    if resolution != .merge {
                        // Side-by-side comparison
                        HStack(spacing: 0) {
                            // Local version
                            VStack {
                                HStack {
                                    Text("Local Version")
                                        .font(.headline)

                                    Spacer()

                                    Text(
                                        "Modified: \(formattedDate(conflict.localModificationDate))"
                                    )
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                }

                                TextEditor(text: .constant(localContent))
                                    .font(.system(.body, design: .monospaced))
                                    .border(Color.gray.opacity(0.2))
                                    .disabled(true)
                            }
                            .padding()
                            .overlay(
                                resolution == .useLocal
                                    ? RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.blue, lineWidth: 2)
                                        .padding(4) : nil
                            )

                            Divider()

                            // Remote version
                            VStack {
                                HStack {
                                    Text("Remote Version")
                                        .font(.headline)

                                    Spacer()

                                    Text(
                                        "Modified: \(formattedDate(conflict.remoteModificationDate))"
                                    )
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                }

                                TextEditor(text: .constant(remoteContent))
                                    .font(.system(.body, design: .monospaced))
                                    .border(Color.gray.opacity(0.2))
                                    .disabled(true)
                            }
                            .padding()
                            .overlay(
                                resolution == .useRemote
                                    ? RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.blue, lineWidth: 2)
                                        .padding(4) : nil
                            )
                        }
                    }
                } else {
                    // Image file conflict
                    if resolution == .merge {
                        // Merge not available for images
                        Text(
                            "Merge resolution is not available for image files. Please choose to use local, remote, or keep both versions."
                        )
                        .foregroundColor(.gray)
                        .padding()
                    } else {
                        // Side-by-side comparison
                        HStack(spacing: 0) {
                            // Local version
                            VStack {
                                HStack {
                                    Text("Local Version")
                                        .font(.headline)

                                    Spacer()

                                    Text(
                                        "Modified: \(formattedDate(conflict.localModificationDate))"
                                    )
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                }

                                if let image = localImage {
                                    Image(nsImage: image)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(maxHeight: 300)
                                }
                            }
                            .padding()
                            .overlay(
                                resolution == .useLocal
                                    ? RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.blue, lineWidth: 2)
                                        .padding(4) : nil
                            )

                            Divider()

                            // Remote version
                            VStack {
                                HStack {
                                    Text("Remote Version")
                                        .font(.headline)

                                    Spacer()

                                    Text(
                                        "Modified: \(formattedDate(conflict.remoteModificationDate))"
                                    )
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                }

                                if let image = remoteImage {
                                    Image(nsImage: image)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(maxHeight: 300)
                                }
                            }
                            .padding()
                            .overlay(
                                resolution == .useRemote
                                    ? RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.blue, lineWidth: 2)
                                        .padding(4) : nil
                            )
                        }
                    }
                }

                // Keep both explanation
                if resolution == .createCopy {
                    HStack {
                        Image(systemName: "info.circle")
                            .foregroundColor(.blue)

                        Text(
                            "Both versions will be kept as separate files. The conflicting version will be saved with a suffix."
                        )
                        .foregroundColor(.gray)
                    }
                    .padding()
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(8)
                    .padding()
                }
            }
        }
        .frame(width: 800, height: 600)
        .onAppear {
            loadFileContents()
        }
        .overlay(
            isResolving
                ? ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .scaleEffect(2.0)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.black.opacity(0.2))
                : nil
        )
    }

    private func loadFileContents() {
        // Determine if it's a text file
        let fileExtension = conflict.filePath.pathExtension.lowercased()
        isTextFile = [
            "txt", "md", "swift", "java", "c", "cpp", "h", "hpp", "py", "js", "html", "css", "xml",
            "json",
        ].contains(fileExtension)

        // Load the local content
        if let data = try? Data(contentsOf: conflict.filePath) {
            if isTextFile {
                localContent = String(data: data, encoding: .utf8) ?? ""
                customContent = localContent
            } else {
                localImage = NSImage(data: data)
            }
        }

        // Load the remote content
        loadRemoteContent()
    }

    private func resolveConflict() {
        isResolving = true

        // Use the resolution directly since it's already the correct type
        let success = conflictManager.resolveConflict(conflict, resolution: resolution)

        // Handle the result
        isResolving = false

        if success {
            // Close the window
            NSApp.keyWindow?.close()
        } else {
            // Show an error
            // TODO: Implement error handling
        }
    }

    private func loadRemoteContent() {
        // In a real implementation, this would fetch the remote version
        // For now, we'll simulate by loading the most recent version from version control
        let versionControl = VersionControl.shared
        let versions = versionControl.getVersions(filePath: conflict.filePath)

        // Get the second most recent version as "remote" (if available)
        if versions.count > 1 {
            let remoteVersion = versions[1]  // Second most recent

            DispatchQueue.global(qos: .userInitiated).async {
                if let data = try? Data(contentsOf: remoteVersion.storagePath) {
                    DispatchQueue.main.async {
                        if self.isTextFile {
                            self.remoteContent =
                                String(data: data, encoding: .utf8)
                                ?? "Unable to load remote content"
                        } else {
                            self.remoteImage = NSImage(data: data)
                        }
                    }
                }
            }
        } else {
            // No previous version available
            if isTextFile {
                remoteContent = "No remote version available"
            } else {
                remoteImage = nil
            }
        }
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}
