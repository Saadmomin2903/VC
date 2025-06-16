import SwiftUI

struct SearchView: View {
    @State private var searchQuery = ""
    @State private var searchResults: [SearchResult] = []
    @State private var selectedSpaces: Set<AugmentSpace> = []
    @State private var isSearching = false
    @State private var selectedResult: SearchResult?
    
    private let searchEngine = SearchEngine.shared
    
    var spaces: [AugmentSpace]
    
    var body: some View {
        VStack(spacing: 0) {
            // Search bar
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                
                TextField("Search in version history", text: $searchQuery)
                    .textFieldStyle(PlainTextFieldStyle())
                    .onSubmit {
                        performSearch()
                    }
                
                if !searchQuery.isEmpty {
                    Button(action: {
                        searchQuery = ""
                        searchResults = []
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                
                Button("Search") {
                    performSearch()
                }
                .buttonStyle(.borderedProminent)
                .disabled(searchQuery.isEmpty || selectedSpaces.isEmpty)
            }
            .padding()
            .background(Color(NSColor.textBackgroundColor))
            
            Divider()
            
            // Space selection
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(spaces) { space in
                        Toggle(space.name, isOn: Binding(
                            get: { selectedSpaces.contains(space) },
                            set: { isSelected in
                                if isSelected {
                                    selectedSpaces.insert(space)
                                } else {
                                    selectedSpaces.remove(space)
                                }
                            }
                        ))
                        .toggleStyle(.button)
                        .buttonStyle(.bordered)
                    }
                }
                .padding(.horizontal)
            }
            .padding(.vertical, 8)
            .background(Color(NSColor.windowBackgroundColor))
            
            Divider()
            
            // Results
            if isSearching {
                VStack {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .scaleEffect(2.0)
                        .padding()
                    
                    Text("Searching...")
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if searchResults.isEmpty {
                VStack {
                    if !searchQuery.isEmpty {
                        Image(systemName: "magnifyingglass")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 60, height: 60)
                            .foregroundColor(.gray)
                        
                        Text("No results found")
                            .font(.title2)
                            .padding()
                    } else {
                        Image(systemName: "doc.text.magnifyingglass")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 60, height: 60)
                            .foregroundColor(.gray)
                        
                        Text("Search across all versions")
                            .font(.title2)
                            .padding()
                        
                        Text("Enter a search term and select the spaces to search in.")
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .padding()
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                HStack(spacing: 0) {
                    // Results list
                    List(selection: $selectedResult) {
                        ForEach(searchResults) { result in
                            SearchResultRow(result: result)
                                .tag(result)
                        }
                    }
                    .frame(width: 300)
                    
                    Divider()
                    
                    // Result preview
                    if let result = selectedResult {
                        SearchResultPreview(result: result)
                    } else {
                        VStack {
                            Image(systemName: "doc.text.magnifyingglass")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 60, height: 60)
                                .foregroundColor(.gray)
                            
                            Text("Select a result to preview")
                                .font(.title2)
                                .padding()
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                }
            }
        }
        .frame(width: 800, height: 600)
        .onAppear {
            // Select all spaces by default
            selectedSpaces = Set(spaces)
        }
    }
    
    private func performSearch() {
        guard !searchQuery.isEmpty && !selectedSpaces.isEmpty else { return }
        
        isSearching = true
        
        // Perform the search
        DispatchQueue.global(qos: .userInitiated).async {
            let results = searchEngine.search(
                query: searchQuery,
                spacePaths: Array(selectedSpaces).map { $0.path }
            )
            
            DispatchQueue.main.async {
                searchResults = results
                isSearching = false
                selectedResult = nil
            }
        }
    }
}

struct SearchResultRow: View {
    let result: SearchResult
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(result.filePath.lastPathComponent)
                .font(.headline)
            
            Text(result.filePath.deletingLastPathComponent().lastPathComponent)
                .font(.subheadline)
                .foregroundColor(.gray)
            
            Text(highlightedContext)
                .font(.caption)
                .lineLimit(2)
                .padding(.top, 2)
        }
        .padding(.vertical, 4)
    }
    
    private var highlightedContext: AttributedString {
        var attributedString = AttributedString(result.context)
        
        if let range = attributedString.range(of: result.token, options: .caseInsensitive) {
            attributedString[range].backgroundColor = .yellow.opacity(0.5)
            attributedString[range].foregroundColor = .black
        }
        
        return attributedString
    }
}

struct SearchResultPreview: View {
    let result: SearchResult
    @State private var fileContent: String?
    @State private var image: NSImage?
    @State private var isTextFile: Bool = true
    
    var body: some View {
        VStack {
            // Header
            HStack {
                VStack(alignment: .leading) {
                    Text(result.filePath.lastPathComponent)
                        .font(.headline)
                    
                    Text("Version: \(formattedDate(result.version.timestamp))")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                Button("Open in Finder") {
                    NSWorkspace.shared.selectFile(result.filePath.path, inFileViewerRootedAtPath: "")
                }
                .buttonStyle(.bordered)
                
                Button("View Version History") {
                    // TODO: Open version history
                }
                .buttonStyle(.bordered)
            }
            .padding()
            
            Divider()
            
            // Content
            if isTextFile {
                if let content = fileContent {
                    ScrollView {
                        Text(highlightedContent(content))
                            .font(.system(.body, design: .monospaced))
                            .padding()
                    }
                } else {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .scaleEffect(2.0)
                }
            } else {
                if let image = image {
                    Image(nsImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding()
                } else {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .scaleEffect(2.0)
                }
            }
        }
        .onAppear {
            loadFileContent()
        }
    }
    
    private func loadFileContent() {
        // Determine if it's a text file
        let fileExtension = result.filePath.pathExtension.lowercased()
        isTextFile = ["txt", "md", "swift", "java", "c", "cpp", "h", "hpp", "py", "js", "html", "css", "xml", "json"].contains(fileExtension)
        
        // Load the file content
        DispatchQueue.global(qos: .userInitiated).async {
            if let data = try? Data(contentsOf: result.version.storagePath) {
                DispatchQueue.main.async {
                    if isTextFile {
                        fileContent = String(data: data, encoding: .utf8)
                    } else {
                        image = NSImage(data: data)
                    }
                }
            }
        }
    }
    
    private func highlightedContent(_ content: String) -> AttributedString {
        var attributedString = AttributedString(content)
        
        let token = result.token.lowercased()
        var searchRange = attributedString.startIndex..<attributedString.endIndex
        
        while let range = attributedString[searchRange].range(of: token, options: .caseInsensitive) {
            attributedString[range].backgroundColor = .yellow.opacity(0.5)
            attributedString[range].foregroundColor = .black
            
            if range.upperBound < attributedString.endIndex {
                searchRange = range.upperBound..<attributedString.endIndex
            } else {
                break
            }
        }
        
        return attributedString
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}
