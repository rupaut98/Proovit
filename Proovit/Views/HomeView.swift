import SwiftUI
import SwiftData
import Foundation

struct HomeView: View {
    @Query(sort: \Tracker.sortOrder) private var trackers: [Tracker]
    @Query(sort: \ProgressEntry.capturedAt, order: .reverse) private var recentEntries: [ProgressEntry]
    @Query private var profiles: [UserProfile]
    @State var showAddTracker = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    // show greeting
                    if let profile = profiles.first {
                        Text("Hey, \(profile.displayName)")
                            .font(.title2.bold())
                            .padding(.horizontal, 16)
                    }

                    // trackers
                    Text("My Trackers")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.secondary)
                        .padding(.horizontal, 16)

                    ForEach(trackers) { tracker in
                        NavigationLink(destination: TrackerDetailView(tracker: tracker)) {
                            trackerRow(tracker)
                        }
                        .buttonStyle(.plain)
                    }

                    // add tracker button
                    Button {
                        showAddTracker = true
                    } label: {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                            Text("Add Tracker")
                        }
                        .foregroundColor(.green)
                        .padding(12)
                        .frame(maxWidth: .infinity)
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                    }
                    .padding(.horizontal, 16)

                    // recent entries
                    if !recentEntries.isEmpty {
                        Text("Recent")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .padding(.horizontal, 16)

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                ForEach(recentEntries.prefix(10)) { entry in
                                    PhotoThumbnailView(filename: entry.photoFilename)
                                        .frame(width: 80, height: 100)
                                        .clipShape(RoundedRectangle(cornerRadius: 8))
                                }
                            }
                            .padding(.horizontal, 16)
                        }
                    }
                }
                .padding(.vertical, 12)
            }
            .onAppear {
                print("loaded \(trackers.count) trackers")
            }
            .background(Color(.systemBackground))
            .navigationTitle("Proovit")
            .sheet(isPresented: $showAddTracker) {
                EditTrackerSheet()
            }
        }
    }

    private func trackerRow(_ tracker: Tracker) -> some View {
        HStack(spacing: 12) {
            Circle()
                .fill(Theme.trackerColor(named: tracker.colorName))
                .frame(width: 10, height: 10)

            Image(systemName: tracker.iconName)
                .foregroundColor(Theme.trackerColor(named: tracker.colorName))
                .frame(width: 24)

            Text(tracker.name)
                .font(.body)
                .foregroundColor(Color(.label))

            Spacer()

            let streak = StreakCalculator.currentStreak(photoDates: tracker.entries.map { $0.capturedAt })
            if streak > 0 {
                HStack(spacing: 4) {
                    Image(systemName: "flame.fill")
                        .foregroundColor(.orange)
                    Text("\(streak)")
                        .font(.caption.bold())
                }
            }

            Text("\(tracker.entries.count) photos")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(12)
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .padding(.horizontal, 15)
    }
}

#Preview {
    HomeView()
        .modelContainer(for: [Tracker.self, ProgressEntry.self, UserProfile.self], inMemory: true)
}
