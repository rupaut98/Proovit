//
//  SeedData.swift
//  Proovit

import Foundation

// default trackers to add when user first opens the app
struct SeedData {
    static func defaultTrackers() -> [Tracker] {
        return [
            Tracker(name: "Fitness", colorName: "Forest", iconName: "figure.run", sortOrder: 0),
            Tracker(name: "Skincare", colorName: "Lilac", iconName: "drop.fill", sortOrder: 1),
            Tracker(name: "Hair", colorName: "Amber", iconName: "scissors", sortOrder: 2)
        ]
    }
}
