//
//  SettingsView.swift
//  diabetes-app
//
//  Created by Tyler Keller on 7/21/25.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        VStack {
            Text("Settings Screen")
            Button("Test Missed Bolus Notification") {
                NotificationManager.shared.scheduleMissedBolusNotification()
            }
            .padding()
        }
    }
}

