import Foundation

struct ErrorResponse: Codable {
    let error: String
}

struct ValidationErrorResponse: Codable {
    let error: String
    let fields: [String: String]?
}
