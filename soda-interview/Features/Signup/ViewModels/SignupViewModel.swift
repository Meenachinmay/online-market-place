import Foundation
import SwiftUI
import Combine

@MainActor
class SodaSignupViewModel: ObservableObject {
    @Published var displayName = ""
    @Published var email = ""
    @Published var password = ""
    @Published var displayNameError = ""
    @Published var emailError = ""
    @Published var passwordError = ""
    @Published var isLoading = false
    @Published var showError = false
    @Published var errorMessage = ""
    @Published var signupSuccess = false
    @Published var signupMessage = ""
    
    private let authService: AuthServiceProtocol
    private let userDefaultsManager: UserDefaultsManagerProtocol
    
    @Published var registrationSuccess = false
    @Published var registeredEmail = ""
    
    init(authService: AuthServiceProtocol = AuthService.shared,
         userDefaultsManager: UserDefaultsManagerProtocol = UserDefaultsManager.shared) {
        self.authService = authService
        self.userDefaultsManager = userDefaultsManager
    }
    
    var isFormValid: Bool {
        validateDisplayName() && validateEmail() && validatePassword()
    }
    
    @discardableResult
    func validateDisplayName() -> Bool {
        displayNameError = ""
        
        if displayName.isEmpty {
            displayNameError = "Display name is required"
            return false
        }
        
        if displayName.count < 3 {
            displayNameError = "Display name must be at least 3 characters"
            return false
        }
        
        return true
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
        
        if password.count < 8 {
            passwordError = "Password must be at least 8 characters"
            return false
        }
        
        // Check for at least one uppercase, one lowercase, and one number
        let uppercaseRegex = ".*[A-Z]+.*"
        let lowercaseRegex = ".*[a-z]+.*"
        let numberRegex = ".*[0-9]+.*"
        
        if !NSPredicate(format: "SELF MATCHES %@", uppercaseRegex).evaluate(with: password) {
            passwordError = "Password must contain at least one uppercase letter"
            return false
        }
        
        if !NSPredicate(format: "SELF MATCHES %@", lowercaseRegex).evaluate(with: password) {
            passwordError = "Password must contain at least one lowercase letter"
            return false
        }
        
        if !NSPredicate(format: "SELF MATCHES %@", numberRegex).evaluate(with: password) {
            passwordError = "Password must contain at least one number"
            return false
        }
        
        return true
    }
    
    func signup() {
        guard isFormValid else { return }
        
        Task {
            await performSignup()
        }
    }
    
    @MainActor
    private func performSignup() async {
        isLoading = true
        showError = false
        errorMessage = ""
        
        do {
            let response = try await authService.register(
                email: email,
                password: password,
                displayName: displayName,
                type: "user" // Default to "user" type
            )
            
            if response.confirmationNeeded {
              // Mark email as unconfirmed in local storage
              userDefaultsManager.markEmailAsUnconfirmed(email)
              
              // Store email for navigation
              registeredEmail = email
              
              // Set success flag to trigger navigation
              registrationSuccess = true
              
              print("Registration successful: \(response.message)")
            }
            
            // Handle signup response
            signupMessage = response.message
            signupSuccess = true
            
            // Clear form
            displayName = ""
            email = ""
            password = ""
            
            print("Signup successful! User ID: \(response.userId)")
            
            // If confirmation is not needed, you might want to auto-login
            // For now, we'll just show success
            
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
