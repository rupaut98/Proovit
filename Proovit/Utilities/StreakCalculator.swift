//
//  StreakCalculator.swift
//  Proovit

import Foundation

enum StreakCalculator {

    static func currentStreak(photoDates: [Date]) -> Int {
        let calendar = Calendar.current
        let allDays = photoDates.map { calendar.startOfDay(for: $0) }
        let uniqueDays = Array(Set(allDays)).sorted()
        guard let lastDay = uniqueDays.last else { return 0 }

        let today = calendar.startOfDay(for: Date())
        let daysSinceLast = calendar.dateComponents([.day], from: lastDay, to: today).day ?? 0

        if daysSinceLast > 1 { return 0 }

        var streak = 1
        // count backwards through the days
        var i = uniqueDays.count - 2
        var previous = lastDay
        while i >= 0 {
            let diff = calendar.dateComponents([.day], from: uniqueDays[i], to: previous).day ?? 0
            if diff == 1 {
                streak += 1
                previous = uniqueDays[i]
            } else {
                break
            }
            i -= 1
        }
        return streak
    }
}
