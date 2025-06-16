import SwiftUI

struct BackupView: View {
    let space: AugmentSpace
    @State private var configuration: BackupConfiguration?
    @State private var backups: [URL] = []
    @State private var selectedBackup: URL?
    @State private var isEnabled = true
    @State private var backupPath = ""
    @State private var frequency: BackupFrequency = .daily
    @State private var retentionType: RetentionType = .keepLimited
    @State private var retentionCount = 10
    @State private var retentionDays = 30
    @State private var isEncrypted = false
    @State private var password = ""
    @State private var isCreatingBackup = false
    @State private var isRestoringBackup = false
    @State private var isEditingConfiguration = false
    @State private var restorePassword = ""
    
    private let backupManager = BackupManager.shared
    
    var body: some View {
        VStack(spacing: 0) {
            // Toolbar
            HStack {
                Text("Backups: \(space.name)")
                    .font(.headline)
                
                Spacer()
                
                if configuration != nil {
                    Button(action: {
                        createBackup()
                    }) {
                        Text("Create Backup")
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(isCreatingBackup)
                }
                
                Button(action: {
                    isEditingConfiguration = true
                }) {
                    if configuration == nil {
                        Text("Configure Backup")
                    } else {
                        Text("Edit Configuration")
                    }
                }
                .buttonStyle(.bordered)
            }
            .padding()
            .background(Color(NSColor.windowBackgroundColor))
            
            Divider()
            
            // Content
            if configuration == nil {
                VStack {
                    Image(systemName: "archivebox")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 60, height: 60)
                        .foregroundColor(.gray)
                    
                    Text("No backup configuration")
                        .font(.title2)
                        .padding()
                    
                    Text("Configure backups to protect your space from data loss.")
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding()
                    
                    Button("Configure Backup") {
                        isEditingConfiguration = true
                    }
                    .buttonStyle(.borderedProminent)
                    .padding()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                HStack(spacing: 0) {
                    // Backups list
                    VStack(spacing: 0) {
                        // Header
                        HStack {
                            Text("Backups")
                                .font(.headline)
                            
                            Spacer()
                            
                            Button(action: {
                                loadBackups()
                            }) {
                                Image(systemName: "arrow.clockwise")
                            }
                            .buttonStyle(.plain)
                        }
                        .padding()
                        
                        Divider()
                        
                        // List
                        if backups.isEmpty {
                            VStack {
                                Text("No backups yet")
                                    .foregroundColor(.gray)
                                    .padding()
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                        } else {
                            List(selection: $selectedBackup) {
                                ForEach(backups, id: \.self) { backup in
                                    BackupRow(backup: backup)
                                        .tag(backup)
                                        .contextMenu {
                                            Button("Restore Backup") {
                                                selectedBackup = backup
                                                isRestoringBackup = true
                                            }
                                            
                                            Divider()
                                            
                                            Button("Delete Backup") {
                                                deleteBackup(backup)
                                            }
                                            .foregroundColor(.red)
                                        }
                                }
                            }
                        }
                    }
                    .frame(width: 300)
                    
                    Divider()
                    
                    // Configuration details
                    ScrollView {
                        VStack(alignment: .leading, spacing: 20) {
                            // Status
                            GroupBox(label: Text("Backup Status")) {
                                VStack(alignment: .leading, spacing: 10) {
                                    HStack {
                                        Text("Status:")
                                        
                                        if isCreatingBackup {
                                            Text("Creating backup...")
                                                .foregroundColor(.blue)
                                        } else if configuration?.isEnabled ?? false {
                                            Text("Enabled")
                                                .foregroundColor(.green)
                                        } else {
                                            Text("Disabled")
                                                .foregroundColor(.red)
                                        }
                                        
                                        Spacer()
                                        
                                        Toggle("", isOn: $isEnabled)
                                            .labelsHidden()
                                            .onChange(of: isEnabled) { newValue in
                                                updateConfigurationEnabled(enabled: newValue)
                                            }
                                    }
                                    
                                    if let lastBackup = configuration?.lastBackupTimestamp {
                                        Text("Last Backup: \(formattedDate(lastBackup))")
                                    } else {
                                        Text("Last Backup: Never")
                                    }
                                }
                                .padding(10)
                            }
                            .padding(.horizontal)
                            
                            // Configuration
                            GroupBox(label: Text("Backup Configuration")) {
                                VStack(alignment: .leading, spacing: 10) {
                                    HStack {
                                        Text("Backup Path:")
                                        Text(configuration?.backupPath.path ?? "")
                                            .foregroundColor(.gray)
                                    }
                                    
                                    HStack {
                                        Text("Frequency:")
                                        Text(frequencyText(configuration?.frequency ?? .daily))
                                            .foregroundColor(.gray)
                                    }
                                    
                                    HStack {
                                        Text("Retention:")
                                        Text(retentionText(configuration?.retention ?? .keepAll))
                                            .foregroundColor(.gray)
                                    }
                                    
                                    HStack {
                                        Text("Encryption:")
                                        Text(configuration?.isEncrypted ?? false ? "Enabled" : "Disabled")
                                            .foregroundColor(.gray)
                                    }
                                }
                                .padding(10)
                            }
                            .padding(.horizontal)
                        }
                        .padding(.vertical)
                    }
                }
            }
        }
        .frame(width: 800, height: 500)
        .onAppear {
            loadConfiguration()
            loadBackups()
        }
        .sheet(isPresented: $isEditingConfiguration) {
            EditBackupConfigurationView(
                spacePath: URL(fileURLWithPath: space.path),
                backupPath: $backupPath,
                frequency: $frequency,
                retentionType: $retentionType,
                retentionCount: $retentionCount,
                retentionDays: $retentionDays,
                isEncrypted: $isEncrypted,
                password: $password,
                isEnabled: $isEnabled,
                onSaveConfiguration: saveConfiguration,
                onCancel: { isEditingConfiguration = false }
            )
        }
        .sheet(isPresented: $isRestoringBackup) {
            if let backup = selectedBackup, configuration?.isEncrypted ?? false {
                RestoreBackupView(
                    backup: backup,
                    spacePath: URL(fileURLWithPath: space.path),
                    password: $restorePassword,
                    onRestore: restoreBackup,
                    onCancel: { isRestoringBackup = false }
                )
            }
        }
        .alert("Restore Backup", isPresented: $isRestoringBackup) {
            if !(configuration?.isEncrypted ?? false) {
                Button("Cancel", role: .cancel) {
                    isRestoringBackup = false
                }
                Button("Restore", role: .destructive) {
                    if let backup = selectedBackup {
                        restoreBackup(backup: backup, password: nil)
                    }
                }
            }
        } message: {
            if !(configuration?.isEncrypted ?? false) {
                Text("Are you sure you want to restore this backup? This will replace all files in the space with the contents of the backup.")
            }
        }
    }
    
    private func loadConfiguration() {
        // Load the configuration from the backup manager
        configuration = backupManager.getConfiguration(spacePath: URL(fileURLWithPath: space.path))
        
        if let config = configuration {
            // Set the form values
            backupPath = config.backupPath.path
            frequency = config.frequency
            isEnabled = config.isEnabled
            isEncrypted = config.isEncrypted
            password = config.password ?? ""
            
            // Set the retention type and values
            switch config.retention {
            case .keepAll:
                retentionType = .keepAll
            case .keepLimited(let count):
                retentionType = .keepLimited
                retentionCount = count
            case .keepForTime(let time):
                retentionType = .keepForTime
                retentionDays = Int(time / (60 * 60 * 24)) // Convert seconds to days
            }
        } else {
            // Set default values
            backupPath = ""
            frequency = .daily
            retentionType = .keepLimited
            retentionCount = 10
            retentionDays = 30
            isEnabled = true
            isEncrypted = false
            password = ""
        }
    }
    
    private func loadBackups() {
        guard let config = configuration else { return }
        
        // Get the backup path
        let backupPath = config.backupPath
        
        // Check if the directory exists
        guard FileManager.default.fileExists(atPath: backupPath.path) else {
            backups = []
            return
        }
        
        // Get all backup files
        guard let backupFiles = try? FileManager.default.contentsOfDirectory(at: backupPath, includingPropertiesForKeys: nil) else {
            backups = []
            return
        }
        
        // Filter for backup files
        let filteredBackups = backupFiles.filter { $0.lastPathComponent.hasPrefix("backup-") }
        
        // Sort by date (newest first)
        backups = filteredBackups.sorted { (lhs, rhs) -> Bool in
            let lhsAttributes = try? FileManager.default.attributesOfItem(atPath: lhs.path)
            let rhsAttributes = try? FileManager.default.attributesOfItem(atPath: rhs.path)
            
            let lhsDate = lhsAttributes?[.creationDate] as? Date ?? Date.distantPast
            let rhsDate = rhsAttributes?[.creationDate] as? Date ?? Date.distantPast
            
            return lhsDate > rhsDate
        }
    }
    
    private func saveConfiguration() {
        // Create the retention policy
        let retention: BackupRetention
        switch retentionType {
        case .keepAll:
            retention = .keepAll
        case .keepLimited:
            retention = .keepLimited(retentionCount)
        case .keepForTime:
            retention = .keepForTime(TimeInterval(retentionDays * 24 * 60 * 60)) // Convert days to seconds
        }
        
        // Create the configuration
        let newConfiguration = BackupConfiguration(
            id: configuration?.id ?? UUID(),
            spacePath: URL(fileURLWithPath: space.path),
            backupPath: URL(fileURLWithPath: backupPath),
            frequency: frequency,
            retention: retention,
            isEncrypted: isEncrypted,
            password: isEncrypted ? password : nil,
            isEnabled: isEnabled,
            lastBackupTimestamp: configuration?.lastBackupTimestamp
        )
        
        // Save the configuration
        _ = backupManager.addConfiguration(newConfiguration)
        
        // Update the local configuration
        configuration = newConfiguration
        
        // Close the sheet
        isEditingConfiguration = false
    }
    
    private func updateConfigurationEnabled(enabled: Bool) {
        guard var config = configuration else { return }
        
        // Update the configuration
        config.isEnabled = enabled
        
        // Save the configuration
        _ = backupManager.addConfiguration(config)
        
        // Update the local configuration
        configuration = config
    }
    
    private func createBackup() {
        // Set creating backup state
        isCreatingBackup = true
        
        // Create the backup
        DispatchQueue.global(qos: .userInitiated).async {
            _ = backupManager.createBackup(spacePath: URL(fileURLWithPath: space.path))
            
            // Reload backups
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                loadBackups()
                loadConfiguration() // To update the last backup timestamp
                isCreatingBackup = false
            }
        }
    }
    
    private func restoreBackup(backup: URL, password: String?) {
        // Restore the backup
        _ = backupManager.restoreBackup(
            backupPath: backup,
            spacePath: URL(fileURLWithPath: space.path),
            password: password
        )
        
        // Close the sheet
        isRestoringBackup = false
        restorePassword = ""
    }
    
    private func deleteBackup(_ backup: URL) {
        // Delete the backup file
        try? FileManager.default.removeItem(at: backup)
        
        // Reload backups
        loadBackups()
    }
    
    private func frequencyText(_ frequency: BackupFrequency) -> String {
        switch frequency {
        case .manual:
            return "Manual"
        case .hourly:
            return "Hourly"
        case .daily:
            return "Daily"
        case .weekly:
            return "Weekly"
        }
    }
    
    private func retentionText(_ retention: BackupRetention) -> String {
        switch retention {
        case .keepAll:
            return "Keep All Backups"
        case .keepLimited(let count):
            return "Keep \(count) Backups"
        case .keepForTime(let time):
            let days = Int(time / (60 * 60 * 24))
            return "Keep Backups for \(days) Days"
        }
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

struct BackupRow: View {
    let backup: URL
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(backupName)
                .font(.headline)
            
            Text(formattedDate)
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding(.vertical, 4)
    }
    
    private var backupName: String {
        let name = backup.lastPathComponent
        if name.hasPrefix("backup-") {
            let startIndex = name.index(name.startIndex, offsetBy: 7)
            let endIndex = name.index(name.endIndex, offsetBy: -4)
            if startIndex < endIndex {
                return String(name[startIndex..<endIndex])
            }
        }
        return name
    }
    
    private var formattedDate: String {
        guard let attributes = try? FileManager.default.attributesOfItem(atPath: backup.path) else {
            return "Unknown date"
        }
        
        guard let creationDate = attributes[.creationDate] as? Date else {
            return "Unknown date"
        }
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: creationDate)
    }
}

struct EditBackupConfigurationView: View {
    let spacePath: URL
    @Binding var backupPath: String
    @Binding var frequency: BackupFrequency
    @Binding var retentionType: RetentionType
    @Binding var retentionCount: Int
    @Binding var retentionDays: Int
    @Binding var isEncrypted: Bool
    @Binding var password: String
    @Binding var isEnabled: Bool
    let onSaveConfiguration: () -> Void
    let onCancel: () -> Void
    
    @State private var isSelectingBackupPath = false
    @State private var confirmPassword = ""
    @State private var passwordsMatch = false
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Backup Configuration")
                .font(.headline)
            
            Form {
                // Backup path
                VStack(alignment: .leading) {
                    Text("Backup Path")
                        .font(.headline)
                    
                    HStack {
                        TextField("Backup Path", text: $backupPath)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        Button("Browse...") {
                            isSelectingBackupPath = true
                        }
                    }
                }
                .padding(.vertical, 8)
                
                // Frequency
                VStack(alignment: .leading) {
                    Text("Backup Frequency")
                        .font(.headline)
                    
                    Picker("", selection: $frequency) {
                        Text("Manual").tag(BackupFrequency.manual)
                        Text("Hourly").tag(BackupFrequency.hourly)
                        Text("Daily").tag(BackupFrequency.daily)
                        Text("Weekly").tag(BackupFrequency.weekly)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                .padding(.vertical, 8)
                
                // Retention
                VStack(alignment: .leading) {
                    Text("Retention Policy")
                        .font(.headline)
                    
                    Picker("", selection: $retentionType) {
                        Text("Keep All Backups").tag(RetentionType.keepAll)
                        Text("Keep Limited Number").tag(RetentionType.keepLimited)
                        Text("Keep for Time Period").tag(RetentionType.keepForTime)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    
                    if retentionType == .keepLimited {
                        HStack {
                            Text("Number of Backups:")
                            
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
                
                // Encryption
                VStack(alignment: .leading) {
                    Toggle("Encrypt Backups", isOn: $isEncrypted)
                    
                    if isEncrypted {
                        SecureField("Password", text: $password)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.top, 8)
                        
                        SecureField("Confirm Password", text: $confirmPassword)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.top, 4)
                            .onChange(of: confirmPassword) { _ in
                                passwordsMatch = password == confirmPassword
                            }
                            .onChange(of: password) { _ in
                                passwordsMatch = password == confirmPassword
                            }
                        
                        if !password.isEmpty && !confirmPassword.isEmpty && !passwordsMatch {
                            Text("Passwords do not match")
                                .foregroundColor(.red)
                                .font(.caption)
                                .padding(.top, 4)
                        }
                    }
                }
                .padding(.vertical, 8)
                
                // Enabled
                Toggle("Enable Backup", isOn: $isEnabled)
                    .padding(.vertical, 8)
                
                HStack {
                    Spacer()
                    
                    Button("Cancel") {
                        onCancel()
                    }
                    .keyboardShortcut(.escape)
                    
                    Button("Save") {
                        onSaveConfiguration()
                    }
                    .keyboardShortcut(.return)
                    .disabled(backupPath.isEmpty || (isEncrypted && (!passwordsMatch || password.isEmpty)))
                }
            }
            .padding()
        }
        .frame(width: 500)
        .fileImporter(
            isPresented: $isSelectingBackupPath,
            allowedContentTypes: [.folder],
            allowsMultipleSelection: false
        ) { result in
            if case .success(let urls) = result, let url = urls.first {
                backupPath = url.path
            }
        }
    }
}

struct RestoreBackupView: View {
    let backup: URL
    let spacePath: URL
    @Binding var password: String
    let onRestore: (URL, String) -> Void
    let onCancel: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Restore Encrypted Backup")
                .font(.headline)
            
            Text("This backup is encrypted. Please enter the password to restore it.")
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
            
            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.top, 8)
            
            Text("Warning: Restoring a backup will replace all files in the space with the contents of the backup.")
                .foregroundColor(.orange)
                .font(.caption)
                .multilineTextAlignment(.center)
                .padding(.top, 8)
            
            HStack {
                Button("Cancel") {
                    onCancel()
                }
                .keyboardShortcut(.escape)
                
                Spacer()
                
                Button("Restore") {
                    onRestore(backup, password)
                }
                .keyboardShortcut(.return)
                .disabled(password.isEmpty)
            }
            .padding(.top, 8)
        }
        .padding()
        .frame(width: 400)
    }
}
