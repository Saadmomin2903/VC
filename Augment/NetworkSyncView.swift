import SwiftUI

struct NetworkSyncView: View {
    let space: AugmentSpace
    @State private var configuration: SyncConfiguration?
    @State private var isEnabled = true
    @State private var remotePath = ""
    @State private var direction: SyncDirection = .bidirectional
    @State private var frequency: SyncFrequency = .daily
    @State private var isSyncing = false
    @State private var lastSyncDate: Date?
    @State private var isEditingConfiguration = false
    
    private let networkSync = NetworkSync.shared
    
    var body: some View {
        VStack(spacing: 0) {
            // Toolbar
            HStack {
                Text("Network Sync: \(space.name)")
                    .font(.headline)
                
                Spacer()
                
                if configuration != nil {
                    Button(action: {
                        syncNow()
                    }) {
                        Text("Sync Now")
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(isSyncing)
                }
                
                Button(action: {
                    isEditingConfiguration = true
                }) {
                    if configuration == nil {
                        Text("Configure Sync")
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
                    Image(systemName: "arrow.triangle.2.circlepath.circle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 60, height: 60)
                        .foregroundColor(.gray)
                    
                    Text("No sync configuration")
                        .font(.title2)
                        .padding()
                    
                    Text("Configure network synchronization to keep your space in sync with another location.")
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding()
                    
                    Button("Configure Sync") {
                        isEditingConfiguration = true
                    }
                    .buttonStyle(.borderedProminent)
                    .padding()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let config = configuration {
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        // Status
                        GroupBox(label: Text("Sync Status")) {
                            VStack(alignment: .leading, spacing: 10) {
                                HStack {
                                    Text("Status:")
                                    
                                    if isSyncing {
                                        Text("Syncing...")
                                            .foregroundColor(.blue)
                                    } else if config.isEnabled {
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
                                
                                if let lastSync = lastSyncDate {
                                    Text("Last Sync: \(formattedDate(lastSync))")
                                } else {
                                    Text("Last Sync: Never")
                                }
                            }
                            .padding(10)
                        }
                        .padding(.horizontal)
                        
                        // Configuration
                        GroupBox(label: Text("Sync Configuration")) {
                            VStack(alignment: .leading, spacing: 10) {
                                HStack {
                                    Text("Remote Path:")
                                    Text(config.remotePath.path)
                                        .foregroundColor(.gray)
                                }
                                
                                HStack {
                                    Text("Direction:")
                                    Text(directionText(config.direction))
                                        .foregroundColor(.gray)
                                }
                                
                                HStack {
                                    Text("Frequency:")
                                    Text(frequencyText(config.frequency))
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
        .frame(width: 600, height: 400)
        .onAppear {
            loadConfiguration()
        }
        .sheet(isPresented: $isEditingConfiguration) {
            EditSyncConfigurationView(
                spacePath: URL(fileURLWithPath: space.path),
                remotePath: $remotePath,
                direction: $direction,
                frequency: $frequency,
                isEnabled: $isEnabled,
                onSaveConfiguration: saveConfiguration,
                onCancel: { isEditingConfiguration = false }
            )
        }
    }
    
    private func loadConfiguration() {
        // Load the configuration from the network sync manager
        configuration = networkSync.getConfiguration(spacePath: URL(fileURLWithPath: space.path))
        
        if let config = configuration {
            // Set the form values
            remotePath = config.remotePath.path
            direction = config.direction
            frequency = config.frequency
            isEnabled = config.isEnabled
            lastSyncDate = config.lastSyncTimestamp
        } else {
            // Set default values
            remotePath = ""
            direction = .bidirectional
            frequency = .daily
            isEnabled = true
            lastSyncDate = nil
        }
    }
    
    private func saveConfiguration() {
        // Create the configuration
        let newConfiguration = SyncConfiguration(
            id: configuration?.id ?? UUID(),
            spacePath: URL(fileURLWithPath: space.path),
            remotePath: URL(fileURLWithPath: remotePath),
            direction: direction,
            frequency: frequency,
            isEnabled: isEnabled,
            lastSyncTimestamp: configuration?.lastSyncTimestamp
        )
        
        // Save the configuration
        _ = networkSync.addConfiguration(newConfiguration)
        
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
        _ = networkSync.addConfiguration(config)
        
        // Update the local configuration
        configuration = config
    }
    
    private func syncNow() {
        guard let config = configuration else { return }
        
        // Set syncing state
        isSyncing = true
        
        // Sync the space
        DispatchQueue.global(qos: .userInitiated).async {
            _ = networkSync.syncSpace(spacePath: URL(fileURLWithPath: space.path))
            
            // Update the last sync date
            DispatchQueue.main.async {
                lastSyncDate = Date()
                isSyncing = false
            }
        }
    }
    
    private func directionText(_ direction: SyncDirection) -> String {
        switch direction {
        case .localToRemote:
            return "Local to Remote"
        case .remoteToLocal:
            return "Remote to Local"
        case .bidirectional:
            return "Bidirectional"
        }
    }
    
    private func frequencyText(_ frequency: SyncFrequency) -> String {
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
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

struct EditSyncConfigurationView: View {
    let spacePath: URL
    @Binding var remotePath: String
    @Binding var direction: SyncDirection
    @Binding var frequency: SyncFrequency
    @Binding var isEnabled: Bool
    let onSaveConfiguration: () -> Void
    let onCancel: () -> Void
    
    @State private var isSelectingRemotePath = false
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Sync Configuration")
                .font(.headline)
            
            Form {
                // Remote path
                VStack(alignment: .leading) {
                    Text("Remote Path")
                        .font(.headline)
                    
                    HStack {
                        TextField("Remote Path", text: $remotePath)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        Button("Browse...") {
                            isSelectingRemotePath = true
                        }
                    }
                }
                .padding(.vertical, 8)
                
                // Direction
                VStack(alignment: .leading) {
                    Text("Sync Direction")
                        .font(.headline)
                    
                    Picker("", selection: $direction) {
                        Text("Local to Remote").tag(SyncDirection.localToRemote)
                        Text("Remote to Local").tag(SyncDirection.remoteToLocal)
                        Text("Bidirectional").tag(SyncDirection.bidirectional)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                .padding(.vertical, 8)
                
                // Frequency
                VStack(alignment: .leading) {
                    Text("Sync Frequency")
                        .font(.headline)
                    
                    Picker("", selection: $frequency) {
                        Text("Manual").tag(SyncFrequency.manual)
                        Text("Hourly").tag(SyncFrequency.hourly)
                        Text("Daily").tag(SyncFrequency.daily)
                        Text("Weekly").tag(SyncFrequency.weekly)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                .padding(.vertical, 8)
                
                // Enabled
                Toggle("Enable Sync", isOn: $isEnabled)
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
                    .disabled(remotePath.isEmpty)
                }
            }
            .padding()
        }
        .frame(width: 500)
        .fileImporter(
            isPresented: $isSelectingRemotePath,
            allowedContentTypes: [.folder],
            allowsMultipleSelection: false
        ) { result in
            if case .success(let urls) = result, let url = urls.first {
                remotePath = url.path
            }
        }
    }
}
