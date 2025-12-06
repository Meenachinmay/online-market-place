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
            // Clean White Background (Morning Edition)
            Color.paper.veryLight
                .ignoresSafeArea()
            
            NavigationStack {
                ScrollView {
                    VStack(spacing: 32) {
                        // Header
                        VStack(spacing: 16) {
                            Text("VERIFICATION REQUIRED")
                                .font(.newspaperHeadlineLG)
                                .foregroundColor(Color.ink.primary)
                                .multilineTextAlignment(.center)
                            
                            Text("A unique key has been dispatched to your correspondence address. Please enter it below to finalize your registry.")
                                .font(.newspaperBody)
                                .foregroundColor(Color.ink.primary)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                        }
                        .padding(.top, 60)
                        
                        // Form Card
                        VStack(spacing: 24) {
                            // Email field
                            NewspaperInput(
                                title: "Correspondence Address",
                                text: $viewModel.email
                            )
                            .textContentType(.emailAddress)
                            .autocorrectionDisabled()
                            .autocapitalization(.none)
                            
                            // Verification code field
                            NewspaperInput(
                                title: "Verification Key",
                                text: $viewModel.code
                            )
                            .textContentType(.oneTimeCode)
                            .keyboardType(.numberPad)
                            .focused($isCodeFieldFocused)
                            .onAppear {
                                isCodeFieldFocused = true
                            }
                            
                            // Confirm button
                            Button("Validate Key") {
                                let impact = UIImpactFeedbackGenerator(style: .medium)
                                impact.impactOccurred()
                                viewModel.confirmRegistration()
                            }
                            .buttonStyle(NewspaperButtonStyle(isUrgent: true))
                            .disabled(viewModel.isLoading || viewModel.code.isEmpty || viewModel.email.isEmpty)
                            .padding(.top, 8)
                            
                            if viewModel.isLoading {
                                Text("Validating key...")
                                    .font(.newspaperFinePrint.italic())
                                    .foregroundColor(Color.ink.secondary)
                            }
                        }
                        .padding(24)
                        .background(Color.paper.veryLight)
                        .newspaperBorderThick()
                        .neoShadow() // Hard Shadow
                        .padding(.bottom, 16) // Extra spacing for shadow
                        
                        // Resend
                        Button("Key not received? Request Dispatch") {
                            let impact = UIImpactFeedbackGenerator(style: .light)
                            impact.impactOccurred()
                        }
                        .font(.newspaperCaption.italic())
                        .foregroundColor(Color.ink.primary)
                        .padding(.top, 8)
                    }
                    .padding(.horizontal, 24)
                }
                .navigationTitle("")
                .navigationBarTitleDisplayMode(.inline)
                .toolbarBackground(Color.paper.veryLight, for: .navigationBar)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Cancel") {
                            dismiss()
                        }
                        .font(.newspaperBody)
                        .foregroundColor(Color.ink.primary)
                    }
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
        .newspaperAlert("Success", isPresented: $viewModel.confirmationSuccess) {
            Button("Proceed to Identification") {
                dismiss()
            }
        } message: {
            Text("Registry confirmation successful.")
        }
    }
}

#Preview {
    ConfirmRegistrationView(email: "test@example.com")
}
