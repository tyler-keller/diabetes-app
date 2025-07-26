//
//  HomeView.swift
//  diabetes-app
//
//  Created by Tyler Keller on 7/21/25.
//

import SwiftUI
import HealthKit

struct HomeView: View {
    @StateObject private var cgmData = DummyCGMData()
    @State private var hkReadings: [EGVReading] = []
    @State private var usingHealthKit = false

    var body: some View {
        VStack {
            Text("Latest CGM Reading")
                .font(.headline)

            if let latest = (usingHealthKit ? hkReadings.last : cgmData.readings.last) {
                Text("\(latest.value) mg/dL")
                    .font(.largeTitle)
                    .bold()
                    .padding()
                Text("Trend: \(latest.trend) (\(String(format: "%.1f", latest.trendRate)) mg/dL/min)")
                    .foregroundColor(.gray)
            } else {
                Text("No data yet")
            }
            
            Text("Live CGM Scatter Plot")
                .font(.headline)
                .padding(.leading)

            CGMChartView(readings: usingHealthKit ? hkReadings : cgmData.readings)
        }
        .onAppear {
            HealthKitManager.shared.requestAuthorization { success, _ in
                guard success else { return }
                HealthKitManager.shared.fetchRecentGlucoseSamples { samples in
                    DispatchQueue.main.async {
                        self.hkReadings = samples
                        self.usingHealthKit = true
                    }
                }
            }
        }
    }
}
