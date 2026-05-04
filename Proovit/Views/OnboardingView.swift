import SwiftUI
import SwiftData

struct OnboardingView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var name = ""

    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            Image(systemName: "camera.fill")
                .font(.system(size: 48))
                .foregroundColor(.green)

            Text("Proovit")
                .font(.largeTitle.bold())

            Text("Track your progress with photos")
                .font(.subheadline)
                .foregroundColor(.secondary)

            TextField("Your name", text: $name)
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal, 30)

            Button("Get Started") {
                startApp()
            }
            .buttonStyle(.borderedProminent)
            .tint(.green)
            .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty)

            Spacer()
        }
    }

    func startApp() {
        let trimmed = name.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return }
        print("creating profile for \(trimmed)")

        let profile = UserProfile(displayName: trimmed)
        modelContext.insert(profile)

        for tracker in SeedData.defaultTrackers() {
            modelContext.insert(tracker)
        }

        try? modelContext.save()
    }
}

#Preview {
    OnboardingView()
        .modelContainer(for: [Tracker.self, ProgressEntry.self, UserProfile.self], inMemory: true)
}
