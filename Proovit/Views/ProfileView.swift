import SwiftUI
import SwiftData

struct ProfileView: View {
    @Query private var entries: [ProgressEntry]
    @Query private var profiles: [UserProfile]
    @Query private var trackers: [Tracker]
    @Environment(NotificationScheduler.self) private var scheduler
    @State private var showEditProfile = false
    @State private var reminderTime = Date()

    var profile: UserProfile? { profiles.first }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    // profile card
                    if let profile {
                        VStack(spacing: 8) {
                            AvatarView(initials: profile.initials, size: 64)
                            Text(profile.displayName)
                                .font(.title2.bold())
                            Text("Member since \(formatDate(profile.createdAt))")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .padding(20)
                    }

                    // stats
                    HStack(spacing: 12) {
                        statCard(value: "\(entries.count)", label: "Photos")
                        statCard(value: "\(trackers.count)", label: "Trackers")
                    }
                    .padding(.horizontal, 15)

                    // settings
                    VStack(spacing: 0) {
                        settingsRow(icon: "person.fill", title: "Edit Profile") {
                            showEditProfile = true
                        }

                        Divider().padding(.leading, 44)

                        // notifications toggle
                        if let profile {
                            // need @Bindable to use $ with the model
                            @Bindable var p = profile
                            HStack {
                                Image(systemName: "bell.fill")
                                    .frame(width: 24)
                                    .foregroundColor(.green)
                                Toggle("Notifications", isOn: $p.notificationsEnabled)
                            }
                            .padding(12)
                            .onChange(of: profile.notificationsEnabled) {
                                scheduler.notificationsEnabled = profile.notificationsEnabled
                                Task { await scheduler.sync() }
                            }

                            if profile.notificationsEnabled {
                                Divider().padding(.leading, 44)
                                HStack {
                                    Image(systemName: "clock.fill")
                                        .frame(width: 24)
                                        .foregroundColor(.green)
                                    Text("Reminder Time")
                                    Spacer()
                                    DatePicker("", selection: $reminderTime, displayedComponents: .hourAndMinute)
                                        .labelsHidden()
                                        .onChange(of: reminderTime) {
                                            let comps = Calendar.current.dateComponents([.hour, .minute], from: reminderTime)
                                            profile.reminderHour = comps.hour ?? 9
                                            profile.reminderMinute = comps.minute ?? 0
                                            scheduler.reminderHour = profile.reminderHour
                                            scheduler.reminderMinute = profile.reminderMinute
                                            Task { await scheduler.sync() }
                                        }
                                }
                                .padding(12)
                            }
                        }
                    }
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    .padding(.horizontal, 16)
                }
                .padding(.vertical, 12)
                .onAppear {
                    if let p = profile {
                        reminderTime = Calendar.current.date(from: DateComponents(hour: p.reminderHour, minute: p.reminderMinute)) ?? Date()
                    }
                }
            }
            .navigationTitle("Profile")
            .sheet(isPresented: $showEditProfile) {
                if let profile {
                    EditProfileSheet(profile: profile)
                }
            }
        }
    }

    func statCard(value: String, label: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(value)
                .font(.title2.bold())
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12)
        .background(Color(.systemGray6))
        .cornerRadius(14)
    }

    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }

    // settings row helper
    func settingsRow(icon: String, title: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .frame(width: 24)
                    .foregroundColor(.green)
                Text(title)
                    .foregroundColor(Color(.label))
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(12)
        }
    }
}
