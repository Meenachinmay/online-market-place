import Foundation

struct AppConfiguration {
    // MARK: - API Configuration
    
    #if DEBUG
    // For local development on Simulator, use localhost
    // For local development on Device, replace with your machine's IP address (e.g., "http://192.168.1.5:8080")
    static let apiBaseURL = "http://localhost:8080"
    #else
    // Production URL
    static let apiBaseURL = "https://api.your-production-domain.com" 
    #endif
}
