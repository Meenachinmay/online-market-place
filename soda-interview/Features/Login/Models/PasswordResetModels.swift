import Foundation

struct InitialPasswordResetRequest: Codable {
    let email: String
}

struct InitialPasswordResetResponse: Codable {
    let success: Bool
    let message: String
}

struct ConfirmPasswordResetRequest: Codable {
    let email: String
    let code: String
    let newPassword: String
    
    enum CodingKeys: String, CodingKey {
        case email
        case code
        case newPassword = "new_password"
    }
}

struct ConfirmPasswordResetResponse: Codable {
    let success: Bool
    let message: String
}
