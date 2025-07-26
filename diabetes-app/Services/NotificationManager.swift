import Foundation
import UserNotifications

class NotificationManager {
    static let shared = NotificationManager()
    private init() {
        configureActions()
    }

    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { _, _ in
            // Permission response can be handled here if needed
        }
    }

    private func configureActions() {
        let confirm = UNNotificationAction(identifier: "CONFIRM_ACTION",
                                           title: "Confirm",
                                           options: [.foreground])
        let deny = UNNotificationAction(identifier: "DENY_ACTION",
                                        title: "Deny",
                                        options: [.destructive])
        let category = UNNotificationCategory(identifier: "MISSED_BOLUS_CATEGORY",
                                              actions: [confirm, deny],
                                              intentIdentifiers: [],
                                              options: [])
        UNUserNotificationCenter.current().setNotificationCategories([category])
    }

    func scheduleMissedBolusNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Possible Missed Meal Bolus"
        content.body = "Have you taken your bolus for the recent meal?"
        content.sound = .default
        content.categoryIdentifier = "MISSED_BOLUS_CATEGORY"

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString,
                                            content: content,
                                            trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
}
