import SwiftUI

struct PreferencesView: View {
    @State private var selectedTab = 0
    @State private var autoVersionEnabled = true
    @State private var autoSnapshotEnabled = true
    @State private var snapshotFrequency: SnapshotFrequency = .daily
    @State private var retentionType: RetentionType = .keepLimited
    @State private var retentionCount = 10
    @State private var retentionDays = 30
    @State private var conflictResolutionStrategy: ConflictStrategy = .ask
    @State private var indexingEnabled = true

    // Storage settings
    @State private var storageManagementEnabled = true
    @State private var maxStorageGB: Double = 10.0
    @State private var maxVersionAgeDays = 365
    @State private var storageWarningThreshold: Double = 80.0
    @State private var autoCleanupEnabled = true
    @State private var cleanupFrequencyHours = 24
    @State private var storageNotificationsEnabled = true

    var body: some View {
        TabView(selection: $selectedTab) {
            // General tab
            GeneralPreferencesView(
                autoVersionEnabled: $autoVersionEnabled
            )
            .tabItem {
                Label("General", systemImage: "gear")
            }
            .tag(0)

            // Snapshots tab
            SnapshotPreferencesView(
                autoSnapshotEnabled: $autoSnapshotEnabled,
                snapshotFrequency: $snapshotFrequency,
                retentionType: $retentionType,
                retentionCount: $retentionCount,
                retentionDays: $retentionDays
            )
            .tabItem {
                Label("Snapshots", systemImage: "camera")
            }
            .tag(1)

            // Storage tab
            StoragePreferencesView(
                storageManagementEnabled: $storageManagementEnabled,
                maxStorageGB: $maxStorageGB,
                maxVersionAgeDays: $maxVersionAgeDays,
                storageWarningThreshold: $storageWarningThreshold,
                autoCleanupEnabled: $autoCleanupEnabled,
                cleanupFrequencyHours: $cleanupFrequencyHours,
                storageNotificationsEnabled: $storageNotificationsEnabled
            )
            .tabItem {
                Label("Storage", systemImage: "internaldrive")
            }
            .tag(2)

            // Advanced tab
            AdvancedPreferencesView(
                conflictResolutionStrategy: $conflictResolutionStrategy,
                indexingEnabled: $indexingEnabled
            )
            .tabItem {
                Label("Advanced", systemImage: "slider.horizontal.3")
            }
            .tag(3)
        }
        .padding(20)
        .frame(width: 500, height: 400)
    }
}

struct GeneralPreferencesView: View {
    @Binding var autoVersionEnabled: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("General")
                .font(.title)
                .padding(.bottom, 10)

            GroupBox(label: Text("Version Control")) {
                VStack(alignment: .leading, spacing: 10) {
                    Toggle("Automatically version files when changed", isOn: $autoVersionEnabled)
                        .padding(.vertical, 5)

                    Text(
                        "When enabled, Augment will automatically create a new version each time a file is modified."
                    )
                    .font(.caption)
                    .foregroundColor(.gray)
                }
                .padding(10)
            }

            Spacer()
        }
        .padding()
    }
}

struct SnapshotPreferencesView: View {
    @Binding var autoSnapshotEnabled: Bool
    @Binding var snapshotFrequency: SnapshotFrequency
    @Binding var retentionType: RetentionType
    @Binding var retentionCount: Int
    @Binding var retentionDays: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Snapshots")
                .font(.title)
                .padding(.bottom, 10)

            GroupBox(label: Text("Automated Snapshots")) {
                VStack(alignment: .leading, spacing: 10) {
                    Toggle("Enable automated snapshots", isOn: $autoSnapshotEnabled)
                        .padding(.vertical, 5)

                    if autoSnapshotEnabled {
                        Divider()

                        Text("Frequency")
                            .font(.headline)

                        Picker("", selection: $snapshotFrequency) {
                            Text("Hourly").tag(SnapshotFrequency.hourly)
                            Text("Daily").tag(SnapshotFrequency.daily)
                            Text("Weekly").tag(SnapshotFrequency.weekly)
                            Text("Monthly").tag(SnapshotFrequency.monthly)
                        }
                        .pickerStyle(SegmentedPickerStyle())

                        Divider()

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
                            .padding(.top, 5)
                        } else if retentionType == .keepForTime {
                            HStack {
                                Text("Keep for Days:")

                                Stepper("\(retentionDays)", value: $retentionDays, in: 1...365)
                            }
                            .padding(.top, 5)
                        }
                    }
                }
                .padding(10)
            }

            Spacer()
        }
        .padding()
    }
}

struct AdvancedPreferencesView: View {
    @Binding var conflictResolutionStrategy: ConflictStrategy
    @Binding var indexingEnabled: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Advanced")
                .font(.title)
                .padding(.bottom, 10)

            GroupBox(label: Text("Conflict Resolution")) {
                VStack(alignment: .leading, spacing: 10) {
                    Text("When a conflict is detected:")
                        .padding(.vertical, 5)

                    Picker("", selection: $conflictResolutionStrategy) {
                        Text("Ask me what to do").tag(ConflictStrategy.ask)
                        Text("Keep local version").tag(ConflictStrategy.keepLocal)
                        Text("Keep remote version").tag(ConflictStrategy.keepRemote)
                        Text("Keep both versions").tag(ConflictStrategy.keepBoth)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                .padding(10)
            }

            GroupBox(label: Text("Search & Indexing")) {
                VStack(alignment: .leading, spacing: 10) {
                    Toggle("Enable content indexing for search", isOn: $indexingEnabled)
                        .padding(.vertical, 5)

                    Text(
                        "When enabled, Augment will index file contents for faster searching. This may increase disk usage."
                    )
                    .font(.caption)
                    .foregroundColor(.gray)
                }
                .padding(10)
            }

            Spacer()
        }
        .padding()
    }
}

enum SnapshotFrequency {
    case hourly
    case daily
    case weekly
    case monthly
}

enum RetentionType {
    case keepAll
    case keepLimited
    case keepForTime
}

enum ConflictStrategy {
    case ask
    case keepLocal
    case keepRemote
    case keepBoth
}

// MARK: - Storage Preferences View

struct StoragePreferencesView: View {
    @Binding var storageManagementEnabled: Bool
    @Binding var maxStorageGB: Double
    @Binding var maxVersionAgeDays: Int
    @Binding var storageWarningThreshold: Double
    @Binding var autoCleanupEnabled: Bool
    @Binding var cleanupFrequencyHours: Int
    @Binding var storageNotificationsEnabled: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Storage Management")
                .font(.title)
                .padding(.bottom, 10)

            GroupBox(label: Text("Storage Limits")) {
                VStack(alignment: .leading, spacing: 15) {
                    Toggle("Enable storage management", isOn: $storageManagementEnabled)
                        .padding(.vertical, 5)

                    if storageManagementEnabled {
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Text("Maximum storage per space:")
                                Spacer()
                                TextField("GB", value: $maxStorageGB, format: .number)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .frame(width: 80)
                                Text("GB")
                            }

                            HStack {
                                Text("Warning threshold:")
                                Spacer()
                                TextField("%", value: $storageWarningThreshold, format: .number)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .frame(width: 80)
                                Text("%")
                            }

                            Text(
                                "Augment will warn you when storage usage exceeds this percentage."
                            )
                            .font(.caption)
                            .foregroundColor(.gray)
                        }
                        .padding(.leading, 20)
                    }
                }
                .padding(10)
            }

            GroupBox(label: Text("Automatic Cleanup")) {
                VStack(alignment: .leading, spacing: 15) {
                    Toggle("Enable automatic cleanup", isOn: $autoCleanupEnabled)
                        .padding(.vertical, 5)

                    if autoCleanupEnabled {
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Text("Remove versions older than:")
                                Spacer()
                                TextField("Days", value: $maxVersionAgeDays, format: .number)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .frame(width: 80)
                                Text("days")
                            }

                            HStack {
                                Text("Cleanup frequency:")
                                Spacer()
                                TextField("Hours", value: $cleanupFrequencyHours, format: .number)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .frame(width: 80)
                                Text("hours")
                            }

                            Text(
                                "Automatic cleanup runs in the background to maintain storage limits."
                            )
                            .font(.caption)
                            .foregroundColor(.gray)
                        }
                        .padding(.leading, 20)
                    }
                }
                .padding(10)
            }

            GroupBox(label: Text("Notifications")) {
                VStack(alignment: .leading, spacing: 10) {
                    Toggle("Show storage notifications", isOn: $storageNotificationsEnabled)
                        .padding(.vertical, 5)

                    Text("Receive notifications when storage limits are approached or exceeded.")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                .padding(10)
            }

            Spacer()
        }
        .padding()
    }
}
