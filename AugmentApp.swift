import FinderSync
import SwiftUI

@main
struct AugmentApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

struct ContentView: View {
    @State private var selectedFolder: URL?
    @State private var versions: [FolderVersion] = []
    @State private var showingFolderPicker = false
    @State private var showingVersionPicker = false
    @State private var selectedVersion: FolderVersion?

    var body: some View {
        VStack(spacing: 20) {
            if let folder = selectedFolder {
                Text("Selected Folder: \(folder.lastPathComponent)")
                    .font(.headline)

                Button("Create New Version") {
                    if let version = VersionControl.shared.createVersion(
                        folderPath: folder, comment: "Manual version")
                    {
                        versions.append(version)
                    }
                }
                .buttonStyle(.borderedProminent)

                List(versions, id: \.id) { version in
                    VStack(alignment: .leading) {
                        Text(version.timestamp, style: .date)
                            .font(.headline)
                        if let comment = version.comment {
                            Text(comment)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        Button("Restore to this version") {
                            selectedVersion = version
                            showingVersionPicker = true
                        }
                        .buttonStyle(.bordered)
                    }
                    .padding(.vertical, 5)
                }
            } else {
                Button("Select Folder") {
                    showingFolderPicker = true
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .padding()
        .frame(minWidth: 400, minHeight: 300)
        .fileImporter(
            isPresented: $showingFolderPicker,
            allowedContentTypes: [.folder],
            allowsMultipleSelection: false
        ) { result in
            switch result {
            case .success(let urls):
                if let url = urls.first {
                    selectedFolder = url
                    if VersionControl.shared.initializeVersionControl(folderPath: url) {
                        versions = VersionControl.shared.getVersions(folderPath: url)
                    }
                }
            case .failure(let error):
                print("Error selecting folder: \(error)")
            }
        }
        .alert("Restore Version", isPresented: $showingVersionPicker) {
            Button("Cancel", role: .cancel) {}
            Button("Restore") {
                if let version = selectedVersion,
                    let folder = selectedFolder
                {
                    if VersionControl.shared.restoreVersion(folderPath: folder, version: version) {
                        versions = VersionControl.shared.getVersions(folderPath: folder)
                    }
                }
            }
        } message: {
            Text(
                "Are you sure you want to restore to this version? This will create a backup of your current state."
            )
        }
    }
}
