import SwiftUI
import SwiftData
import Foundation

struct CompareView: View {
    @Query(sort: \Tracker.sortOrder) private var trackers: [Tracker]
    @State private var selectedTracker: Tracker?
    @State private var mode = 0 // 0 = side by side, 1 = reel

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                // tracker chips
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(trackers) { tracker in
                            Button {
                                selectedTracker = tracker
                            } label: {
                                HStack(spacing: 4) {
                                    Circle()
                                        .fill(selectedTracker?.id == tracker.id ? .white : Theme.trackerColor(named: tracker.colorName))
                                        .frame(width: 6, height: 6)
                                    Text(tracker.name)
                                        .font(.body.weight(.medium))
                                }
                                .foregroundColor(selectedTracker?.id == tracker.id ? .white : Color(.label))
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .background(
                                    Capsule().fill(selectedTracker?.id == tracker.id ? Color.green : Color(.systemGray6))
                                )
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal, 16)
                }

                Picker("Mode", selection: $mode) {
                    Text("Side by Side").tag(0)
                    Text("Progress Reel").tag(1)
                }
                .pickerStyle(.segmented)
                .padding(.horizontal, 16)

                if mode == 0 {
                    sideBySideView()
                } else {
                    // coming soon placeholder
                    VStack(spacing: 16) {
                        Image(systemName: "play.rectangle.fill")
                            .font(.system(size: 48))
                            .foregroundColor(.green)
                        Text("Progress Reel")
                            .font(.title2.bold())
                        Text("Coming soon — your photos will be turned into a timelapse video.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding(20)
                    .frame(maxWidth: .infinity)
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    .padding(.horizontal, 16)
                }

                Spacer()
            }
            .padding(.top, 12)
            .navigationTitle("Compare")
        }
    }

    func dateText(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }

    // first vs last photo
    @ViewBuilder func sideBySideView() -> some View {
        if let tracker = selectedTracker, tracker.entries.count >= 2 {
            let sorted = tracker.entries.sorted { $0.capturedAt < $1.capturedAt }
            let first = sorted.first
            let last = sorted.last

            HStack(spacing: 8) {
                if let first {
                    VStack {
                        PhotoThumbnailView(filename: first.photoFilename)
                            .frame(height: 200)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                        Text(dateText(first.capturedAt))
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                if let last {
                    VStack {
                        PhotoThumbnailView(filename: last.photoFilename)
                            .frame(height: 200)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                        Text(dateText(last.capturedAt))
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .padding(.horizontal, 16)
        } else {
            VStack(spacing: 12) {
                Image(systemName: "photo.on.rectangle")
                    .font(.system(size: 48))
                    .foregroundColor(.secondary)
                Text(selectedTracker == nil ? "Select a tracker to compare" : "Need at least 2 photos to compare")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity)
            .padding(30)
        }
    }
}
