import SwiftUI

struct SnapshotView: View {
    let space: AugmentSpace
    @State private var snapshots: [Snapshot] = []
    @State private var selectedSnapshot: Snapshot?
    @State private var isCreatingSnapshot = false
    @State private var newSnapshotName = ""
    @State private var newSnapshotDescription = ""
    @State private var isConfirmingRestore = false
    @State private var isConfirmingDelete = false
    @State private var isEditingSchedule = false
    @State private var schedule: SnapshotSchedule?
    @State private var selectedFrequency: SnapshotFrequency = .daily
    @State private var selectedRetention: RetentionType = .keepAll
    @State private var retentionCount = 10
    @State private var retentionDays = 30
    @State private var isScheduleEnabled = true
    
    private let snapshotManager = SnapshotManager.shared
    
    var body: some View {
        VStack(spacing: 0) {
            // Toolbar
            HStack {
                Text("Snapshots: \(space.name)")
                    .font(.headline)
                
                Spacer()
                
                Button(action: {
                    loadSnapshots()
                }) {
                    Image(systemName: "arrow.clockwise")
                }
                
                Button("Schedule...") {
                    loadSchedule()
                    isEditingSchedule = true
                }
                .buttonStyle(.bordered)
                
                Button("Create Snapshot") {
                    isCreatingSnapshot = true
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
            .background(Color(NSColor.windowBackgroundColor))
            
            Divider()
            
            // Content
            if snapshots.isEmpty {
                VStack {
                    Image(systemName: "camera")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 60, height: 60)
                        .foregroundColor(.gray)
                    
                    Text("No snapshots yet")
                        .font(.title2)
                        .padding()
                    
                    Text("Create a snapshot to save the current state of your space.")
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding()
                    
                    Button("Create Snapshot") {
                        isCreatingSnapshot = true
                    }
                    .buttonStyle(.borderedProminent)
                    .padding()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                HStack(spacing: 0) {
                    // Snapshots list
                    List(selection: $selectedSnapshot) {
                        ForEach(snapshots) { snapshot in
                            SnapshotRow(snapshot: snapshot)
                                .tag(snapshot)
                                .contextMenu {
                                    Button("Restore Snapshot") {
                                        selectedSnapshot = snapshot
                                        isConfirmingRestore = true
                                    }
                                    
                                    Divider()
                                    
                                    Button("Delete Snapshot") {
                                        selectedSnapshot = snapshot
                                        isConfirmingDelete = true
                                    }
                                    .foregroundColor(.red)
                                }
                        }
                    }
                    .frame(width: 300)
                    
                    Divider()
                    
                    // Snapshot details
                    if let snapshot = selectedSnapshot {
                        SnapshotDetailView(snapshot: snapshot)
                    } else {
                        VStack {
                            Image(systemName: "camera")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 60, height: 60)
                                .foregroundColor(.gray)
                            
                            Text("Select a snapshot to view details")
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
            loadSnapshots()
        }
        .sheet(isPresented: $isCreatingSnapshot) {
            CreateSnapshotView(
                spacePath: URL(fileURLWithPath: space.path),
                name: $newSnapshotName,
                description: $newSnapshotDescription,
                onCreateSnapshot: createSnapshot,
                onCancel: { isCreatingSnapshot = false }
            )
        }
        .sheet(isPresented: $isEditingSchedule) {
            EditScheduleView(
                spacePath: URL(fileURLWithPath: space.path),
                frequency: $selectedFrequency,
                retentionType: $selectedRetention,
                retentionCount: $retentionCount,
                retentionDays: $retentionDays,
                isEnabled: $isScheduleEnabled,
                onSaveSchedule: saveSchedule,
                onCancel: { isEditingSchedule = false }
            )
        }
        .alert("Restore Snapshot", isPresented: $isConfirmingRestore) {
            Button("Cancel", role: .cancel) {}
            Button("Restore", role: .destructive) {
                restoreSnapshot()
            }
        } message: {
            Text("Are you sure you want to restore this snapshot? This will revert all files in the space to their state at the time of the snapshot.")
        }
        .alert("Delete Snapshot", isPresented: $isConfirmingDelete) {
            Button("Cancel", role: .cancel) {}
            Button("Delete", role: .destructive) {
                deleteSnapshot()
            }
        } message: {
            Text("Are you sure you want to delete this snapshot? This action cannot be undone.")
        }
    }
    
    private func loadSnapshots() {
        // Load snapshots from the snapshot manager
        snapshots = snapshotManager.getSnapshots(spacePath: URL(fileURLWithPath: space.path))
    }
    
    private func createSnapshot() {
        // Create a new snapshot
        if let snapshot = snapshotManager.createSnapshot(
            spacePath: URL(fileURLWithPath: space.path),
            name: newSnapshotName,
            description: newSnapshotDescription.isEmpty ? nil : newSnapshotDescription
        ) {
            // Add the snapshot to the list
            snapshots.insert(snapshot, at: 0)
            
            // Select the new snapshot
            selectedSnapshot = snapshot
        }
        
        // Reset the form
        newSnapshotName = ""
        newSnapshotDescription = ""
        isCreatingSnapshot = false
    }
    
    private func restoreSnapshot() {
        guard let snapshot = selectedSnapshot else { return }
        
        // Restore the snapshot
        let success = snapshotManager.restoreSnapshot(snapshot: snapshot)
        
        if success {
            // Reload snapshots
            loadSnapshots()
        }
    }
    
    private func deleteSnapshot() {
        guard let snapshot = selectedSnapshot else { return }
        
        // Delete the snapshot
        let success = snapshotManager.deleteSnapshot(snapshot: snapshot)
        
        if success {
            // Remove the snapshot from the list
            snapshots.removeAll { $0.id == snapshot.id }
            
            // Deselect the snapshot
            selectedSnapshot = nil
        }
    }
    
    private func loadSchedule() {
        // Load the schedule from the snapshot manager
        schedule = snapshotManager.getSchedule(spacePath: URL(fileURLWithPath: space.path))
        
        if let schedule = schedule {
            // Set the form values
            selectedFrequency = schedule.frequency
            isScheduleEnabled = schedule.isEnabled
            
            // Set the retention type and values
            switch schedule.retention {
            case .keepAll:
                selectedRetention = .keepAll
            case .keepLimited(let count):
                selectedRetention = .keepLimited
                retentionCount = count
            case .keepForTime(let time):
                selectedRetention = .keepForTime
                retentionDays = Int(time / (60 * 60 * 24)) // Convert seconds to days
            }
        } else {
            // Set default values
            selectedFrequency = .daily
            selectedRetention = .keepLimited
            retentionCount = 10
            retentionDays = 30
            isScheduleEnabled = true
        }
    }
    
    private func saveSchedule() {
        // Create the retention policy
        let retention: SnapshotRetention
        switch selectedRetention {
        case .keepAll:
            retention = .keepAll
        case .keepLimited:
            retention = .keepLimited(retentionCount)
        case .keepForTime:
            retention = .keepForTime(TimeInterval(retentionDays * 24 * 60 * 60)) // Convert days to seconds
        }
        
        // Create or update the schedule
        if let existingSchedule = schedule {
            // Create a new schedule with the same ID
            let updatedSchedule = SnapshotSchedule(
                id: existingSchedule.id,
                spacePath: URL(fileURLWithPath: space.path),
                frequency: selectedFrequency,
                retention: retention,
                isEnabled: isScheduleEnabled,
                lastSnapshotTimestamp: existingSchedule.lastSnapshotTimestamp
            )
            
            // Save the schedule
            _ = snapshotManager.scheduleSnapshots(spacePath: URL(fileURLWithPath: space.path), schedule: updatedSchedule)
        } else {
            // Create a new schedule
            let newSchedule = SnapshotSchedule(
                id: UUID(),
                spacePath: URL(fileURLWithPath: space.path),
                frequency: selectedFrequency,
                retention: retention,
                isEnabled: isScheduleEnabled
            )
            
            // Save the schedule
            _ = snapshotManager.scheduleSnapshots(spacePath: URL(fileURLWithPath: space.path), schedule: newSchedule)
        }
        
        // Close the sheet
        isEditingSchedule = false
    }
}

struct SnapshotRow: View {
    let snapshot: Snapshot
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(snapshot.name)
                .font(.headline)
            
            Text(formattedDate)
                .font(.subheadline)
                .foregroundColor(.gray)
            
            if let description = snapshot.description, !description.isEmpty {
                Text(description)
                    .font(.caption)
                    .foregroundColor(.gray)
                    .lineLimit(2)
                    .padding(.top, 2)
            }
        }
        .padding(.vertical, 4)
    }
    
    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: snapshot.timestamp)
    }
}

struct SnapshotDetailView: View {
    let snapshot: Snapshot
    @State private var searchText = ""
    
    var body: some View {
        VStack {
            // Header
            VStack(alignment: .leading, spacing: 8) {
                Text(snapshot.name)
                    .font(.title2)
                
                Text("Created: \(formattedDate)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                if let description = snapshot.description, !description.isEmpty {
                    Text(description)
                        .font(.body)
                        .padding(.top, 4)
                }
                
                Text("\(snapshot.files.count) files")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(8)
            .padding()
            
            // Search
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                
                TextField("Search files", text: $searchText)
                    .textFieldStyle(PlainTextFieldStyle())
                
                if !searchText.isEmpty {
                    Button(action: {
                        searchText = ""
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(8)
            .background(Color(NSColor.textBackgroundColor))
            .cornerRadius(8)
            .padding(.horizontal)
            
            // Files list
            List {
                ForEach(filteredFiles) { file in
                    SnapshotFileRow(file: file)
                }
            }
            .listStyle(PlainListStyle())
        }
    }
    
    private var filteredFiles: [SnapshotFile] {
        if searchText.isEmpty {
            return snapshot.files
        } else {
            return snapshot.files.filter { file in
                file.relativePath.lowercased().contains(searchText.lowercased())
            }
        }
    }
    
    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: snapshot.timestamp)
    }
}

struct SnapshotFileRow: View {
    let file: SnapshotFile
    
    var body: some View {
        HStack {
            Image(systemName: iconName)
                .foregroundColor(iconColor)
            
            VStack(alignment: .leading) {
                Text(fileName)
                    .font(.headline)
                
                Text(filePath)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Text(formattedSize)
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding(.vertical, 4)
    }
    
    private var fileName: String {
        return URL(fileURLWithPath: file.relativePath).lastPathComponent
    }
    
    private var filePath: String {
        return URL(fileURLWithPath: file.relativePath).deletingLastPathComponent().path
    }
    
    private var iconName: String {
        let fileExtension = URL(fileURLWithPath: file.relativePath).pathExtension.lowercased()
        
        switch fileExtension {
        case "txt", "md":
            return "doc.text"
        case "swift", "java", "c", "cpp", "h", "hpp", "py", "js", "html", "css", "xml", "json":
            return "chevron.left.forwardslash.chevron.right"
        case "jpg", "jpeg", "png", "gif", "bmp", "tiff", "heic":
            return "photo"
        case "pdf":
            return "doc.text.viewfinder"
        case "doc", "docx":
            return "doc"
        case "xls", "xlsx":
            return "tablecells"
        case "ppt", "pptx":
            return "chart.bar"
        default:
            return "doc"
        }
    }
    
    private var iconColor: Color {
        let fileExtension = URL(fileURLWithPath: file.relativePath).pathExtension.lowercased()
        
        switch fileExtension {
        case "txt", "md":
            return .blue
        case "swift", "java", "c", "cpp", "h", "hpp", "py", "js", "html", "css", "xml", "json":
            return .purple
        case "jpg", "jpeg", "png", "gif", "bmp", "tiff", "heic":
            return .green
        case "pdf":
            return .red
        case "doc", "docx":
            return .blue
        case "xls", "xlsx":
            return .green
        case "ppt", "pptx":
            return .orange
        default:
            return .gray
        }
    }
    
    private var formattedSize: String {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = [.useKB, .useMB, .useGB]
        formatter.countStyle = .file
        return formatter.string(fromByteCount: Int64(file.size))
    }
}

struct CreateSnapshotView: View {
    let spacePath: URL
    @Binding var name: String
    @Binding var description: String
    let onCreateSnapshot: () -> Void
    let onCancel: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Create Snapshot")
                .font(.headline)
            
            Form {
                TextField("Snapshot Name", text: $name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                TextField("Description (optional)", text: $description)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                HStack {
                    Spacer()
                    
                    Button("Cancel") {
                        onCancel()
                    }
                    .keyboardShortcut(.escape)
                    
                    Button("Create") {
                        onCreateSnapshot()
                    }
                    .keyboardShortcut(.return)
                    .disabled(name.isEmpty)
                }
            }
            .padding()
        }
        .frame(width: 400)
        .onAppear {
            // Set a default name based on the current date
            if name.isEmpty {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                name = "Snapshot - \(dateFormatter.string(from: Date()))"
            }
        }
    }
}

enum RetentionType {
    case keepAll
    case keepLimited
    case keepForTime
}

struct EditScheduleView: View {
    let spacePath: URL
    @Binding var frequency: SnapshotFrequency
    @Binding var retentionType: RetentionType
    @Binding var retentionCount: Int
    @Binding var retentionDays: Int
    @Binding var isEnabled: Bool
    let onSaveSchedule: () -> Void
    let onCancel: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Snapshot Schedule")
                .font(.headline)
            
            Form {
                // Enabled toggle
                Toggle("Enable Automated Snapshots", isOn: $isEnabled)
                    .toggleStyle(.switch)
                
                // Frequency
                VStack(alignment: .leading) {
                    Text("Frequency")
                        .font(.headline)
                    
                    Picker("", selection: $frequency) {
                        Text("Hourly").tag(SnapshotFrequency.hourly)
                        Text("Daily").tag(SnapshotFrequency.daily)
                        Text("Weekly").tag(SnapshotFrequency.weekly)
                        Text("Monthly").tag(SnapshotFrequency.monthly)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                .padding(.vertical, 8)
                
                // Retention
                VStack(alignment: .leading) {
                    Text("Retention Policy")
                        .font(.headline)
                    
                    Picker("", selection: $retentionType) {
                        Text("Keep All Snapshots").tag(RetentionType.keepAll)
                        Text("Keep Limited Number").tag(RetentionType.keepLimited)
                        Text("Keep for Time Period").tag(RetentionType.keepForTime)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    
                    if retentionType == .keepLimited {
                        HStack {
                            Text("Number of Snapshots:")
                            
                            Stepper("\(retentionCount)", value: $retentionCount, in: 1...100)
                        }
                        .padding(.top, 8)
                    } else if retentionType == .keepForTime {
                        HStack {
                            Text("Keep for Days:")
                            
                            Stepper("\(retentionDays)", value: $retentionDays, in: 1...365)
                        }
                        .padding(.top, 8)
                    }
                }
                .padding(.vertical, 8)
                
                HStack {
                    Spacer()
                    
                    Button("Cancel") {
                        onCancel()
                    }
                    .keyboardShortcut(.escape)
                    
                    Button("Save") {
                        onSaveSchedule()
                    }
                    .keyboardShortcut(.return)
                }
            }
            .padding()
        }
        .frame(width: 400)
    }
}
