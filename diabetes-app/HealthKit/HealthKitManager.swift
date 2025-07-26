import HealthKit

class HealthKitManager {
    static let shared = HealthKitManager()
    let healthStore = HKHealthStore()

    enum HealthKitError: Error {
        case notAvailable
    }

    func requestAuthorization(completion: @escaping (Bool, Error?) -> Void) {
        guard HKHealthStore.isHealthDataAvailable() else {
            completion(false, HealthKitError.notAvailable)
            return
        }

        guard let glucoseType = HKObjectType.quantityType(forIdentifier: .bloodGlucose) else {
            completion(false, HealthKitError.notAvailable)
            return
        }

        let readTypes: Set<HKObjectType> = [glucoseType]
        let shareTypes: Set<HKSampleType> = []
        healthStore.requestAuthorization(toShare: shareTypes, read: readTypes, completion: completion)
    }

    func fetchRecentGlucoseSamples(limit: Int = 36, completion: @escaping ([EGVReading]) -> Void) {
        guard let glucoseType = HKQuantityType.quantityType(forIdentifier: .bloodGlucose) else {
            completion([])
            return
        }

        let sort = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
        let query = HKSampleQuery(sampleType: glucoseType,
                                  predicate: nil,
                                  limit: limit,
                                  sortDescriptors: [sort]) { [weak self] _, samples, _ in
            guard let self = self, let glucoseSamples = samples as? [HKQuantitySample] else {
                completion([])
                return
            }

            let unit = HKUnit(from: "mg/dL")
            let readings: [EGVReading] = glucoseSamples.map { sample in
                let value = Int(sample.quantity.doubleValue(for: unit))
                return EGVReading(systemTime: sample.endDate,
                                  displayTime: sample.endDate.addingTimeInterval(-300),
                                  value: value,
                                  trend: "Flat",
                                  trendRate: 0)
            }
            completion(readings.reversed())
        }
        healthStore.execute(query)
    }
}

