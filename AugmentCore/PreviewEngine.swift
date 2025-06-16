import Cocoa
import Foundation
import QuickLook

/// Generates previews for different file types
public class PreviewEngine {
    /// Singleton instance
    public static let shared = PreviewEngine()

    /// Private initializer for singleton pattern
    private init() {}

    /// Generates a preview for a file
    /// - Parameters:
    ///   - filePath: The path to the file
    ///   - size: The size of the preview
    /// - Returns: The preview image if successful, nil otherwise
    public func generatePreview(filePath: URL, size: CGSize) -> NSImage? {
        // Check if the file exists
        guard FileManager.default.fileExists(atPath: filePath.path) else { return nil }

        // Get the file type
        let fileType = getFileType(filePath: filePath)

        // Generate the preview based on the file type
        switch fileType {
        case .text:
            return generateTextPreview(filePath: filePath, size: size)
        case .image:
            return generateImagePreview(filePath: filePath, size: size)
        case .pdf:
            return generatePDFPreview(filePath: filePath, size: size)
        case .other:
            return generateGenericPreview(filePath: filePath, size: size)
        }
    }

    /// Gets the file type for a file
    /// - Parameter filePath: The path to the file
    /// - Returns: The file type
    private func getFileType(filePath: URL) -> PreviewFileType {
        // Get the file extension
        let fileExtension = filePath.pathExtension.lowercased()

        // Determine the file type based on the extension
        switch fileExtension {
        case "txt", "md", "swift", "java", "c", "cpp", "h", "hpp", "py", "js", "html", "css", "xml",
            "json":
            return .text
        case "jpg", "jpeg", "png", "gif", "bmp", "tiff", "heic":
            return .image
        case "pdf":
            return .pdf
        default:
            return .other
        }
    }

    /// Generates a preview for a text file
    /// - Parameters:
    ///   - filePath: The path to the file
    ///   - size: The size of the preview
    /// - Returns: The preview image if successful, nil otherwise
    private func generateTextPreview(filePath: URL, size: CGSize) -> NSImage? {
        // Read the file content
        guard let content = try? String(contentsOf: filePath, encoding: .utf8) else { return nil }

        // Create an image context
        let image = NSImage(size: size)
        image.lockFocus()

        // Set the background color
        NSColor.white.set()
        NSBezierPath.fill(NSRect(origin: .zero, size: size))

        // Set the text attributes
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byTruncatingTail

        let attributes: [NSAttributedString.Key: Any] = [
            .font: NSFont.systemFont(ofSize: 12),
            .foregroundColor: NSColor.black,
            .paragraphStyle: paragraphStyle,
        ]

        // Draw the text
        let maxLines = Int(size.height / 14)  // Approximate line height
        let lines = content.components(separatedBy: .newlines)
        let truncatedLines = Array(lines.prefix(maxLines))
        let truncatedContent = truncatedLines.joined(separator: "\n")

        truncatedContent.draw(
            in: NSRect(
                origin: NSPoint(x: 5, y: 5),
                size: NSSize(width: size.width - 10, height: size.height - 10)),
            withAttributes: attributes)

        // End the image context
        image.unlockFocus()

        return image
    }

    /// Generates a preview for an image file
    /// - Parameters:
    ///   - filePath: The path to the file
    ///   - size: The size of the preview
    /// - Returns: The preview image if successful, nil otherwise
    private func generateImagePreview(filePath: URL, size: CGSize) -> NSImage? {
        // Load the image
        guard let image = NSImage(contentsOf: filePath) else { return nil }

        // Resize the image
        let resizedImage = NSImage(size: size)
        resizedImage.lockFocus()

        // Draw the image
        let imageRect = NSRect(origin: .zero, size: size)
        image.draw(
            in: imageRect, from: NSRect(origin: .zero, size: image.size), operation: .copy,
            fraction: 1.0)

        // End the image context
        resizedImage.unlockFocus()

        return resizedImage
    }

    /// Generates a preview for a PDF file
    /// - Parameters:
    ///   - filePath: The path to the file
    ///   - size: The size of the preview
    /// - Returns: The preview image if successful, nil otherwise
    private func generatePDFPreview(filePath: URL, size: CGSize) -> NSImage? {
        // Load the PDF
        guard let pdf = CGPDFDocument(filePath as CFURL) else { return nil }
        guard let page = pdf.page(at: 1) else { return nil }

        // Create an image context
        let image = NSImage(size: size)
        image.lockFocus()

        // Set the background color
        NSColor.white.set()
        NSBezierPath.fill(NSRect(origin: .zero, size: size))

        // Get the PDF page rect
        let pageRect = page.getBoxRect(.mediaBox)

        // Calculate the scale to fit the page in the image
        let scale = min(size.width / pageRect.width, size.height / pageRect.height)

        // Calculate the centered position
        let x = (size.width - pageRect.width * scale) / 2
        let y = (size.height - pageRect.height * scale) / 2

        // Create the graphics context
        guard let context = NSGraphicsContext.current?.cgContext else { return nil }

        // Flip the context
        context.translateBy(x: 0, y: size.height)
        context.scaleBy(x: 1, y: -1)

        // Draw the PDF page
        context.translateBy(x: x, y: y)
        context.scaleBy(x: scale, y: scale)
        context.drawPDFPage(page)

        // End the image context
        image.unlockFocus()

        return image
    }

    /// Generates a generic preview for a file
    /// - Parameters:
    ///   - filePath: The path to the file
    ///   - size: The size of the preview
    /// - Returns: The preview image if successful, nil otherwise
    private func generateGenericPreview(filePath: URL, size: CGSize) -> NSImage? {
        // Use QuickLook to generate a preview
        let scale = NSScreen.main?.backingScaleFactor ?? 1.0
        let options: [CFString: Any] = [
            kQLThumbnailOptionIconModeKey: false,
            kQLThumbnailOptionScaleFactorKey: scale,
        ]

        guard
            let thumbnail = QLThumbnailImageCreate(
                kCFAllocatorDefault,
                filePath as CFURL,
                CGSize(width: size.width * scale, height: size.height * scale),
                options as CFDictionary
            )
        else { return nil }

        // Create an NSImage from the thumbnail
        let image = NSImage(cgImage: thumbnail.takeUnretainedValue(), size: size)

        return image
    }
}

/// Represents a preview file type
public enum PreviewFileType {
    /// Text file
    case text

    /// Image file
    case image

    /// PDF file
    case pdf

    /// Other file type
    case other
}

/// Represents a diff operation for text files
public struct DiffOperation: Codable {
    /// The type of operation
    public let type: OperationType

    /// The content of the operation
    public let content: String

    /// The line number (for text diffs)
    public let lineNumber: Int?

    /// Initialize a new diff operation
    public init(type: OperationType, content: String, lineNumber: Int? = nil) {
        self.type = type
        self.content = content
        self.lineNumber = lineNumber
    }

    /// The type of diff operation
    public enum OperationType: String, Codable {
        case unchanged = "unchanged"
        case added = "added"
        case removed = "removed"
    }
}

/// Generates diffs between file versions
public class DiffEngine {
    /// Singleton instance
    public static let shared = DiffEngine()

    /// Private initializer for singleton pattern
    private init() {}

    /// Generates a diff between two file versions
    /// - Parameters:
    ///   - fromVersion: The source version
    ///   - toVersion: The target version
    /// - Returns: A FileDiff object representing the differences
    public func generateDiff(fromVersion: FileVersion, toVersion: FileVersion) -> FileDiff {
        // Check if the files are identical
        if fromVersion.contentHash == toVersion.contentHash {
            return FileDiff(
                fromVersion: fromVersion,
                toVersion: toVersion,
                diffType: .none,
                diffData: Data()
            )
        }

        // Determine the file type
        let fileExtension = fromVersion.filePath.pathExtension.lowercased()

        // Generate diff based on file type
        if isTextFile(extension: fileExtension) {
            return generateTextDiff(fromVersion: fromVersion, toVersion: toVersion)
        } else if isImageFile(extension: fileExtension) {
            return generateImageDiff(fromVersion: fromVersion, toVersion: toVersion)
        } else {
            return generateBinaryDiff(fromVersion: fromVersion, toVersion: toVersion)
        }
    }

    /// Generates a text-based diff
    private func generateTextDiff(fromVersion: FileVersion, toVersion: FileVersion) -> FileDiff {
        do {
            // Read the file contents
            let fromData = try Data(contentsOf: fromVersion.storagePath)
            let toData = try Data(contentsOf: toVersion.storagePath)

            guard let fromText = String(data: fromData, encoding: .utf8),
                let toText = String(data: toData, encoding: .utf8)
            else {
                return generateBinaryDiff(fromVersion: fromVersion, toVersion: toVersion)
            }

            // Split into lines
            let fromLines = fromText.components(separatedBy: .newlines)
            let toLines = toText.components(separatedBy: .newlines)

            // Generate diff operations
            let operations = generateDiffOperations(fromLines: fromLines, toLines: toLines)

            // Encode operations as JSON
            let diffData = try JSONEncoder().encode(operations)

            return FileDiff(
                fromVersion: fromVersion,
                toVersion: toVersion,
                diffType: .text,
                diffData: diffData
            )
        } catch {
            print("Error generating text diff: \(error)")
            return generateBinaryDiff(fromVersion: fromVersion, toVersion: toVersion)
        }
    }

    /// Generates an image-based diff
    private func generateImageDiff(fromVersion: FileVersion, toVersion: FileVersion) -> FileDiff {
        // For images, we just store metadata about the differences
        let diffInfo: [String: Any] = [
            "type": "image",
            "fromSize": fromVersion.size,
            "toSize": toVersion.size,
            "fromPath": fromVersion.storagePath.path,
            "toPath": toVersion.storagePath.path,
        ]

        do {
            let diffData = try JSONSerialization.data(withJSONObject: diffInfo)
            return FileDiff(
                fromVersion: fromVersion,
                toVersion: toVersion,
                diffType: .image,
                diffData: diffData
            )
        } catch {
            return generateBinaryDiff(fromVersion: fromVersion, toVersion: toVersion)
        }
    }

    /// Generates a binary file diff
    private func generateBinaryDiff(fromVersion: FileVersion, toVersion: FileVersion) -> FileDiff {
        let diffInfo: [String: Any] = [
            "type": "binary",
            "fromSize": fromVersion.size,
            "toSize": toVersion.size,
            "identical": fromVersion.contentHash == toVersion.contentHash,
        ]

        do {
            let diffData = try JSONSerialization.data(withJSONObject: diffInfo)
            return FileDiff(
                fromVersion: fromVersion,
                toVersion: toVersion,
                diffType: .binary,
                diffData: diffData
            )
        } catch {
            return FileDiff(
                fromVersion: fromVersion,
                toVersion: toVersion,
                diffType: .binary,
                diffData: Data()
            )
        }
    }

    /// Generates diff operations for text files using a simple line-by-line comparison
    private func generateDiffOperations(fromLines: [String], toLines: [String]) -> [DiffOperation] {
        var operations: [DiffOperation] = []
        let maxLines = max(fromLines.count, toLines.count)

        for i in 0..<maxLines {
            let fromLine = i < fromLines.count ? fromLines[i] : nil
            let toLine = i < toLines.count ? toLines[i] : nil

            switch (fromLine, toLine) {
            case (let from?, let to?) where from == to:
                // Lines are identical
                operations.append(DiffOperation(type: .unchanged, content: from, lineNumber: i + 1))
            case (let from?, let to?):
                // Lines are different
                operations.append(DiffOperation(type: .removed, content: from, lineNumber: i + 1))
                operations.append(DiffOperation(type: .added, content: to, lineNumber: i + 1))
            case (let from?, nil):
                // Line was removed
                operations.append(DiffOperation(type: .removed, content: from, lineNumber: i + 1))
            case (nil, let to?):
                // Line was added
                operations.append(DiffOperation(type: .added, content: to, lineNumber: i + 1))
            case (nil, nil):
                // This shouldn't happen
                break
            }
        }

        return operations
    }

    /// Checks if a file extension represents a text file
    private func isTextFile(extension fileExtension: String) -> Bool {
        let textExtensions = [
            "txt", "md", "swift", "java", "c", "cpp", "h", "hpp", "py", "js",
            "html", "css", "xml", "json", "yaml", "yml", "sh", "bat", "ps1",
            "rb", "php", "go", "rs", "kt", "scala", "clj", "hs", "elm", "ts",
        ]
        return textExtensions.contains(fileExtension.lowercased())
    }

    /// Checks if a file extension represents an image file
    private func isImageFile(extension fileExtension: String) -> Bool {
        let imageExtensions = [
            "jpg", "jpeg", "png", "gif", "bmp", "tiff", "tif", "webp", "svg", "ico",
        ]
        return imageExtensions.contains(fileExtension.lowercased())
    }
}
