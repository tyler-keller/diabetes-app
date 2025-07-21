//
//  EVGReading.swift
//  diabetes-app
//
//  Created by Tyler Keller on 7/21/25.
//

import Foundation

struct EGVReading: Identifiable {
    let id = UUID()
    let systemTime: Date
    let displayTime: Date
    let value: Int
    let trend: String
    let trendRate: Double
}
