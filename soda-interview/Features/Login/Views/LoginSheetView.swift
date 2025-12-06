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
            Color.paper.veryLight.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header (Not using Section here as it's a sheet, but mimicking style)
                headerView
                
                ScrollView {
                    VStack(spacing: 32) {
                        
                        // Form Section
                        VStack(spacing: 24) {
                            Text("PATRON IDENTIFICATION")
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
                            .textContentType(.password)
                            .focused($focusedField, equals: .password)
                            
                            // Login Button
                            Button("Access Account") {
                                let impact = UIImpactFeedbackGenerator(style: .medium)
                                impact.impactOccurred()
                                viewModel.login()
                            }
                            .buttonStyle(NewspaperButtonStyle())
                            .padding(.top, 8)
                            .disabled(viewModel.isLoading)
                            
                            if viewModel.isLoading {
                                Text("Verifying credentials...")
                                    .font(.newspaperFinePrint.italic())
                                    .foregroundColor(Color.ink.secondary)
                            }
                        }
                        .padding(24)
                        .background(Color.paper.light) // Cream Container
                        .newspaperBorderThick()
                        .neoShadow() // Hard Shadow
                        .padding(.bottom, 16) // Extra spacing for shadow
                        
                        // Additional Options
                        VStack(spacing: 16) {
                            Button("Lost Cipher?") {
                                showForgotPasswordSheet = true
                            }
                            .font(.newspaperCaption.italic())
                            .foregroundColor(Color.ink.primary)
                            
                            Text("All correspondence is secured within our archives.")
                                .font(.newspaperFinePrint)
                                .foregroundColor(Color.ink.secondary)
                        }
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
        .onChange(of: viewModel.loginSuccess) { success in
            if success {
                isPresented = false
            }
        }
        .sheet(isPresented: $showForgotPasswordSheet) {
            ForgotPasswordSheet(isPresented: $showForgotPasswordSheet)
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("IDENTIFICATION")
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
    LoginSheetView(isPresented: .constant(true))
        .environmentObject(Navigator())
}
