import Foundation

// MARK: - Location
struct LocationPoint: Codable, Equatable {
    let longitude: Double
    let latitude: Double
}

// MARK: - Preferences
struct ConsultationPreferences: Codable, Equatable {
    var expertiseAreas: [String]?
    var meetingPreference: String?
    var availability: String?
    var communicationStyle: String?
    
    enum CodingKeys: String, CodingKey {
        case expertiseAreas = "expertise_areas"
        case meetingPreference = "meeting_preference"
        case availability
        case communicationStyle = "communication_style"
    }
}

// MARK: - Response
struct UserProfileResponse: Codable, Identifiable, Equatable {
    let id: String
    let userId: String
    var bioText: String
    var locationCountry: String?
    var locationCity: String?
    var locationCoordinates: LocationPoint?
    var budgetMin: String?
    var budgetMax: String?
    var budgetCurrency: String?
    var languages: [String]?
    var timezone: String?
    var consultationPreferences: ConsultationPreferences?
    let createdAt: String
    let updatedAt: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case bioText = "bio_text"
        case locationCountry = "location_country"
        case locationCity = "location_city"
        case locationCoordinates = "location_coordinates"
        case budgetMin = "budget_min"
        case budgetMax = "budget_max"
        case budgetCurrency = "budget_currency"
        case languages
        case timezone
        case consultationPreferences = "consultation_preferences"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
