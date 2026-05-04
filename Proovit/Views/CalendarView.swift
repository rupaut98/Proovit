import SwiftUI
import SwiftData

struct CalendarView: View {
    @Query(sort: \Tracker.sortOrder) private var trackers: [Tracker]
    @Query(sort: \ProgressEntry.capturedAt, order: .reverse) private var allEntries: [ProgressEntry]
    @State private var selectedTracker: Tracker?
    @State private var selectedDay: Date?
    @State private var showDaySheet = false

    var filteredEntries: [ProgressEntry] {
        if let tracker = selectedTracker {
            return allEntries.filter { $0.tracker?.id == tracker.id }
        }
        return allEntries
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    // filter chips
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            chipButton(label: "All", color: nil, isSelected: selectedTracker == nil) {
                                selectedTracker = nil
                            }
                            ForEach(trackers) { tracker in
                                chipButton(
                                    label: tracker.name,
                                    color: Theme.trackerColor(named: tracker.colorName),
                                    isSelected: selectedTracker?.id == tracker.id
                                ) {
                                    selectedTracker = tracker
                                }
                            }
                        }
                        .padding(.horizontal, 16)
                    }

                    CalendarGridView(
                        entries: filteredEntries,
                        accentColor: selectedTracker != nil ? Theme.trackerColor(named: selectedTracker!.colorName) : .green,
                        onDayTapped: { date in selectedDay = date; showDaySheet = true }
                    )
                    .padding(.horizontal, 20)
                }
                .padding(.top, 12)
            }
            .navigationTitle("Calendar")
            .sheet(isPresented: $showDaySheet) {
                if let day = selectedDay {
                    DayPhotosSheet(
                        date: day,
                        entries: filteredEntries.filter { Calendar.current.isDate($0.capturedAt, inSameDayAs: day) }
                    )
                }
            }
        }
    }

    // reusable chip button for the filter bar
    private func chipButton(label: String, color: Color?, isSelected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 4) {
                if let color {
                    Circle().fill(isSelected ? .white : color).frame(width: 8, height: 8)
                }
                Text(label).font(.body.weight(.medium))
            }
            .foregroundColor(isSelected ? .white : Color(.label))
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(Capsule().fill(isSelected ? Color.green : Color(.systemGray6)))
        }
        .buttonStyle(.plain)
    }
}
