import SwiftUI
import SwiftData

struct RootTabView: View {
    @Query private var profiles: [UserProfile]
    // using @Observable instead of ObservableObject (ios 17)
    @State private var scheduler = NotificationScheduler()
    @State private var showCamera = false

    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }

            CalendarView()
                .tabItem {
                    Label("Calendar", systemImage: "calendar")
                }

            Color.clear
                .tabItem {
                    Label("Camera", systemImage: "camera.fill")
                }
                .onAppear { showCamera = true } // placeholder tab that opens camera sheet

            CompareView()
                .tabItem {
                    Label("Compare", systemImage: "rectangle.split.2x1")
                }

            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
        }
        .tint(.green)
        .fullScreenCover(isPresented: $showCamera) {
            CameraView()
        }
        .environment(scheduler)
        .onAppear {
            Task {
                guard let profile = profiles.first else { return }
                scheduler.notificationsEnabled = profile.notificationsEnabled
                scheduler.reminderHour = profile.reminderHour
                scheduler.reminderMinute = profile.reminderMinute
                await scheduler.sync()
            }
        }
    }
}
