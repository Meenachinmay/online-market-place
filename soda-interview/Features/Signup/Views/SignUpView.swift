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
            Color.paper.veryLight.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                headerView
                
                ScrollView {
                    VStack(spacing: 32) {
                        
                        // Form Section
                        VStack(spacing: 24) {
                            Text("PATRON REGISTRY")
                                .font(.newspaperHeadlineLG)
                                .foregroundColor(Color.ink.primary)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.bottom, 8)
                                .overlay(
                                    Rectangle()
                                        .frame(height: 1)
                                        .foregroundColor(Color.ink.tertiary),
                                    alignment: .bottom
                                )
                            
                            // Display Name Field
                            NewspaperInput(
                                title: "Full Name",
                                text: $viewModel.displayName,
                                error: viewModel.displayNameError.isEmpty ? nil : viewModel.displayNameError
                            )
                            .textContentType(.name)
                            .focused($focusedField, equals: .displayName)
                            
                            // Email Field
                            NewspaperInput(
                                title: "Correspondence Address",
                                text: $viewModel.email,
                                error: viewModel.emailError.isEmpty ? nil : viewModel.emailError
                            )
                            .textContentType(.emailAddress)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                            .autocorrectionDisabled()
                            .focused($focusedField, equals: .email)
                            
                            // Password Field
                            NewspaperInput(
                                title: "Cipher",
                                text: $viewModel.password,
                                isSecure: true,
                                error: viewModel.passwordError.isEmpty ? nil : viewModel.passwordError
                            )
                            .textContentType(.newPassword)
                            .focused($focusedField, equals: .password)
                            
                            // Sign Up Button
                            Button("Submit Credentials") {
                                let impact = UIImpactFeedbackGenerator(style: .medium)
                                impact.impactOccurred()
                                viewModel.signup()
                            }
                            .buttonStyle(NewspaperButtonStyle(isUrgent: true))
                            .padding(.top, 8)
                            .disabled(viewModel.isLoading)
                            
                            if viewModel.isLoading {
                                Text("Recording in ledger...")
                                    .font(.newspaperFinePrint.italic())
                                    .foregroundColor(Color.ink.secondary)
                            }
                        }
                        .padding(24)
                        .background(Color.paper.light) // Cream Container
                        .newspaperBorderThick()
                        .neoShadow() // Hard Shadow
                        .padding(.bottom, 16) // Extra spacing for shadow
                        
                        // Disclaimer
                        Text("By submitting this ledger, you agree to abide by the Establishment's Terms of Service and Privacy Policy.")
                            .font(.newspaperFinePrint)
                            .foregroundColor(Color.ink.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 24)
                    }
                    .padding(24)
                }
            }
        }
        .newspaperAlert("Notice", isPresented: $viewModel.showError) {
            Button("Acknowledge") {
                viewModel.showError = false
            }
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
    }
    
    private var headerView: some View {
        HStack {
            Text("REGISTRATION")
                .font(.newspaperHeadlineMD)
                .foregroundColor(Color.ink.primary)
            
            Spacer()
            
            Button(action: {
                isPresented = false
            }) {
                Image(systemName: "xmark")
                    .font(.system(size: 20))
                    .foregroundColor(Color.ink.primary)
                    .padding(8)
                    .newspaperBorder()
            }
        }
        .padding(24)
        .background(Color.paper.veryLight) // White Header
        .overlay(
            Rectangle()
                .frame(height: 1)
                .foregroundColor(Color.ink.tertiary),
            alignment: .bottom
        )
    }
    

}

#Preview {
    SignUpView(isPresented: .constant(true))
}
