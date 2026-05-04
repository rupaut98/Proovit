import SwiftUI

struct CalendarGridView: View {
    let entries: [ProgressEntry]
    var accentColor: Color = .green
    var onDayTapped: ((Date) -> Void)?

    @State private var displayedMonth = Date()
    private let calendar = Calendar.current

    let weekdays = ["S", "M", "T", "W", "T", "F", "S"]

    // calculate the days in the current month
    var monthDays: [Date?] {
        guard let range = calendar.range(of: .day, in: .month, for: displayedMonth),
              let firstOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: displayedMonth))
        else { return [] }

        let firstWeekday = calendar.component(.weekday, from: firstOfMonth)
        let offset = (firstWeekday - calendar.firstWeekday + 7) % 7

        var days: [Date?] = Array(repeating: nil, count: offset)
        for day in range {
            if let date = calendar.date(byAdding: .day, value: day - 1, to: firstOfMonth) {
                days.append(date)
            }
        }
        return days
    }

    var body: some View {
        VStack(spacing: 8) {
            // arrows to go between months
            HStack {
                Button { changeMonth(by: -1) } label: {
                    Image(systemName: "chevron.left")
                }
                Spacer()
                Text(monthYearString())
                    .font(.headline)
                Spacer()
                Button { changeMonth(by: 1) } label: {
                    Image(systemName: "chevron.right")
                }
            }

            HStack(spacing: 4) {
                ForEach(weekdays, id: \.self) { day in
                    Text(day)
                        .font(.caption2)
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity)
                }
            }

            let columns = Array(repeating: GridItem(.flexible(), spacing: 4), count: 7)
            LazyVGrid(columns: columns, spacing: 4) {
                ForEach(Array(monthDays.enumerated()), id: \.offset) { _, date in
                    if let date {
                        let hasEntry = entries.contains { calendar.isDate($0.capturedAt, inSameDayAs: date) }
                        let isToday = calendar.isDateInToday(date)

                        Button {
                            onDayTapped?(date)
                        } label: {
                            Text("\(calendar.component(.day, from: date))")
                                .font(.caption)
                                .frame(maxWidth: .infinity)
                                .frame(height: 36)
                                .background(hasEntry ? accentColor.opacity(0.15) : Color.clear)
                                .overlay {
                                    if isToday {
                                        RoundedRectangle(cornerRadius: 6)
                                            .stroke(accentColor, lineWidth: 1)
                                    }
                                }
                                .cornerRadius(6)
                        }
                        .buttonStyle(.plain)
                    } else {
                        Color.clear.frame(height: 36)
                    }
                }
            }
        }
        .padding(12)
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }

    func monthYearString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: displayedMonth)
    }

    func changeMonth(by value: Int) {
        if let newMonth = calendar.date(byAdding: .month, value: value, to: displayedMonth) {
            displayedMonth = newMonth
        }
    }
}
