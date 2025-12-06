import Foundation

struct ConfirmRequest: Codable {
    let email: String
    let code: String
}

struct ConfirmRegistrationResponse: Codable {
    let success: Bool
    let message: String
}
