//
//  DummyCGMData.swift
//  diabetes-app
//
//  Created by Tyler Keller on 7/21/25.
//

import Foundation
import Combine


class DummyCGMData: ObservableObject {
    @Published var readings: [EGVReading] = []

    private var timer: Timer?

    init() {
        startGenerating()
    }

    func startGenerating() {
        timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { _ in
            DispatchQueue.main.async {
                let now = Date()
                let value = Int.random(in: 80...180)
                let trendOptions = ["Flat", "SingleUp", "SingleDown", "DoubleUp", "DoubleDown", "FortyFiveUp", "FortyFiveDown"]
                let trend = trendOptions.randomElement()!
                let trendRate = Double.random(in: -3.0...3.0)

                let reading = EGVReading(
                    systemTime: now,
                    displayTime: Calendar.current.date(byAdding: .minute, value: -5, to: now)!,
                    value: value,
                    trend: trend,
                    trendRate: trendRate
                )

                self.readings.append(reading)
                if self.readings.count > 36 { // ~3 hours of 5-min data
                    self.readings.removeFirst()
                }
            }
        }
    }

    deinit {
        timer?.invalidate()
    }
}
