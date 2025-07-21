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
    private let trendOptions = ["Flat", "SingleUp", "SingleDown", "DoubleUp", "DoubleDown", "FortyFiveUp", "FortyFiveDown"]
    
    init() {
        generateInitialData()
        startGenerating()
    }

    private func generateInitialData() {
        let now = Date()

        for i in (0..<36).reversed() {
            let timestamp = Calendar.current.date(byAdding: .minute, value: -5 * i, to: now)!
            let reading = generateRandomReading(for: timestamp, previousReading: readings.last)
            readings.append(reading)
        }
    }

    private func generateRandomReading(for time: Date, previousReading: EGVReading? = nil) -> EGVReading {
        let nextValue: Int
        let nextTrend: String
        let nextTrendRate: Double

        if let prev = previousReading {
            // simulate value based on previous value and trend rate
            var delta = prev.trendRate * 5.0 // rate is mg/dL per minute
            let current = Double(prev.value)
            
            // add reversion force toward normal range
            if current < 80 {
                let force = min((80 - current) * 0.4, 10) // max +10 bump
                delta += force
            } else if current > 180 {
                let force = min((current - 180) * 0.4, 10) // max -10 drop
                delta -= force
            }
            
            let noisyDelta = delta + Double.random(in: -5...5)
            let rawNext = current + noisyDelta
            nextValue = max(40, min(400, Int(rawNext))) // bound values

            // decide on trend based on delta
            switch noisyDelta {
            case ..<(-3):
                nextTrend = "DoubleDown"
            case -3..<(-1.5):
                nextTrend = "SingleDown"
            case -1.5..<(-0.5):
                nextTrend = "FortyFiveDown"
            case -0.5...0.5:
                nextTrend = "Flat"
            case 0.5..<1.5:
                nextTrend = "FortyFiveUp"
            case 1.5..<3:
                nextTrend = "SingleUp"
            default:
                nextTrend = "DoubleUp"
            }

            nextTrendRate = noisyDelta / 5.0
        } else {
            // first reading – random initialization
            nextValue = Int.random(in: 80...180)
            nextTrend = self.trendOptions.randomElement()!
            nextTrendRate = Double.random(in: -3.0...3.0)
        }

        return EGVReading(
            systemTime: time,
            displayTime: Calendar.current.date(byAdding: .minute, value: -5, to: time)!,
            value: nextValue,
            trend: nextTrend,
            trendRate: nextTrendRate
        )
    }

    func startGenerating() {
        timer = Timer.scheduledTimer(withTimeInterval: 300, repeats: true) { _ in
            DispatchQueue.main.async {
                let now = Date()
                let newReading = self.generateRandomReading(for: now, previousReading: self.readings.last)
                self.readings.append(newReading)

                if self.readings.count > 36 {
                    self.readings.removeFirst()
                }
            }
        }
    }

    deinit {
        timer?.invalidate()
    }
}
