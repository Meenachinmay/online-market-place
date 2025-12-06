import SwiftUI

struct LoginView: View {
    @State var showingSignUpSheet = false
    @State var showingLoginSheet = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                VStack(spacing: 0) {
                    // Modern Header
                    HStack {
                        Text("SODA")
                            .font(.marketplaceHeadlineLG)
                            .foregroundColor(Color.marketplace.primaryText)
                        Spacer()
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, geometry.safeAreaInsets.top + 20)
                    .padding(.bottom, 20)
                    
                    Spacer()
                    
                    // Hero Section
                    VStack(spacing: 24) {
                        Text("The Ultimate\nSneaker Marketplace.")
                            .font(.marketplaceHeadlineXL)
                            .foregroundColor(Color.marketplace.primaryText)
                            .multilineTextAlignment(.center)
                        
                        Text("Buy, sell, and trade the most exclusive sneakers in the world. Verified authentic.")
                            .font(.marketplaceBody)
                            .foregroundColor(Color.marketplace.primaryText.opacity(0.8))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 32)
                            .lineSpacing(4)
                        
                        Spacer()
                            .frame(height: 20)
                        
                        // Action Buttons
                        VStack(spacing: 16) {
                            Button("Get Started") {
                                let impact = UIImpactFeedbackGenerator(style: .medium)
                                impact.impactOccurred()
                                showingSignUpSheet = true
                            }
                            .buttonStyle(MarketplaceButtonStyle(isPrimary: true))
                            
                            Button("Log In") {
                                let impact = UIImpactFeedbackGenerator(style: .medium)
                                impact.impactOccurred()
                                showingLoginSheet = true
                            }
                            .buttonStyle(MarketplaceButtonStyle(isPrimary: false))
                        }
                        .padding(.horizontal, 24)
                    }
                    .padding(.bottom, 40)
                    
                    Spacer()
                }
            }
        }
        .marketplaceBackground()
        .sheet(isPresented: $showingSignUpSheet) {
            SignUpView(isPresented: $showingSignUpSheet)
        }
        .sheet(isPresented: $showingLoginSheet) {
            LoginSheetView(isPresented: $showingLoginSheet)
        }
    }
}

#Preview {
    LoginView()
}
