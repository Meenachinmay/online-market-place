import Foundation
import SwiftUI
import Combine

protocol AuthManagerProtocol: AnyObject {
    var isAuthenticated: Bool { get }
    var userType: String? { get }
    var accessToken: String? { get }
    var hasValidToken: Bool { get }
    
    func checkAuthStatus()
    func saveAuthData(from response: LoginResponse)
    func logout()
    func getAccessToken() -> String?
    func getRefreshToken() -> String?
    func getIdToken() -> String?
}

@MainActor
class AuthManager: ObservableObject, AuthManagerProtocol {
    static let shared = AuthManager()
    
    @Published var isAuthenticated = false
    @Published var userType: String?
    // Removed hasProfile, isProfileLoaded, currentUser, profileCheckError as we are not checking profile on login
    
    private let keychainManager = KeychainManager.shared
    
    private init() {
        Task { @MainActor in
            checkAuthStatus()
        }
    }
    
    var accessToken: String? {
        keychainManager.get(for: .accessToken)
    }
    
    var hasValidToken: Bool {
        return accessToken != nil && !accessToken!.isEmpty
    }
   
    func checkAuthStatus() {
        isAuthenticated = hasValidToken
        userType = keychainManager.get(for: .userType)
    }
    
    func saveAuthData(from response: LoginResponse) {
        // Save tokens to Keychain
        let accessSaved = keychainManager.save(response.accessToken, for: .accessToken)
        let idSaved = keychainManager.save(response.idToken, for: .idToken)
        
        print("AuthManager: Saved Auth Data. AccessToken: \(accessSaved), IdToken: \(idSaved)")
        
        if let refresh = response.refreshToken {
            keychainManager.save(refresh, for: .refreshToken)
        }
        
        // Update published state
        self.userType = response.userType
        self.isAuthenticated = true
        
        // Persist user type
        if let type = response.userType {
            keychainManager.save(type, for: .userType)
        }
    }
   
    func logout() {
        keychainManager.clearAll()
        isAuthenticated = false
        userType = nil
    }
    
    // Add nonisolated helper methods for token access if needed
    nonisolated func getAccessToken() -> String? {
        return KeychainManager.shared.get(for: .accessToken)
    }
    
    nonisolated func getRefreshToken() -> String? {
        return KeychainManager.shared.get(for: .refreshToken)
    }
    
    nonisolated func getIdToken() -> String? {
        return KeychainManager.shared.get(for: .idToken)
    }
}
