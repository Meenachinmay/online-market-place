import SwiftUI

struct SignUpView: View {
    @Binding var isPresented: Bool
    @StateObject private var viewModel = SodaSignupViewModel()
    @FocusState private var focusedField: Field?
    
    enum Field {
        case displayName, email, password
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
                            Text("Create Account")
                                .font(.marketplaceHeadlineXL)
                                .foregroundColor(Color.marketplace.primaryText)
                            
                            Text("Join our community of experts.")
                                .font(.marketplaceBody)
                                .foregroundColor(Color.marketplace.primaryText.opacity(0.7))
                        }
                        .padding(.top, 20)
                        
                        // Form Section
                        VStack(spacing: 20) {
                            
                            // Name Field
                            MarketplaceInput(
                                title: "Full Name",
                                text: $viewModel.displayName,
                                placeholder: "John Doe"
                            )
                            .textContentType(.name)
                            .focused($focusedField, equals: .displayName)
                            
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
                            .focused($focusedField, equals: .email)
                            
                            // Password Field
                            MarketplaceInput(
                                title: "Password",
                                text: $viewModel.password,
                                isSecure: true,
                                placeholder: "••••••••"
                            )
                            .textContentType(.newPassword)
                            .focused($focusedField, equals: .password)
                            
                            // Sign Up Button
                            Button("Create Account") {
                                let impact = UIImpactFeedbackGenerator(style: .medium)
                                impact.impactOccurred()
                                viewModel.signup()
                            }
                            .buttonStyle(MarketplaceButtonStyle(isPrimary: true))
                            .disabled(viewModel.isLoading)
                            .padding(.top, 8)
                            
                            if viewModel.isLoading {
                                ProgressView()
                                    .tint(Color.marketplace.primaryAction)
                            }
                        }
                        
                        // Disclaimer
                        Text("By creating an account, you agree to our Terms of Service and Privacy Policy.")
                            .font(.marketplaceCaption)
                            .foregroundColor(Color.marketplace.primaryText.opacity(0.6))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 24)
                            .padding(.top, 16)
                    }
                    .padding(24)
                }
            }
        }
        .marketplaceAlert("Notice", isPresented: $viewModel.showError) {
            Button("OK") { viewModel.showError = false }
        } message: {
            Text(viewModel.errorMessage)
        }
        .sheet(isPresented: $viewModel.registrationSuccess) {
            ConfirmRegistrationView(email: viewModel.registeredEmail)
                .interactiveDismissDisabled()
                .onDisappear {
                    isPresented = false
                }
        }
        .marketplaceBackground()
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
    SignUpView(isPresented: .constant(true))
}
