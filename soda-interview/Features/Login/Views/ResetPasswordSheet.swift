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
            Color.paper.veryLight.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                headerView
                
                ScrollView {
                    VStack(spacing: 32) {
                        
                        // Form Section
                        VStack(spacing: 24) {
                            Text("SECURE NEW CIPHER")
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
                            
                            Text("Enter the code sent to your correspondence address and establish your new cipher.")
                                .font(.newspaperBody)
                                .foregroundColor(Color.ink.primary)
                                .fixedSize(horizontal: false, vertical: true)
                            
                            // Code Field
                            NewspaperInput(
                                title: "Verification Code",
                                text: $viewModel.code
                            )
                            .keyboardType(.numberPad)
                            .textContentType(.oneTimeCode)
                            
                            // New Password Field
                            NewspaperInput(
                                title: "New Cipher",
                                text: $viewModel.newPassword,
                                isSecure: true
                            )
                            .textContentType(.newPassword)
                            
                            // Confirm Password Field
                            NewspaperInput(
                                title: "Confirm Cipher",
                                text: $viewModel.confirmNewPassword,
                                isSecure: true
                            )
                            .textContentType(.newPassword)
                            
                            if let error = viewModel.errorMessage {
                                errorText(error)
                            }
                            
                            // Submit Button
                            Button("Reset Cipher") {
                                let impact = UIImpactFeedbackGenerator(style: .medium)
                                impact.impactOccurred()
                                Task {
                                    await viewModel.resetPassword()
                                }
                            }
                            .buttonStyle(NewspaperButtonStyle())
                            .padding(.top, 8)
                            .disabled(viewModel.isLoading)
                            
                            if viewModel.isLoading {
                                Text("Securing credentials...")
                                    .font(.newspaperFinePrint.italic())
                                    .foregroundColor(Color.ink.secondary)
                            }
                        }
                        .padding(24)
                        .background(Color.paper.veryLight)
                        .newspaperBorderThick()
                        .neoShadow()
                        .padding(.bottom, 16)
                    }
                    .padding(24)
                }
            }
        }
        .newspaperAlert("Success", isPresented: $viewModel.success) {
            Button("Proceed to Login") {
                isPresented = false
                parentSheetPresented = false
            }
        } message: {
            Text("Your cipher has been successfully updated. Please identify yourself with your new credentials.")
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("RESET")
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
        .background(Color.paper.veryLight)
        .overlay(
            Rectangle()
                .frame(height: 1)
                .foregroundColor(Color.ink.tertiary),
            alignment: .bottom
        )
    }
    
    private func errorText(_ text: String) -> some View {
        Text("⚠ " + text)
            .font(.newspaperCaption)
            .foregroundColor(Color(hex: "8B0000"))
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    ResetPasswordSheet(isPresented: .constant(true), email: "test@example.com", parentSheetPresented: .constant(true))
}
