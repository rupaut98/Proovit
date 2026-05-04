// NotificationScheduler.swift

import UserNotifications
import Observation
import Foundation

@Observable
class NotificationScheduler {

    var notificationsEnabled = false
    var reminderHour = 9
    var reminderMinute = 0

    let notifCenter = UNUserNotificationCenter.current()

    func sync() async {
        print("syncing notifications...")
        notifCenter.removePendingNotificationRequests(withIdentifiers: ["daily-reminder"])

        guard notificationsEnabled else { return }

        // ask for permission if we don't have it
        let granted = try? await notifCenter.requestAuthorization(options: [.alert, .sound])
        if granted != true { return }

        // schedule the notification
        let content = UNMutableNotificationContent()
        content.title = "Time for your progress photo"
        content.body = "Don't forget to take your progress photo today!"
        content.sound = .default

        var comps = DateComponents()
        comps.hour = reminderHour
        comps.minute = reminderMinute

        let trigger = UNCalendarNotificationTrigger(dateMatching: comps, repeats: true)
        let request = UNNotificationRequest(identifier: "daily-reminder", content: content, trigger: trigger)
        try? await notifCenter.add(request)
    }
}
