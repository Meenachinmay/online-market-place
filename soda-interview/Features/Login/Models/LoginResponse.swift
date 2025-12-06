import Foundation

struct LoginResponse: Codable {
    let accessToken: String
    let idToken: String
    let refreshToken: String?
    let expiresIn: Int32
    let tokenType: String
    let userType: String? // Renamed from 'type' to match backend concept, though mapped from 'user_type'
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case idToken = "id_token"
        case refreshToken = "refresh_token"
        case expiresIn = "expires_in"
        case tokenType = "token_type"
        case userType = "user_type"
    }
}
