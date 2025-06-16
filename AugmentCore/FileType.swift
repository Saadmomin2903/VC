//
//  FileType.swift
//  Augment
//
//  Created by Saad Barkatullah Momin on 12/06/25.
//

import Foundation
import SwiftUI

/// Represents a file type for UI display
public enum FileType: String, Codable, CaseIterable {
    case text
    case image
    case document
    case code
    case other

    var iconName: String {
        switch self {
        case .text:
            return "doc.text"
        case .image:
            return "photo"
        case .document:
            return "doc"
        case .code:
            return "chevron.left.forwardslash.chevron.right"
        case .other:
            return "doc"
        }
    }

    var systemIcon: String {
        return iconName
    }

    var color: Color {
        switch self {
        case .text:
            return .blue
        case .image:
            return .green
        case .document:
            return .orange
        case .code:
            return .purple
        case .other:
            return .gray
        }
    }

    var description: String {
        switch self {
        case .text:
            return "Text File"
        case .image:
            return "Image File"
        case .document:
            return "Document"
        case .code:
            return "Code File"
        case .other:
            return "Other File"
        }
    }
}

/// Utility functions for file type detection
extension FileType {
    /// Determines file type from URL
    public static func from(url: URL) -> FileType {
        let fileExtension = url.pathExtension.lowercased()

        switch fileExtension {
        case "txt", "md":
            return .text
        case "swift", "java", "c", "cpp", "h", "hpp", "py", "js", "html", "css", "xml", "json":
            return .code
        case "jpg", "jpeg", "png", "gif", "bmp", "tiff", "heic":
            return .image
        case "doc", "docx", "pdf", "rtf", "ppt", "pptx", "xls", "xlsx":
            return .document
        default:
            return .other
        }
    }

    /// Determines file type from file extension string
    public static func from(extension fileExtension: String) -> FileType {
        let ext = fileExtension.lowercased()

        switch ext {
        case "txt", "md":
            return .text
        case "swift", "java", "c", "cpp", "h", "hpp", "py", "js", "html", "css", "xml", "json":
            return .code
        case "jpg", "jpeg", "png", "gif", "bmp", "tiff", "heic":
            return .image
        case "doc", "docx", "pdf", "rtf", "ppt", "pptx", "xls", "xlsx":
            return .document
        default:
            return .other
        }
    }
}
