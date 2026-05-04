//
//  ProovitApp.swift
//  Proovit

import SwiftUI
import SwiftData

@main
struct ProovitApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [Tracker.self, ProgressEntry.self, UserProfile.self])
    }
}
