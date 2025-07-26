import Foundation

struct BolusEvent: Identifiable {
    let id = UUID()
    let timestamp: Date
    let reason: String
}
