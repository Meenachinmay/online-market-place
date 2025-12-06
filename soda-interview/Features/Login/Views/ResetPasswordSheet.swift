import SwiftUI

struct ResetPasswordSheet: View {
    @Binding var isPresented: Bool
    var email: String
    @Binding var parentSheetPresented: Bool
    
    @StateObject private var viewModel: SodaResetPasswordViewModel
    
    init(isPresented: Binding<Bool>, email: String, parentSheetPresented: Binding<Bool>) {
        self._isPresented = isPresented
        self.email = email
        self._parentSheetPresented = parentSheetPresented
        self._viewModel = StateObject(wrappedValue: SodaResetPasswordViewModel(email: email))
    }
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                // Header
                headerView
                
                ScrollView {
                    VStack(spacing: 32) {
                        
                        // Header Text
                        VStack(spacing: 8) {
                            Text("Set New Password")
                                .font(.marketplaceHeadlineXL)
                                .foregroundColor(Color.marketplace.primaryText)
                            
                            Text("Enter the code sent to your email and create a new password.")
                                .font(.marketplaceBody)
                                .foregroundColor(Color.marketplace.primaryText.opacity(0.7))
                                .multilineTextAlignment(.center)
                        }
                        .padding(.top, 20)
                        
                        // Form Section
                        VStack(spacing: 20) {
                            // Code Field
                            MarketplaceInput(
                                title: "Verification Code",
                                text: $viewModel.code,
                                placeholder: "123456"
                            )
                            .keyboardType(.numberPad)
                            .textContentType(.oneTimeCode)
                            
                            // New Password Field
                            MarketplaceInput(
                                title: "New Password",
                                text: $viewModel.newPassword,
                                isSecure: true,
                                placeholder: "••••••••"
                            )
                            .textContentType(.newPassword)
                            
                            // Confirm Password Field
                            MarketplaceInput(
                                title: "Confirm Password",
                                text: $viewModel.confirmNewPassword,
                                isSecure: true,
                                placeholder: "••••••••"
                            )
                            .textContentType(.newPassword)
                            
                            if let error = viewModel.errorMessage {
                                Text("⚠ " + error)
                                    .font(.marketplaceCaption)
                                    .foregroundColor(Color.marketplace.primaryAction)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            
                            // Submit Button
                            Button("Reset Password") {
                                let impact = UIImpactFeedbackGenerator(style: .medium)
                                impact.impactOccurred()
                                Task {
                                    await viewModel.resetPassword()
                                }
                            }
                            .buttonStyle(MarketplaceButtonStyle(isPrimary: true))
                            .padding(.top, 8)
                            .disabled(viewModel.isLoading)
                            
                            if viewModel.isLoading {
                                ProgressView()
                                    .tint(Color.marketplace.primaryAction)
                            }
                        }
                        .padding(24)
                    }
                    .padding(24)
                }
            }
        }
        .marketplaceBackground()
        .marketplaceAlert("Success", isPresented: $viewModel.success) {
            Button("Log In") {
                isPresented = false
                parentSheetPresented = false
            }
        } message: {
            Text("Your password has been successfully updated.")
        }
    }
    
    private var headerView: some View {
        HStack {
            Spacer()
            
            Button(action: {
                isPresented = false
            }) {
                Image(systemName: "xmark")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(Color.marketplace.primaryText)
                    .padding(12)
                    .background(Circle().fill(Color.white))
                    .overlay(Circle().stroke(Color.marketplace.stroke, lineWidth: 1.5))
            }
        }
        .padding(24)
    }
}

#Preview {
    ResetPasswordSheet(isPresented: .constant(true), email: "test@example.com", parentSheetPresented: .constant(true))
}
