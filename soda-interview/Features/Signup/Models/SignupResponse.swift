import Foundation

struct SignupResponse: Codable {
    let userId: String
    let confirmationNeeded: Bool
    let message: String
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case confirmationNeeded = "confirmation_needed"
        case message
    }
}
