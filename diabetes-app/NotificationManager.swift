import Foundation
import UserNotifications

class NotificationManager {
    static let shared = NotificationManager()
    private init() {}

    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, error in
            if let error = error {
                print("Notification permission error: \(error.localizedDescription)")
            } else if granted {
                self.scheduleNightlyReminder()
            }
        }
    }

    func scheduleNightlyReminder() {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: ["nightlyReminder"])

        var components = DateComponents()
        components.hour = 20
        components.minute = 0

        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)

        let content = UNMutableNotificationContent()
        content.title = "Update Today's Meals"
        content.body = "Please log any meals you missed recording today."
        content.sound = .default

        let request = UNNotificationRequest(identifier: "nightlyReminder", content: content, trigger: trigger)
        center.add(request) { error in
            if let error = error {
                print("Error scheduling nightly reminder: \(error)")
            }
        }
    }
}
