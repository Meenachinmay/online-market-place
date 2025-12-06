import Foundation
import SwiftUI
import Combine

@MainActor
class SodaLoginViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var emailError = ""
    @Published var passwordError = ""
    @Published var isLoading = false
    @Published var showError = false
    @Published var errorMessage = ""
    @Published var loginSuccess = false
    
    private let authService: AuthServiceProtocol
    private let authManager: AuthManagerProtocol
    private let userDefaultsManager: UserDefaultsManagerProtocol
    
    @Published var showConfirmationScreen = false
    @Published var emailNeedsConfirmation = false
    
    init(authService: AuthServiceProtocol = AuthService.shared,
         authManager: AuthManagerProtocol = AuthManager.shared,
         userDefaultsManager: UserDefaultsManagerProtocol = UserDefaultsManager.shared) {
        self.authService = authService
        self.authManager = authManager
        self.userDefaultsManager = userDefaultsManager
    }
    
    var isFormValid: Bool {
        validateEmail() && validatePassword()
    }
    
    @discardableResult
    func validateEmail() -> Bool {
        emailError = ""
        
        if email.isEmpty {
            emailError = "Email is required"
            return false
        }
        
        let emailRegex = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        
        if !emailPredicate.evaluate(with: email) {
            emailError = "Please enter a valid email"
            return false
        }
        
        return true
    }
    
    @discardableResult
    func validatePassword() -> Bool {
        passwordError = ""
        
        if password.isEmpty {
            passwordError = "Password is required"
            return false
        }
        
        if password.count < 6 {
            passwordError = "Password must be at least 6 characters"
            return false
        }
        
        return true
    }
    
    func login() {
        guard isFormValid else { return }
        
        Task {
            await performLogin()
        }
    }
    
    @MainActor
    private func performLogin() async {
        isLoading = true
        showError = false
        errorMessage = ""
        
        // Check if email is marked as unconfirmed locally
           if userDefaultsManager.isEmailUnconfirmed(email) {
               errorMessage = "Please confirm your email before logging in."
               showError = true
               emailNeedsConfirmation = true
               isLoading = false
               return
           }
        
        do {
            let response = try await authService.login(email: email, password: password)
            
            // Save auth data to keychain and update auth state
            authManager.saveAuthData(from: response)
            
            // Clear form
            email = ""
            password = ""
            
            // Set success flag
            loginSuccess = true
            
            print("Login successful!")
            
        } catch let error as NetworkError {
            handleNetworkError(error)
        } catch {
            errorMessage = "An unexpected error occurred. Please try again."
            showError = true
            print("Unexpected error: \(error)")
        }
        
        isLoading = false
    }
    
    private func handleNetworkError(_ error: NetworkError) {
        switch error {
        case .unauthorized:
            errorMessage = "Invalid email or password. Please try again."
        case .networkError:
            errorMessage = "Network connection error. Please check your internet connection."
        case .serverError(let statusCode, _):
            errorMessage = "Server error (\(statusCode)). Please try again later."
        case .customError(let message):
            errorMessage = message
        default:
            errorMessage = error.localizedDescription
        }
        showError = true
    }
}
