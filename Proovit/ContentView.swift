import SwiftUI
import SwiftData

struct ContentView: View {
    @Query var profiles: [UserProfile]

    var body: some View {
        if profiles.isEmpty {
            OnboardingView()
        } else {
            RootTabView()
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [Tracker.self, ProgressEntry.self, UserProfile.self], inMemory: true)
}
