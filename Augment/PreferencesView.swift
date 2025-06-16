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

            // Advanced tab
            AdvancedPreferencesView(
                conflictResolutionStrategy: $conflictResolutionStrategy,
                indexingEnabled: $indexingEnabled
            )
            .tabItem {
                Label("Advanced", systemImage: "slider.horizontal.3")
            }
            .tag(2)
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
