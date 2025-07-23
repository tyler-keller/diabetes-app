import Foundation

/// Service for retrieving Dexcom CGM data from the sandbox environment.
/// This class manages OAuth token exchange using a refresh token and exposes
/// a method to fetch EGV (estimated glucose value) data.
///
/// Usage:
///   let service = DexcomService(clientId: "id", clientSecret: "secret")
///   try await service.authorize(with: "refresh_token")
///   try await service.fetchEGVData(startDate: ..., endDate: ...)
///   let readings = service.readings
class DexcomService: ObservableObject {
    @Published private(set) var readings: [EGVReading] = []

    private let clientId: String
    private let clientSecret: String
    private var accessToken: String?

    private let baseURL = URL(string: "https://sandbox-api.dexcom.com")!

    init(clientId: String, clientSecret: String) {
        self.clientId = clientId
        self.clientSecret = clientSecret
    }

    /// Exchanges a refresh token for an access token using Dexcom's OAuth API.
    func authorize(with refreshToken: String) async throws {
        var components = URLComponents(url: baseURL.appendingPathComponent("/v2/oauth2/token"), resolvingAgainstBaseURL: false)!
        components.queryItems = [
            URLQueryItem(name: "client_id", value: clientId),
            URLQueryItem(name: "client_secret", value: clientSecret),
            URLQueryItem(name: "refresh_token", value: refreshToken),
            URLQueryItem(name: "grant_type", value: "refresh_token")
        ]
        var request = URLRequest(url: components.url!)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        let (data, _) = try await URLSession.shared.data(for: request)
        let tokenResponse = try JSONDecoder().decode(TokenResponse.self, from: data)
        accessToken = tokenResponse.access_token
    }

    /// Fetches EGV data for the current user in the given date range.
    func fetchEGVData(startDate: Date, endDate: Date) async throws {
        guard let token = accessToken else { return }
        var components = URLComponents()
        components.scheme = "https"
        components.host = "sandbox-api.dexcom.com"
        components.path = "/v3/users/self/egvs"
        let formatter = ISO8601DateFormatter()
        components.queryItems = [
            URLQueryItem(name: "startDate", value: formatter.string(from: startDate)),
            URLQueryItem(name: "endDate", value: formatter.string(from: endDate))
        ]
        var request = URLRequest(url: components.url!)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        let (data, _) = try await URLSession.shared.data(for: request)
        let egvResponse = try JSONDecoder().decode(EGVResponse.self, from: data)
        readings = egvResponse.egvs.map { $0.toModel() }
    }

    // MARK: - Response models
    private struct TokenResponse: Decodable {
        let access_token: String
        let expires_in: Int
        let token_type: String
        let refresh_token: String?
    }

    private struct EGVResponse: Decodable {
        let egvs: [DexcomEGV]
    }

    private struct DexcomEGV: Decodable {
        let systemTime: String
        let displayTime: String
        let value: Int?
        let trend: String?
        let trendRate: Double?

        func toModel() -> EGVReading {
            let isoFormatter = ISO8601DateFormatter()
            return EGVReading(
                systemTime: isoFormatter.date(from: systemTime) ?? Date(),
                displayTime: isoFormatter.date(from: displayTime) ?? Date(),
                value: value ?? 0,
                trend: trend ?? "Unknown",
                trendRate: trendRate ?? 0.0
            )
        }
    }
}

