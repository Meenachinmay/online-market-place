import Foundation
import SwiftUI
import Combine

@MainActor
class SodaConfirmRegistrationViewModel: ObservableObject {
    @Published var email = ""
    @Published var code = ""
    @Published var emailError = ""
    @Published var codeError = ""
    @Published var isLoading = false
    @Published var showError = false
    @Published var errorMessage = ""
    @Published var confirmationSuccess = false
    @Published var showSuccessAlert = false
    
    private let authService: AuthServiceProtocol
    private let userDefaultsManager: UserDefaultsManagerProtocol
    
    init(email: String? = nil,
         authService: AuthServiceProtocol = AuthService.shared,
         userDefaultsManager: UserDefaultsManagerProtocol = UserDefaultsManager.shared) {
        self.authService = authService
        self.userDefaultsManager = userDefaultsManager
        
        // Pre-fill email if provided (from signup flow)
        if let email = email {
            self.email = email
        } else {
            // Try to get last registered email
            self.email = userDefaultsManager.getLastRegisteredEmail() ?? ""
        }
    }
    
    var isFormValid: Bool {
        validateEmail() && validateCode()
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
    func validateCode() -> Bool {
        codeError = ""
        
        if code.isEmpty {
            codeError = "Confirmation code is required"
            return false
        }
        
        if code.count != 6 {
            codeError = "Code must be exactly 6 digits"
            return false
        }
        
        // Check if code contains only numbers
        let numberCharacterSet = CharacterSet.decimalDigits
        let codeCharacterSet = CharacterSet(charactersIn: code)
        if !numberCharacterSet.isSuperset(of: codeCharacterSet) {
            codeError = "Code must contain only numbers"
            return false
        }
        
        return true
    }
    
    func confirmRegistration() {
        guard isFormValid else { return }
        
        Task {
            await performConfirmation()
        }
    }
    
    @MainActor
    private func performConfirmation() async {
        isLoading = true
        showError = false
        errorMessage = ""
        
        do {
            let response = try await authService.confirmRegistration(
                email: email,
                code: code
            )
            
            if response.success {
                // Mark email as confirmed in local storage
                userDefaultsManager.markEmailAsConfirmed(email)
                
                // Clear the code field
                code = ""
                
                // Set success flags
                confirmationSuccess = true
                showSuccessAlert = true
                
                print("Email confirmation successful: \(response.message)")
            } else {
                errorMessage = response.message
                showError = true
            }
            
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
        case .badRequest:
            errorMessage = "Invalid confirmation code. Please check and try again."
        case .unauthorized:
            errorMessage = "Invalid or expired confirmation code."
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
