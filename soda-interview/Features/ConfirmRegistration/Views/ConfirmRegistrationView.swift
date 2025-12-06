import SwiftUI

struct ConfirmRegistrationView: View {
    @StateObject private var viewModel: SodaConfirmRegistrationViewModel
    @Environment(\.dismiss) private var dismiss
    @FocusState private var isCodeFieldFocused: Bool
    
    init(email: String = "") {
        _viewModel = StateObject(wrappedValue: SodaConfirmRegistrationViewModel(email: email))
    }
    
    var body: some View {
        ZStack {
            // Background
            Color.marketplace.background.ignoresSafeArea()
            
            NavigationStack {
                ScrollView {
                    VStack(spacing: 32) {
                        // Header
                        VStack(spacing: 16) {
                            Text("Check your email")
                                .font(.marketplaceHeadlineXL)
                                .foregroundColor(Color.marketplace.primaryText)
                                .multilineTextAlignment(.center)
                            
                            Text("We've sent a verification code to your email address. Please enter it below.")
                                .font(.marketplaceBody)
                                .foregroundColor(Color.marketplace.primaryText.opacity(0.7))
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                        }
                        .padding(.top, 40)
                        
                        // Form Section
                        VStack(spacing: 20) {
                            // Email field
                            MarketplaceInput(
                                title: "Email",
                                text: $viewModel.email
                            )
                            .textContentType(.emailAddress)
                            .autocorrectionDisabled()
                            .autocapitalization(.none)
                            
                            // Verification code field
                            MarketplaceInput(
                                title: "Verification Code",
                                text: $viewModel.code,
                                placeholder: "123456"
                            )
                            .textContentType(.oneTimeCode)
                            .keyboardType(.numberPad)
                            .focused($isCodeFieldFocused)
                            .onAppear {
                                isCodeFieldFocused = true
                            }
                            
                            // Confirm button
                            Button("Verify Code") {
                                let impact = UIImpactFeedbackGenerator(style: .medium)
                                impact.impactOccurred()
                                viewModel.confirmRegistration()
                            }
                            .buttonStyle(MarketplaceButtonStyle(isPrimary: true))
                            .disabled(viewModel.isLoading || viewModel.code.isEmpty || viewModel.email.isEmpty)
                            .padding(.top, 8)
                            
                            if viewModel.isLoading {
                                ProgressView()
                                    .tint(Color.marketplace.primaryAction)
                            }
                        }
                        .padding(24)
                        
                        // Resend
                        Button("Didn't receive a code? Resend") {
                            let impact = UIImpactFeedbackGenerator(style: .light)
                            impact.impactOccurred()
                        }
                        .font(.marketplaceCaption)
                        .foregroundColor(Color.marketplace.primaryAction)
                        .padding(.top, 8)
                    }
                    .padding(.horizontal, 0)
                }
                .navigationTitle("")
                .navigationBarTitleDisplayMode(.inline)
                .toolbarBackground(Color.marketplace.background, for: .navigationBar)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Cancel") {
                            dismiss()
                        }
                        .font(.marketplaceBody)
                        .foregroundColor(Color.marketplace.primaryText)
                    }
                }
            }
        }
        .marketplaceBackground()
        .marketplaceAlert("Error", isPresented: $viewModel.showError) {
            Button("OK") { viewModel.showError = false }
        } message: {
            Text(viewModel.errorMessage)
        }
        .marketplaceAlert("Success", isPresented: $viewModel.confirmationSuccess) {
            Button("Log In") {
                dismiss()
            }
        } message: {
            Text("Account verified successfully.")
        }
    }
}

#Preview {
    ConfirmRegistrationView(email: "test@example.com")
}
