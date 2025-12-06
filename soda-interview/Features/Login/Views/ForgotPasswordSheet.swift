import SwiftUI

struct ForgotPasswordSheet: View {
    @Binding var isPresented: Bool
    @StateObject private var viewModel = SodaForgotPasswordViewModel()
    @State private var showResetPasswordSheet = false
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                // Header
                headerView
                
                ScrollView {
                    VStack(spacing: 32) {
                        
                        // Header Text
                        VStack(spacing: 8) {
                            Text("Reset Password")
                                .font(.marketplaceHeadlineXL)
                                .foregroundColor(Color.marketplace.primaryText)
                            
                            Text("Enter your email address to receive a verification code.")
                                .font(.marketplaceBody)
                                .foregroundColor(Color.marketplace.primaryText.opacity(0.7))
                                .multilineTextAlignment(.center)
                        }
                        .padding(.top, 20)
                        
                        // Form Section
                        VStack(spacing: 20) {
                            // Email Field
                            MarketplaceInput(
                                title: "Email Address",
                                text: $viewModel.email,
                                placeholder: "hello@example.com"
                            )
                            .textContentType(.emailAddress)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                            .autocorrectionDisabled()
                            
                            // Error Message
                            if let error = viewModel.errorMessage {
                                Text(error)
                                    .font(.marketplaceCaption)
                                    .foregroundColor(Color.marketplace.primaryAction) // Using action color as 'alert' color, or could define error color
                            }
                            
                            // Submit Button
                            Button("Send Code") {
                                let impact = UIImpactFeedbackGenerator(style: .medium)
                                impact.impactOccurred()
                                Task {
                                    await viewModel.sendResetLink()
                                }
                            }
                            .buttonStyle(MarketplaceButtonStyle(isPrimary: true))
                            .disabled(viewModel.isLoading)
                            .padding(.top, 8)
                            
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
        .marketplaceBackground() // Adds grain
        .onChange(of: viewModel.navigateToResetPassword) { shouldNavigate in
            if shouldNavigate {
                showResetPasswordSheet = true
            }
        }
        .sheet(isPresented: $showResetPasswordSheet) {
            ResetPasswordSheet(isPresented: $showResetPasswordSheet, email: viewModel.email, parentSheetPresented: $isPresented)
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
    ForgotPasswordSheet(isPresented: .constant(true))
}
