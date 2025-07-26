//
//  diabetes_appApp.swift
//  diabetes-app
//
//  Created by Tyler Keller on 7/21/25.
//

import SwiftUI

// Notification support
import UserNotifications

@main
struct diabetes_appApp: App {
    init() {
        NotificationManager.shared.requestAuthorization()
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
