//
//  Tracker.swift
//  Proovit

import SwiftData
import Foundation

@Model
class Tracker {
    var id: UUID
    var name: String
    var colorName: String
    var iconName: String
    var sortOrder: Int
    var createdAt: Date
    // need this so entries get deleted when tracker is removed - found in apple docs
    @Relationship(deleteRule: .cascade, inverse: \ProgressEntry.tracker)
    var entries: [ProgressEntry]

    init(name: String, colorName: String = "Forest", iconName: String = "figure.run", sortOrder: Int = 0) {
        self.id = UUID()
        self.name = name
        self.colorName = colorName
        self.iconName = iconName
        self.sortOrder = sortOrder
        self.createdAt = Date()
        self.entries = []
    }
}
