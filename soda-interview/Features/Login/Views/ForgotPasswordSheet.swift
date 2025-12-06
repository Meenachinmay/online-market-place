import SwiftUI

struct ForgotPasswordSheet: View {
    @Binding var isPresented: Bool
    @StateObject private var viewModel = SodaForgotPasswordViewModel()
    @State private var showResetPasswordSheet = false
    
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
                            Text("RECOVER ACCESS")
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
                            
                            Text("Please provide your correspondence address. We shall dispatch a secret code to verify your identity.")
                                .font(.newspaperBody)
                                .foregroundColor(Color.ink.primary)
                                .fixedSize(horizontal: false, vertical: true)
                            
                            // Email Field
                            NewspaperInput(
                                title: "Correspondence Address",
                                text: $viewModel.email,
                                error: viewModel.errorMessage
                            )
                            .textContentType(.emailAddress)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                            .autocorrectionDisabled()
                            
                            // Submit Button
                            Button("Request Code") {
                                let impact = UIImpactFeedbackGenerator(style: .medium)
                                impact.impactOccurred()
                                Task {
                                    await viewModel.sendResetLink()
                                }
                            }
                            .buttonStyle(NewspaperButtonStyle())
                            .padding(.top, 8)
                            .disabled(viewModel.isLoading)
                            
                            if viewModel.isLoading {
                                Text("Dispatching carrier pigeon...")
                                    .font(.newspaperFinePrint.italic())
                                    .foregroundColor(Color.ink.secondary)
                            }
                        }
                        .padding(24)
                        .background(Color.paper.light) // Cream Container
                        .newspaperBorderThick()
                        .neoShadow()
                        .padding(.bottom, 16)
                    }
                    .padding(24)
                }
            }
        }
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
            Text("RECOVERY")
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
    ForgotPasswordSheet(isPresented: .constant(true))
}
