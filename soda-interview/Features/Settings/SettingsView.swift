import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var navigator: Navigator
    
    var body: some View {
        ZStack {
            Color.marketplace.background.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    Text("Settings")
                        .font(.marketplaceHeadlineLG)
                        .foregroundColor(Color.marketplace.primaryText)
                    Spacer()
                }
                .padding(24)
                .background(Color.marketplace.background.ignoresSafeArea(edges: .top))
                .overlay(
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(Color.marketplace.stroke.opacity(0.1)),
                    alignment: .bottom
                )
                
                ScrollView {
                    VStack(spacing: 32) {
                        // Profile Section
                        HStack(spacing: 16) {
                            Circle()
                                .fill(Color.marketplace.lavender)
                                .frame(width: 60, height: 60)
                                .overlay(
                                    Text("JD")
                                        .font(.marketplaceHeadlineMD)
                                        .foregroundColor(Color.marketplace.primaryText)
                                )
                                .overlay(
                                    Circle()
                                        .stroke(Color.marketplace.stroke, lineWidth: 1.5)
                                )
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("John Doe")
                                    .font(.marketplaceHeadlineMD)
                                    .foregroundColor(Color.marketplace.primaryText)
                                
                                Text("john.doe@example.com")
                                    .font(.marketplaceCaption)
                                    .foregroundColor(Color.marketplace.primaryText.opacity(0.6))
                            }
                            
                            Spacer()
                        }
                        .padding(24)
                        .background(Color.white)
                        .cornerRadius(20)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.marketplace.stroke, lineWidth: 1.5)
                        )
                        .padding(.horizontal, 24)
                        .padding(.top, 24)
                        
                        // Logout Button
                        Button(action: {
                            let impact = UIImpactFeedbackGenerator(style: .medium)
                            impact.impactOccurred()
                            AuthManager.shared.logout()
                        }) {
                            HStack {
                                Image(systemName: "rectangle.portrait.and.arrow.right")
                                Text("Log Out")
                            }
                        }
                        .buttonStyle(MarketplaceButtonStyle(isPrimary: false))
                        .padding(.horizontal, 24)
                    }
                }
            }
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(Navigator())
}
