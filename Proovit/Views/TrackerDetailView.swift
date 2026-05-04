//
//  TrackerDetailView.swift
//  Proovit

import SwiftUI
import SwiftData

struct TrackerDetailView: View {
    let tracker: Tracker
    @Environment(\.modelContext) private var modelContext
    @State private var showCamera = false
    @State private var showEditSheet = false
    @State private var selectedDay: Date?
    @State private var showDaySheet = false

    private var sortedEntries: [ProgressEntry] {
        tracker.entries.sorted { $0.capturedAt > $1.capturedAt }
    }

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    // header
                    HStack(spacing: 8) {
                        Circle()
                            .fill(Theme.trackerColor(named: tracker.colorName))
                            .frame(width: 12, height: 12)
                        Text(tracker.name)
                            .font(.title2.bold())
                    }
                    .padding(.horizontal, 16)

                    // stats
                    HStack(spacing: 12) {
                        statCard(
                            value: "\(StreakCalculator.currentStreak(photoDates: tracker.entries.map { $0.capturedAt }))",
                            label: "Streak"
                        )
                        statCard(value: "\(tracker.entries.count)", label: "Photos")
                        statCard(value: "\(thisMonthCount)", label: "This Month")
                    }
                    .padding(.horizontal, 16)

                    // calendar
                    CalendarGridView(
                        entries: tracker.entries,
                        accentColor: Theme.trackerColor(named: tracker.colorName),
                        onDayTapped: { date in selectedDay = date; showDaySheet = true }
                    )
                    .padding(.horizontal, 16)

                    // photo grid
                    // TODO: add swipe to delete photos
                    if !sortedEntries.isEmpty {
                        Text("Photos")
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(.secondary)
                            .padding(.horizontal, 16)

                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 100), spacing: 4)], spacing: 4) {
                            ForEach(sortedEntries) { entry in
                                PhotoThumbnailView(filename: entry.photoFilename)
                                    .frame(height: 100)
                                    .clipShape(RoundedRectangle(cornerRadius: 6))
                            }
                        }
                        .padding(.horizontal, 15)
                    }
                }
                .padding(.vertical, 12)
            }

            // capture button at bottom
            Button {
                showCamera = true
            } label: {
                HStack {
                    Image(systemName: "camera.fill")
                    Text("Capture")
                }
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(14)
                .background(Theme.trackerColor(named: tracker.colorName))
                .cornerRadius(14)
                .padding(.horizontal, 16)
                .padding(.bottom, 8)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Edit") { showEditSheet = true }
            }
        }
        .fullScreenCover(isPresented: $showCamera) {
            CameraView()
        }
        .sheet(isPresented: $showEditSheet) {
            EditTrackerSheet(tracker: tracker)
        }
        .sheet(isPresented: $showDaySheet) {
            if let day = selectedDay {
                DayPhotosSheet(date: day, entries: entriesForDay(day))
            }
        }
    }

    // how many this month
    var thisMonthCount: Int {
        return tracker.entries.filter {
            Calendar.current.component(.month, from: $0.capturedAt) == Calendar.current.component(.month, from: Date()) &&
            Calendar.current.component(.year, from: $0.capturedAt) == Calendar.current.component(.year, from: Date())
        }.count
    }

    func entriesForDay(_ date: Date) -> [ProgressEntry] {
        tracker.entries.filter { Calendar.current.isDate($0.capturedAt, inSameDayAs: date) }
    }

    func statCard(value: String, label: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(value)
                .font(.title.bold())
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(10)
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
}
