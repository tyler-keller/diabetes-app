import WidgetKit
import SwiftUI

struct CGMEntry: TimelineEntry {
    let date: Date
    let value: Int
}

struct CGMProvider: TimelineProvider {
    func placeholder(in context: Context) -> CGMEntry {
        CGMEntry(date: Date(), value: 110)
    }

    func getSnapshot(in context: Context, completion: @escaping (CGMEntry) -> Void) {
        let entry = CGMEntry(date: Date(), value: 110)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<CGMEntry>) -> Void) {
        let entry = CGMEntry(date: Date(), value: Int.random(in: 80...180))
        let timeline = Timeline(entries: [entry], policy: .after(Date().addingTimeInterval(300)))
        completion(timeline)
    }
}

struct CGMWidgetEntryView: View {
    var entry: CGMProvider.Entry
    @ObservedObject var logger = BolusLogger()

    var body: some View {
        VStack {
            Text("\(entry.value) mg/dL")
                .font(.headline)
            Button("Log Missed Bolus") {
                logger.logMissedMeal()
            }
            .buttonStyle(.borderedProminent)
            .font(.caption)
        }
    }
}

struct CGMWidget: Widget {
    let kind: String = "CGMWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: CGMProvider()) { entry in
            CGMWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("CGM Quick Log")
        .description("View glucose and log a missed meal bolus.")
        .supportedFamilies([.systemSmall])
    }
}

#Preview(as: .systemSmall) {
    CGMWidget()
} timeline: {
    CGMEntry(date: .now, value: 123)
}
