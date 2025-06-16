import Foundation
import SwiftUI

/// Represents a file item in an Augment space
public struct FileItem: Identifiable, Codable, Hashable {
    /// Unique identifier for the file item
    public let id: UUID
    
    /// Display name of the file
    public var name: String
    
    /// Full file system path
    public var path: String
    
    /// File type classification
    public var type: FileType
    
    /// Date when the file was last modified
    public var modificationDate: Date
    
    /// Number of versions available for this file
    public var versionCount: Int
    
    /// File size in bytes
    public var size: Int64
    
    /// Whether the file has conflicts
    public var hasConflicts: Bool
    
    /// Whether the file is currently being synced
    public var isSyncing: Bool
    
    /// Initialize a new file item
    /// - Parameters:
    ///   - id: Unique identifier (generates new UUID if not provided)
    ///   - name: Display name of the file
    ///   - path: Full file system path
    ///   - type: File type classification
    ///   - modificationDate: Last modification date
    ///   - versionCount: Number of versions available
    ///   - size: File size in bytes (defaults to 0)
    ///   - hasConflicts: Whether the file has conflicts (defaults to false)
    ///   - isSyncing: Whether the file is syncing (defaults to false)
    public init(
        id: UUID = UUID(),
        name: String,
        path: String,
        type: FileType,
        modificationDate: Date,
        versionCount: Int,
        size: Int64 = 0,
        hasConflicts: Bool = false,
        isSyncing: Bool = false
    ) {
        self.id = id
        self.name = name
        self.path = path
        self.type = type
        self.modificationDate = modificationDate
        self.versionCount = versionCount
        self.size = size
        self.hasConflicts = hasConflicts
        self.isSyncing = isSyncing
    }
    
    /// Get the file URL
    public var url: URL {
        return URL(fileURLWithPath: path)
    }
    
    /// Get the file extension
    public var fileExtension: String {
        return url.pathExtension.lowercased()
    }
    
    /// Get a human-readable file size string
    public var formattedSize: String {
        return ByteCountFormatter.string(fromByteCount: size, countStyle: .file)
    }
    
    /// Get a human-readable modification date string
    public var formattedModificationDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: modificationDate)
    }
    
    /// Get the appropriate system icon for this file type
    public var systemIcon: String {
        return type.systemIcon
    }
    
    /// Get the color associated with this file type
    public var typeColor: Color {
        return type.color
    }
    
    /// Check if the file exists on disk
    public var exists: Bool {
        return FileManager.default.fileExists(atPath: path)
    }
    
    /// Update the file's metadata from disk
    /// - Returns: Updated FileItem, or nil if file doesn't exist
    public func updatedFromDisk() -> FileItem? {
        guard exists else { return nil }
        
        guard let attributes = try? FileManager.default.attributesOfItem(atPath: path) else {
            return nil
        }
        
        let newModificationDate = attributes[.modificationDate] as? Date ?? modificationDate
        let newSize = attributes[.size] as? Int64 ?? size
        
        var updated = self
        updated.modificationDate = newModificationDate
        updated.size = newSize
        
        return updated
    }
}

// MARK: - Hashable Conformance
extension FileItem {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(path)
    }
    
    public static func == (lhs: FileItem, rhs: FileItem) -> Bool {
        return lhs.id == rhs.id && lhs.path == rhs.path
    }
}

// MARK: - Comparable Conformance
extension FileItem: Comparable {
    public static func < (lhs: FileItem, rhs: FileItem) -> Bool {
        // Sort by name, case-insensitive
        return lhs.name.localizedCaseInsensitiveCompare(rhs.name) == .orderedAscending
    }
}

/// SwiftUI view for displaying a file item row
public struct FileItemRow: View {
    let file: FileItem
    
    public init(file: FileItem) {
        self.file = file
    }
    
    public var body: some View {
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
                            .foregroundColor(.secondary)
                    }
                }
            }
            
            Spacer()
            
            // Status indicators
            HStack(spacing: 4) {
                if file.hasConflicts {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(.orange)
                        .font(.caption)
                }
                
                if file.isSyncing {
                    Image(systemName: "arrow.triangle.2.circlepath")
                        .foregroundColor(.blue)
                        .font(.caption)
                }
            }
        }
        .padding(.vertical, 2)
    }
}
