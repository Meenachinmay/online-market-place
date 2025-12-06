import Foundation
import Combine

@MainActor
class SodaResetPasswordViewModel: ObservableObject {
    @Published var code: String = ""
    @Published var newPassword: String = ""
    @Published var confirmNewPassword: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var success: Bool = false
    
    let email: String
    private let authService: AuthServiceProtocol
    
    init(email: String, authService: AuthServiceProtocol = AuthService.shared) {
        self.email = email
        self.authService = authService
    }
    
    func resetPassword() async {
        guard !code.isEmpty else {
            errorMessage = "Please enter the verification code."
            return
        }
        
        guard !newPassword.isEmpty else {
            errorMessage = "Please enter a new password."
            return
        }
        
        guard newPassword == confirmNewPassword else {
            errorMessage = "Passwords do not match."
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            let response = try await authService.confirmPasswordReset(email: email, code: code, newPassword: newPassword)
            if response.success {
                success = true
            } else {
                errorMessage = response.message
            }
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
}
