import SwiftUI

struct LoginSheetView: View {
    @Binding var isPresented: Bool
    @StateObject private var viewModel = SodaLoginViewModel()
    @EnvironmentObject var navigator: Navigator
    @FocusState private var focusedField: Field?
    @State private var showForgotPasswordSheet = false
    
    enum Field {
        case email, password
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
                            Text("Welcome Back")
                                .font(.marketplaceHeadlineXL)
                                .foregroundColor(Color.marketplace.primaryText)
                            
                            Text("Enter your credentials to continue.")
                                .font(.marketplaceBody)
                                .foregroundColor(Color.marketplace.primaryText.opacity(0.7))
                        }
                        .padding(.top, 20)
                        
                        // Form Section
                        VStack(spacing: 20) {
                            // Email Field
                            MarketplaceInput(
                                title: "Email",
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
                            .textContentType(.password)
                            .focused($focusedField, equals: .password)
                            
                            // Forgot Password
                            HStack {
                                Spacer()
                                Button("Forgot Password?") {
                                    showForgotPasswordSheet = true
                                }
                                .font(.marketplaceCaption)
                                .foregroundColor(Color.marketplace.primaryAction)
                            }
                            
                            // Login Button
                            Button("Log In") {
                                let impact = UIImpactFeedbackGenerator(style: .medium)
                                impact.impactOccurred()
                                viewModel.login()
                            }
                            .buttonStyle(MarketplaceButtonStyle(isPrimary: true))
                            .disabled(viewModel.isLoading)
                            .opacity(viewModel.isLoading ? 0.7 : 1)
                            
                            if viewModel.isLoading {
                                ProgressView()
                                    .tint(Color.marketplace.primaryAction)
                            }
                        }
                        
                        // Divider
                        HStack {
                            Rectangle()
                                .fill(Color.marketplace.stroke.opacity(0.2))
                                .frame(height: 1)
                            Text("Or continue with")
                                .font(.marketplaceCaption)
                                .foregroundColor(Color.marketplace.primaryText.opacity(0.6))
                            Rectangle()
                                .fill(Color.marketplace.stroke.opacity(0.2))
                                .frame(height: 1)
                        }
                        .padding(.vertical, 8)
                        
                        // Social Login
                        HStack(spacing: 16) {
                            SocialLoginButton(
                                iconName: "apple.logo",
                                label: "Apple",
                                accentColor: Color.marketplace.lavender
                            ) {
                                // Action
                            }
                            
                            SocialLoginButton(
                                iconName: "g.circle.fill",
                                label: "Google",
                                accentColor: Color.marketplace.softYellow
                            ) {
                                // Action
                            }
                        }
                    }
                    .padding(24)
                }
            }
        }
        .marketplaceAlert("Error", isPresented: $viewModel.showError) {
             Button("OK") { viewModel.showError = false }
        } message: {
            Text(viewModel.errorMessage)
        }
        .onChange(of: viewModel.loginSuccess) { success in
            if success {
                isPresented = false
            }
        }
        .sheet(isPresented: $showForgotPasswordSheet) {
            ForgotPasswordSheet(isPresented: $showForgotPasswordSheet)
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
    LoginSheetView(isPresented: .constant(true))
        .environmentObject(Navigator())
}
