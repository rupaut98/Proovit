//
//  Theme.swift
//  Proovit

import SwiftUI

enum Theme {
    static let accent = Color("Accent")
    static let background = Color("Background")
    static let surface = Color("Surface")
    static let textPrimary = Color("TextPrimary")
    static let textSecondary = Color("TextSecondary")

    static let trackerPalette: [TrackerColor] = [
        TrackerColor(displayName: "Forest", assetName: "Forest"),
        TrackerColor(displayName: "Lilac", assetName: "Lilac"),
        TrackerColor(displayName: "Amber", assetName: "Amber"),
        TrackerColor(displayName: "Coral", assetName: "Coral"),
        TrackerColor(displayName: "Slate", assetName: "Slate"),
        TrackerColor(displayName: "Plum", assetName: "Plum")
    ]

    static func trackerColor(named name: String) -> Color {
        return Color(name)
    }

    static let trackerSymbols: [String] = [
        "figure.run", "drop.fill", "scissors", "leaf.fill",
        "moon.stars.fill", "heart.fill", "dumbbell.fill", "camera.fill"
    ]
}

struct TrackerColor: Identifiable, Hashable {
    let displayName: String
    let assetName: String
    var id: String { return assetName }
    var color: Color { Color(assetName) }
}
