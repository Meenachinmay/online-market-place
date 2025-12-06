import Foundation

enum NetworkError: LocalizedError {
    case invalidURL
    case noData
    case decodingError(Error)
    case encodingError(Error)
    case serverError(statusCode: Int, data: Data?)
    case networkError(Error)
    case unauthorized
    case unknown
    case customError(message: String)
    case badRequest
    
    var errorDescription: String? {
        switch self {
        case .badRequest:
            return "Bad Request 403"
        case .invalidURL:
            return "Invalid URL"
        case .noData:
            return "No data received from server"
        case .decodingError(let error):
            return "Failed to decode response: \(error.localizedDescription)"
        case .encodingError(let error):
            return "Failed to encode request: \(error.localizedDescription)"
        case .serverError(let statusCode, _):
            return "Server error with status code: \(statusCode)"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .unauthorized:
            return "Unauthorized access. Please login again."
        case .unknown:
            return "An unknown error occurred"
        case .customError(let message):
            return message
        }
    }
}
