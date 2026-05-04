//
//  UserProfile.swift
//  Proovit

import SwiftData
import Foundation

@Model
class UserProfile {
    var id: UUID
    var displayName: String
    var reminderHour: Int
    var reminderMinute: Int
    var notificationsEnabled: Bool
    var createdAt: Date

    // get initials for avatar
    var initials: String {
        let words = displayName.split(separator: " ")
        var result = ""
        for word in words.prefix(2) {
            if let first = word.first {
                result += String(first)
            }
        }
        return result.uppercased()
    }

    init(displayName: String) {
        self.id = UUID()
        self.displayName = displayName
        self.reminderHour = 9
        self.reminderMinute = 0
        self.notificationsEnabled = false
        self.createdAt = Date()
    }
}
