//
//  diabetes_appApp.swift
//  diabetes-app
//
//  Created by Tyler Keller on 7/21/25.
//

import SwiftUI
import HealthKit

@main
struct diabetes_appApp: App {
    init() {
        HealthKitManager.shared.requestAuthorization { _, _ in }
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
