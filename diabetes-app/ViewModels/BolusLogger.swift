import Foundation

class BolusLogger: ObservableObject {
    @Published var events: [BolusEvent] = []

    func logMissedMeal() {
        let event = BolusEvent(timestamp: Date(), reason: "Missed meal bolus")
        events.append(event)
        // TODO: Persist event to storage
        print("Logged missed meal bolus: \(event)")
    }
}
