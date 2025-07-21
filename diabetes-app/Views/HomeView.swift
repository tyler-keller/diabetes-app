//
//  HomeView.swift
//  diabetes-app
//
//  Created by Tyler Keller on 7/21/25.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var cgmData = DummyCGMData()

    var body: some View {
        VStack {
            Text("Latest CGM Reading")
                .font(.headline)

            if let latest = cgmData.readings.last {
                Text("\(latest.value) mg/dL")
                    .font(.largeTitle)
                    .bold()
                    .padding()
                Text("Trend: \(latest.trend) (\(String(format: "%.1f", latest.trendRate)) mg/dL/min)")
                    .foregroundColor(.gray)
            } else {
                Text("No data yet")
            }
        }
    }
}

#Preview {
    HomeView()
}
