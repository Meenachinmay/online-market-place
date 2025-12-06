import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    case patch = "PATCH"
}

protocol APIEndpoint {
    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String]? { get }
    var parameters: [String: Any]? { get }
    var body: Data? { get }
    var timeout: TimeInterval { get }
    var requiresAuth: Bool { get } // New property
}

extension APIEndpoint {
    var baseURL: String {
        return AppConfiguration.apiBaseURL
    }
    
    var timeout: TimeInterval {
        return 30.0 // Default timeout
    }
    
    var url: URL? {
        return URL(string: baseURL + path)
    }
    
    // Default to true (secure by default)
    var requiresAuth: Bool {
        return true
    }
    
    func asURLRequest() throws -> URLRequest {
        guard let url = url else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.timeoutInterval = timeout
        
        // Set default headers
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        // Automatic Token Injection
        if requiresAuth {
            if let token = AuthManager.shared.accessToken {
                request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
                print("APIEndpoint: Attached Bearer token (len: \(token.count)) to \(path)")
            } else {
                print("APIEndpoint: WARNING: Requires auth but no token found for \(path)")
            }
        }
        
        // Add custom headers (can override defaults/auth if needed, but generally additive)
        headers?.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        // Add body if present
        if let body = body {
            request.httpBody = body
        }
        
        return request
    }
}
