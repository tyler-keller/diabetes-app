//
//  CGMChartView.swift
//  diabetes-app
//
//  Created by Tyler Keller on 7/21/25.
//


import SwiftUI
import Charts

struct CGMChartView: View {
    var readings: [EGVReading]

    var body: some View {
        Chart {
            ForEach(readings) { reading in
                PointMark(
                    x: .value("Time", reading.displayTime),
                    y: .value("Glucose (mg/dL)", reading.value)
                )
                .symbol(.circle)
                .foregroundStyle(Color.gray)
            }
        }
        .chartYScale(domain: 40...400)
        .chartBackground { proxy in
            GeometryReader { geo in
                let fullHeight = geo.size.height
                let y80 = proxy.position(forY: 80) ?? 0
                let y180 = proxy.position(forY: 180) ?? 0

                ZStack {
                    // high zone: y = 180 to bottom
                    let highHeight = y180
                    Rectangle()
                        .fill(Color.orange.opacity(0.2))
                        .frame(height: highHeight)
                        .position(
                            x: geo.size.width / 2,
                            y: highHeight / 2
                        )

                    // low zone: top to y = 80
                    let lowHeight = fullHeight - y80
//                    let lowHeight = y80
                    Rectangle()
                        .fill(Color.red.opacity(0.15))
                        .frame(height: lowHeight)
                        .position(
                            x: geo.size.width / 2,
                            y: y80 + lowHeight / 2
                        )
                }
            }
        }
        .frame(height: 300)
        .padding()
    }
}
