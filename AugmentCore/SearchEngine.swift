import Foundation

/// Manages search and indexing for Augment spaces
public class SearchEngine {
    /// Singleton instance - DEPRECATED: Use dependency injection instead
    @available(*, deprecated, message: "Use dependency injection instead of singleton pattern")
    public static let shared = SearchEngine()

    /// The index database - CRITICAL FIX: More efficient data structure
    /// Using a flattened structure with composite keys for better performance
    private var indexDatabase: [String: [SearchResult]] = [:]
    private var spaceToTokens: [URL: Set<String>] = [:]

    /// Concurrent queue for thread-safe access to the index database
    private let indexQueue = DispatchQueue(
        label: "com.augment.searchengine.index", attributes: .concurrent)

    /// Public initializer for dependency injection
    public init() {}

    /// Indexes a file
    /// - Parameters:
    ///   - filePath: The path to the file
    ///   - version: The file version
    /// - Returns: A boolean indicating success or failure
    public func indexFile(filePath: URL, version: FileVersion) -> Bool {
        // Get the space path
        guard let spacePath = getSpacePath(filePath: filePath) else { return false }

        // Check if the file is indexable
        guard isFileIndexable(filePath: filePath) else { return false }

        // Read the file content
        guard let data = try? Data(contentsOf: version.storagePath) else { return false }

        // Extract the text content
        guard let content = extractTextContent(data: data, filePath: filePath) else { return false }

        // Tokenize the content
        let tokens = tokenizeContent(content: content)

        // Create the search results
        let results = tokens.map { token in
            SearchResult(
                id: UUID(),
                filePath: filePath,
                version: version,
                token: token,
                context: getContext(content: content, token: token)
            )
        }

        // CRITICAL FIX: Implement atomic operations with improved data structure
        return indexQueue.sync(flags: .barrier) {
            // Use composite keys for better performance: "spacePath|token"
            var tokensForSpace = spaceToTokens[spacePath] ?? Set<String>()

            // Add all results in a single atomic operation
            for result in results {
                let compositeKey = "\(spacePath.path)|\(result.token)"

                // Initialize token array if needed
                if indexDatabase[compositeKey] == nil {
                    indexDatabase[compositeKey] = []
                }

                // Add the result to the token array
                indexDatabase[compositeKey]?.append(result)

                // Track tokens for this space
                tokensForSpace.insert(result.token)
            }

            // Update space-to-tokens mapping
            spaceToTokens[spacePath] = tokensForSpace

            return true
        }
    }

    /// Searches for a query
    /// - Parameters:
    ///   - query: The search query
    ///   - spacePaths: The paths to the Augment spaces to search in
    /// - Returns: An array of search results
    public func search(query: String, spacePaths: [URL]) -> [SearchResult] {
        // Validate input
        guard !query.isEmpty && !spacePaths.isEmpty else { return [] }

        // Tokenize the query
        let tokens = tokenizeContent(content: query)
        guard !tokens.isEmpty else { return [] }

        // CRITICAL FIX: Implement thread-safe search with atomic read operations
        return indexQueue.sync {
            var allResults: [SearchResult] = []

            // Create a snapshot of the index to ensure consistency during search
            let indexSnapshot = indexDatabase

            for spacePath in spacePaths {
                for token in tokens {
                    // Use composite key for efficient lookup
                    let compositeKey = "\(spacePath.path)|\(token)"
                    if let results = indexSnapshot[compositeKey] {
                        allResults.append(contentsOf: results)
                    }
                }
            }

            // Remove duplicates efficiently using Set operations
            var uniqueResults: [SearchResult] = []
            var seenIds: Set<UUID> = []

            for result in allResults {
                if seenIds.insert(result.id).inserted {
                    uniqueResults.append(result)
                }
            }

            // Sort by relevance (stable sort for consistent results)
            uniqueResults.sort { $0.relevance > $1.relevance }

            return uniqueResults
        }
    }

    /// Async version of search for modern Swift concurrency
    /// - Parameters:
    ///   - query: The search query
    ///   - spacePaths: The paths to the Augment spaces to search in
    /// - Returns: An array of search results
    @available(macOS 10.15, *)
    public func searchAsync(query: String, spacePaths: [URL]) async -> [SearchResult] {
        return await withCheckedContinuation { continuation in
            DispatchQueue.global(qos: .userInitiated).async {
                let results = self.search(query: query, spacePaths: spacePaths)
                continuation.resume(returning: results)
            }
        }
    }

    /// Indexes all files in a space
    /// - Parameter spacePath: The path to the Augment space
    /// - Returns: A boolean indicating success or failure
    public func indexSpace(spacePath: URL) -> Bool {
        // Validate the space path
        guard spacePath.isFileURL else {
            print("SearchEngine: Invalid space path (not a file URL): \(spacePath)")
            return false
        }

        guard FileManager.default.fileExists(atPath: spacePath.path) else {
            print("SearchEngine: Space path does not exist: \(spacePath.path)")
            return false
        }

        // Get all files in the space with error handling
        guard
            let fileEnumerator = FileManager.default.enumerator(
                at: spacePath, includingPropertiesForKeys: nil)
        else {
            print("SearchEngine: Failed to create file enumerator for: \(spacePath.path)")
            return false
        }

        var indexedCount = 0
        var skippedCount = 0
        var errorCount = 0

        // Index each file with proper error handling
        for case let fileURL as URL in fileEnumerator {
            do {
                // Skip directories
                var isDirectory: ObjCBool = false
                guard
                    FileManager.default.fileExists(atPath: fileURL.path, isDirectory: &isDirectory),
                    !isDirectory.boolValue
                else {
                    skippedCount += 1
                    continue
                }

                // Skip hidden files and system files
                let fileName = fileURL.lastPathComponent
                if fileName.starts(with: ".") || fileName.starts(with: "~") {
                    skippedCount += 1
                    continue
                }

                // Create a dummy version for testing
                let version = FileVersion(
                    id: UUID(),
                    filePath: fileURL,
                    timestamp: Date(),
                    size: 0,
                    comment: nil,
                    contentHash: "",
                    storagePath: fileURL
                )

                // Index the file with error handling
                let success = indexFile(filePath: fileURL, version: version)
                if success {
                    indexedCount += 1
                } else {
                    skippedCount += 1
                }

            } catch {
                print("SearchEngine: Error processing file \(fileURL.path): \(error)")
                errorCount += 1
            }
        }

        print(
            "SearchEngine: Indexing complete for \(spacePath.lastPathComponent) - Indexed: \(indexedCount), Skipped: \(skippedCount), Errors: \(errorCount)"
        )
        return errorCount == 0
    }

    /// Async version of indexSpace for modern Swift concurrency
    /// - Parameter spacePath: The path to the Augment space
    /// - Returns: A boolean indicating success or failure
    @available(macOS 10.15, *)
    public func indexSpaceAsync(spacePath: URL) async -> Bool {
        return await withCheckedContinuation { continuation in
            DispatchQueue.global(qos: .utility).async {
                let result = self.indexSpace(spacePath: spacePath)
                continuation.resume(returning: result)
            }
        }
    }

    /// Removes a file from the index
    /// - Parameter filePath: The path to the file to remove
    /// - Returns: A boolean indicating success or failure
    public func removeFile(filePath: URL) -> Bool {
        guard let spacePath = getSpacePath(filePath: filePath) else { return false }

        return indexQueue.sync(flags: .barrier) {
            // Get tokens for this space
            guard let spaceTokens = spaceToTokens[spacePath] else { return true }

            var tokensToRemove: Set<String> = []

            // Remove all search results for this file
            for token in spaceTokens {
                let compositeKey = "\(spacePath.path)|\(token)"
                if var results = indexDatabase[compositeKey] {
                    results = results.filter { $0.filePath != filePath }
                    if results.isEmpty {
                        indexDatabase.removeValue(forKey: compositeKey)
                        tokensToRemove.insert(token)
                    } else {
                        indexDatabase[compositeKey] = results
                    }
                }
            }

            // Update space tokens
            if !tokensToRemove.isEmpty {
                var updatedTokens = spaceTokens
                updatedTokens.subtract(tokensToRemove)
                spaceToTokens[spacePath] = updatedTokens
            }

            return true
        }
    }

    /// Clears the index for a space
    /// - Parameter spacePath: The path to the Augment space
    /// - Returns: A boolean indicating success or failure
    public func clearIndex(spacePath: URL) -> Bool {
        // CRITICAL FIX: Atomic removal with proper cleanup for new data structure
        return indexQueue.sync(flags: .barrier) {
            // Get tokens for this space
            guard let spaceTokens = spaceToTokens[spacePath] else { return true }

            // Remove all composite keys for this space
            for token in spaceTokens {
                let compositeKey = "\(spacePath.path)|\(token)"
                indexDatabase.removeValue(forKey: compositeKey)
            }

            // Remove space from tokens mapping
            spaceToTokens.removeValue(forKey: spacePath)

            print("SearchEngine: Cleared index for space: \(spacePath.lastPathComponent)")
            return true
        }
    }

    /// Gets index statistics for monitoring and debugging
    /// - Returns: A dictionary with index statistics
    public func getIndexStatistics() -> [String: Any] {
        return indexQueue.sync {
            var stats: [String: Any] = [:]

            stats["totalSpaces"] = spaceToTokens.count
            stats["totalCompositeKeys"] = indexDatabase.count

            var totalTokens = 0
            var totalResults = 0

            for (spacePath, tokens) in spaceToTokens {
                totalTokens += tokens.count

                var spaceResults = 0
                for token in tokens {
                    let compositeKey = "\(spacePath.path)|\(token)"
                    if let results = indexDatabase[compositeKey] {
                        spaceResults += results.count
                    }
                }
                totalResults += spaceResults

                stats["space_\(spacePath.lastPathComponent)"] = [
                    "tokens": tokens.count,
                    "results": spaceResults,
                ]
            }

            stats["totalTokens"] = totalTokens
            stats["totalResults"] = totalResults

            return stats
        }
    }

    /// Gets the space path for a file
    /// - Parameter filePath: The path to the file
    /// - Returns: The space path if found, nil otherwise
    private func getSpacePath(filePath: URL) -> URL? {
        // TODO: Implement space path lookup
        // This is a placeholder for the actual implementation

        // Get the parent directory
        var parent = filePath.deletingLastPathComponent()

        // Check if the parent is a space
        while parent.path != "/" {
            if FileManager.default.fileExists(
                atPath: parent.appendingPathComponent(".augment").path)
            {
                return parent
            }

            parent = parent.deletingLastPathComponent()
        }

        return nil
    }

    /// Checks if a file is indexable
    /// - Parameter filePath: The path to the file
    /// - Returns: A boolean indicating whether the file is indexable
    private func isFileIndexable(filePath: URL) -> Bool {
        // Get the file extension
        let fileExtension = filePath.pathExtension.lowercased()

        // Check if the file is indexable based on its extension
        let indexableExtensions = [
            "txt", "md", "swift", "java", "c", "cpp", "h", "hpp", "py", "js", "html", "css", "xml",
            "json",
            "doc", "docx", "pdf", "rtf", "csv", "xls", "xlsx", "ppt", "pptx",
        ]

        return indexableExtensions.contains(fileExtension)
    }

    /// Extracts text content from file data
    /// - Parameters:
    ///   - data: The file data
    ///   - filePath: The path to the file
    /// - Returns: The text content if successful, nil otherwise
    private func extractTextContent(data: Data, filePath: URL) -> String? {
        // Get the file extension
        let fileExtension = filePath.pathExtension.lowercased()

        // Extract text based on file type
        switch fileExtension {
        case "txt", "md", "swift", "java", "c", "cpp", "h", "hpp", "py", "js", "html", "css", "xml",
            "json":
            // Text file
            return String(data: data, encoding: .utf8)
        case "pdf":
            // PDF file
            // TODO: Implement PDF text extraction
            return nil
        case "doc", "docx":
            // Word document
            // TODO: Implement Word text extraction
            return nil
        case "xls", "xlsx":
            // Excel spreadsheet
            // TODO: Implement Excel text extraction
            return nil
        case "ppt", "pptx":
            // PowerPoint presentation
            // TODO: Implement PowerPoint text extraction
            return nil
        default:
            return nil
        }
    }

    /// Tokenizes content into searchable tokens
    /// - Parameter content: The content to tokenize
    /// - Returns: An array of tokens
    private func tokenizeContent(content: String) -> [String] {
        // Split the content into words
        let words = content.components(separatedBy: .whitespacesAndNewlines)

        // Filter and normalize the words
        let tokens =
            words
            .filter { !$0.isEmpty }
            .map { $0.lowercased().trimmingCharacters(in: .punctuationCharacters) }
            .filter { $0.count >= 3 }

        // Remove duplicates
        return Array(Set(tokens))
    }

    /// Gets the context for a token in content
    /// - Parameters:
    ///   - content: The content
    ///   - token: The token
    /// - Returns: The context
    private func getContext(content: String, token: String) -> String {
        // Find the token in the content
        guard let range = content.range(of: token, options: .caseInsensitive) else { return "" }

        // Get the start and end indices
        let startIndex =
            content.index(range.lowerBound, offsetBy: -20, limitedBy: content.startIndex)
            ?? content.startIndex
        let endIndex =
            content.index(range.upperBound, offsetBy: 20, limitedBy: content.endIndex)
            ?? content.endIndex

        // Get the context
        let context = content[startIndex..<endIndex]

        return String(context)
    }
}

/// Represents a search result
public struct SearchResult: Identifiable, Hashable {
    /// Unique identifier for the result
    public let id: UUID

    /// The path to the file
    public let filePath: URL

    /// The file version
    public let version: FileVersion

    /// The matched token
    public let token: String

    /// The context around the token
    public let context: String

    /// The relevance score
    public var relevance: Double {
        // TODO: Implement relevance scoring
        // This is a placeholder for the actual implementation
        return 1.0
    }

    // MARK: - Hashable conformance
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    public static func == (lhs: SearchResult, rhs: SearchResult) -> Bool {
        return lhs.id == rhs.id
    }
}
