import Foundation
import Combine

@MainActor
class SodaForgotPasswordViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var navigateToResetPassword: Bool = false
    
    private let authService: AuthServiceProtocol
    
    init(authService: AuthServiceProtocol = AuthService.shared) {
        self.authService = authService
    }
    
    func sendResetLink() async {
        guard !email.isEmpty else {
            errorMessage = "Please enter your email address."
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            let response = try await authService.initiatePasswordReset(email: email)
            if response.success {
                navigateToResetPassword = true
            } else {
                errorMessage = response.message
            }
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
}
