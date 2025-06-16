import Foundation
import SwiftUI

// MARK: - Stub Views for SpaceDetailView

/// Placeholder view for snapshot functionality
struct SnapshotView: View {
    let space: AugmentSpace

    var body: some View {
        VStack {
            Image(systemName: "camera")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 60, height: 60)
                .foregroundColor(.gray)

            Text("Snapshots")
                .font(.title2)
                .padding()

            Text("Snapshot functionality coming soon")
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

/// Placeholder view for network sync functionality
struct NetworkSyncView: View {
    let space: AugmentSpace

    var body: some View {
        VStack {
            Image(systemName: "arrow.triangle.2.circlepath")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 60, height: 60)
                .foregroundColor(.gray)

            Text("Network Sync")
                .font(.title2)
                .padding()

            Text("Network synchronization functionality coming soon")
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

/// Placeholder view for conflict resolution functionality
struct ConflictResolutionView: View {
    let space: AugmentSpace

    var body: some View {
        VStack {
            Image(systemName: "exclamationmark.triangle")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 60, height: 60)
                .foregroundColor(.gray)

            Text("Conflict Resolution")
                .font(.title2)
                .padding()

            Text("Conflict resolution functionality coming soon")
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

/// Search view for finding files across spaces
struct SearchView: View {
    let spaces: [AugmentSpace]
    @State private var searchText = ""
    @State private var searchResults: [FileItem] = []
    @State private var isSearching = false
    @State private var selectedFile: FileItem?
    @State private var isShowingVersionHistory = false

    private let versionControl = VersionControl.shared

    var body: some View {
        VStack {
            // Header
            HStack {
                Text("Search Files")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Spacer()

                Button("Done") {
                    // This will be handled by the parent view
                }
                .keyboardShortcut(.escape)
            }
            .padding()

            // Search field
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)

                TextField("Search files across all spaces...", text: $searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .onSubmit {
                        performSearch()
                    }

                if isSearching {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .scaleEffect(0.8)
                }
            }
            .padding(.horizontal)

            Divider()

            // Results
            if searchText.isEmpty {
                VStack {
                    Image(systemName: "magnifyingglass")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 60, height: 60)
                        .foregroundColor(.gray)

                    Text("Enter search terms to find files")
                        .font(.title2)
                        .padding()

                    Text("Search across all your Augment spaces")
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if searchResults.isEmpty && !isSearching {
                VStack {
                    Image(systemName: "doc.text.magnifyingglass")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 60, height: 60)
                        .foregroundColor(.gray)

                    Text("No files found")
                        .font(.title2)
                        .padding()

                    Text("Try different search terms")
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                List(searchResults) { file in
                    VStack(alignment: .leading) {
                        HStack {
                            Image(systemName: file.systemIcon)
                                .foregroundColor(file.typeColor)
                                .frame(width: 20)

                            VStack(alignment: .leading) {
                                Text(file.name)
                                    .font(.headline)

                                Text(file.path)
                                    .font(.caption)
                                    .foregroundColor(.secondary)

                                if file.versionCount > 0 {
                                    Text("\(file.versionCount) versions")
                                        .font(.caption)
                                        .foregroundColor(.blue)
                                }
                            }

                            Spacer()

                            Button("View History") {
                                selectedFile = file
                                isShowingVersionHistory = true
                            }
                            .buttonStyle(.bordered)
                        }
                    }
                    .padding(.vertical, 4)
                }
            }
        }
        .frame(width: 600, height: 500)
        .onChange(of: searchText) { _ in
            if !searchText.isEmpty {
                performSearch()
            } else {
                searchResults = []
            }
        }
        .sheet(isPresented: $isShowingVersionHistory) {
            if let file = selectedFile {
                VersionBrowser(file: file)
            }
        }
    }

    private func performSearch() {
        guard !searchText.isEmpty else {
            searchResults = []
            return
        }

        isSearching = true

        DispatchQueue.global(qos: .userInitiated).async {
            var results: [FileItem] = []

            for space in spaces {
                if let enumerator = FileManager.default.enumerator(
                    at: space.path,
                    includingPropertiesForKeys: [
                        .isDirectoryKey, .fileSizeKey, .contentModificationDateKey,
                    ],
                    options: [.skipsHiddenFiles]
                ) {
                    for case let fileURL as URL in enumerator {
                        do {
                            let resourceValues = try fileURL.resourceValues(forKeys: [
                                .isDirectoryKey, .fileSizeKey, .contentModificationDateKey,
                            ])

                            // Skip directories and .augment files
                            if resourceValues.isDirectory == true
                                || fileURL.path.contains("/.augment/")
                            {
                                continue
                            }

                            // Check if filename matches search
                            if fileURL.lastPathComponent.localizedCaseInsensitiveContains(
                                searchText)
                                || fileURL.path.localizedCaseInsensitiveContains(searchText)
                            {

                                let size = Int64(resourceValues.fileSize ?? 0)
                                let modificationDate =
                                    resourceValues.contentModificationDate ?? Date()
                                let fileType = FileType.from(extension: fileURL.pathExtension)
                                let versions = versionControl.getVersions(filePath: fileURL)

                                let fileItem = FileItem(
                                    name: fileURL.lastPathComponent,
                                    path: fileURL.path,
                                    type: fileType,
                                    modificationDate: modificationDate,
                                    versionCount: versions.count,
                                    size: size
                                )

                                results.append(fileItem)
                            }
                        } catch {
                            continue
                        }
                    }
                }
            }

            DispatchQueue.main.async {
                self.searchResults = results.sorted {
                    $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending
                }
                self.isSearching = false
            }
        }
    }
}
