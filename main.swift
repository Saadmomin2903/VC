import Foundation

@main
struct AugmentCLI {
    static func main() {
        let args = CommandLine.arguments

        if args.count < 2 {
            printUsage()
            return
        }

        let command = args[1]

        switch command {
        case "create-space":
            handleCreateSpace(args: Array(args.dropFirst(2)))
        case "list-spaces":
            handleListSpaces()
        case "create-version":
            handleCreateVersion(args: Array(args.dropFirst(2)))
        case "list-versions":
            handleListVersions(args: Array(args.dropFirst(2)))
        case "restore-version":
            handleRestoreVersion(args: Array(args.dropFirst(2)))
        case "search":
            handleSearch(args: Array(args.dropFirst(2)))
        case "create-snapshot":
            handleCreateSnapshot(args: Array(args.dropFirst(2)))
        case "list-snapshots":
            handleListSnapshots(args: Array(args.dropFirst(2)))
        case "help", "--help", "-h":
            printUsage()
        default:
            print("❌ Unknown command: \(command)")
            printUsage()
        }
    }

    static func printUsage() {
        print("🚀 Augment CLI - Seamless Version Control for Everyone")
        print("")
        print("📋 Usage: augment <command> [options]")
        print("")
        print("🏠 Space Management:")
        print("  create-space <name> <path>     Create a new Augment space")
        print("  list-spaces                    List all Augment spaces")
        print("")
        print("📝 File Versioning:")
        print("  create-version <file-path>     Create a version of a file")
        print("  list-versions <file-path>      List all versions of a file")
        print("  restore-version <file-path> <version-id>  Restore file to version")
        print("")
        print("🔍 Search & Discovery:")
        print("  search <space-path> <term>     Search for files containing term")
        print("")
        print("📸 Snapshots:")
        print("  create-snapshot <space-path> <name>  Create a space snapshot")
        print("  list-snapshots <space-path>          List all snapshots")
        print("")
        print("💡 Examples:")
        print("  augment create-space \"My Project\" ~/Documents/MyProject")
        print("  augment create-version ~/Documents/MyProject/file.txt")
        print("  augment search ~/Documents/MyProject \"function\"")
        print("")
        print("🌟 Features:")
        print("  • Automatic versioning when files change")
        print("  • Full-text search across all files")
        print("  • Snapshot management for milestones")
        print("  • Conflict resolution for sync")
        print("  • Encrypted backups")
    }

    static func handleCreateSpace(args: [String]) {
        guard args.count >= 2 else {
            print("❌ Usage: create-space <name> <path>")
            return
        }

        let name = args[0]
        let path = URL(fileURLWithPath: args[1])

        let fileSystem = AugmentFileSystem.shared
        if let space = fileSystem.createSpace(name: name, path: path) {
            print("✅ Created Augment space '\(name)' at \(path.path)")
            print("📁 Space ID: \(space.id)")
            print("🎯 Files in this directory will now be automatically versioned!")
        } else {
            print("❌ Failed to create space. Check if path exists and is writable.")
        }
    }

    static func handleListSpaces() {
        let fileSystem = AugmentFileSystem.shared
        let spaces = fileSystem.getSpaces()

        if spaces.isEmpty {
            print("📭 No Augment spaces found.")
            print("💡 Create one with: augment create-space <name> <path>")
        } else {
            print("📂 Augment Spaces:")
            for space in spaces {
                print("  • \(space.name) (\(space.path.path))")
            }
        }
    }

    static func handleCreateVersion(args: [String]) {
        guard args.count >= 1 else {
            print("❌ Usage: create-version <file-path>")
            return
        }

        let filePath = URL(fileURLWithPath: args[0])
        let comment = args.count > 1 ? args[1] : "Manual version creation"

        let versionControl = VersionControl.shared
        if let version = versionControl.createFileVersion(filePath: filePath, comment: comment) {
            print("✅ Created version for \(filePath.lastPathComponent)")
            print("🆔 Version ID: \(version.id)")
            print("📅 Timestamp: \(version.timestamp)")
            print("💬 Comment: \(version.comment ?? "No comment")")
        } else {
            print("❌ Failed to create version. Check if file exists and is in an Augment space.")
        }
    }

    static func handleListVersions(args: [String]) {
        guard args.count >= 1 else {
            print("❌ Usage: list-versions <file-path>")
            return
        }

        let filePath = URL(fileURLWithPath: args[0])
        let versionControl = VersionControl.shared
        let versions = versionControl.getVersions(filePath: filePath)

        if versions.isEmpty {
            print("📭 No versions found for \(filePath.lastPathComponent)")
            print("💡 Create one with: augment create-version \(filePath.path)")
        } else {
            print("📋 Versions for \(filePath.lastPathComponent):")
            for (index, version) in versions.enumerated() {
                let marker = index == 0 ? "👑" : "📄"
                print("  \(marker) \(version.id) - \(version.timestamp)")
                if let comment = version.comment {
                    print("     💬 \(comment)")
                }
                print("     📏 Size: \(formatBytes(version.size))")
            }
        }
    }

    static func handleRestoreVersion(args: [String]) {
        guard args.count >= 2 else {
            print("❌ Usage: restore-version <file-path> <version-id>")
            return
        }

        let filePath = URL(fileURLWithPath: args[0])
        let versionIdString = args[1]

        guard let versionId = UUID(uuidString: versionIdString) else {
            print("❌ Invalid version ID format")
            return
        }

        let versionControl = VersionControl.shared
        let versions = versionControl.getVersions(filePath: filePath)

        guard let version = versions.first(where: { $0.id == versionId }) else {
            print("❌ Version not found")
            return
        }

        if versionControl.restoreVersion(filePath: filePath, version: version) {
            print("✅ Restored \(filePath.lastPathComponent) to version from \(version.timestamp)")
            print("💾 A backup of the current version was created automatically")
        } else {
            print("❌ Failed to restore version")
        }
    }

    static func handleSearch(args: [String]) {
        guard args.count >= 2 else {
            print("❌ Usage: search <space-path> <search-term>")
            return
        }

        let spacePath = URL(fileURLWithPath: args[0])
        let searchTerm = args[1]

        let searchEngine = SearchEngine.shared
        let results = searchEngine.search(query: searchTerm, spacePath: spacePath)

        if results.isEmpty {
            print("🔍 No results found for '\(searchTerm)' in \(spacePath.lastPathComponent)")
        } else {
            print("🔍 Found \(results.count) results for '\(searchTerm)':")
            for result in results.prefix(10) {
                print("  📄 \(result.filePath.lastPathComponent)")
                print("     📁 \(result.filePath.path)")
                if !result.snippet.isEmpty {
                    print("     💬 \(result.snippet)")
                }
                print("")
            }
            if results.count > 10 {
                print("  ... and \(results.count - 10) more results")
            }
        }
    }

    static func handleCreateSnapshot(args: [String]) {
        guard args.count >= 2 else {
            print("❌ Usage: create-snapshot <space-path> <name>")
            return
        }

        let spacePath = URL(fileURLWithPath: args[0])
        let name = args[1]
        let description = args.count > 2 ? args[2] : "Created via CLI"

        let snapshotManager = SnapshotManager.shared
        if let snapshot = snapshotManager.createSnapshot(
            spacePath: spacePath, name: name, description: description)
        {
            print("✅ Created snapshot '\(name)' for \(spacePath.lastPathComponent)")
            print("🆔 Snapshot ID: \(snapshot.id)")
            print("📅 Timestamp: \(snapshot.timestamp)")
            print("📁 Files: \(snapshot.files.count)")
        } else {
            print("❌ Failed to create snapshot")
        }
    }

    static func handleListSnapshots(args: [String]) {
        guard args.count >= 1 else {
            print("❌ Usage: list-snapshots <space-path>")
            return
        }

        let spacePath = URL(fileURLWithPath: args[0])
        let snapshotManager = SnapshotManager.shared
        let snapshots = snapshotManager.getSnapshots(spacePath: spacePath)

        if snapshots.isEmpty {
            print("📭 No snapshots found for \(spacePath.lastPathComponent)")
        } else {
            print("📸 Snapshots for \(spacePath.lastPathComponent):")
            for snapshot in snapshots {
                print("  📸 \(snapshot.name) - \(snapshot.timestamp)")
                if let description = snapshot.description {
                    print("     💬 \(description)")
                }
                print("     📁 Files: \(snapshot.files.count)")
            }
        }
    }

    static func formatBytes(_ bytes: UInt64) -> String {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = [.useKB, .useMB, .useGB]
        formatter.countStyle = .file
        return formatter.string(fromByteCount: Int64(bytes))
    }
}
