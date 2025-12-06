import SwiftUI

struct WalletView: View {
    var body: some View {
        ZStack {
            Color.marketplace.background.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    Text("Wallet")
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
                    VStack(spacing: 24) {
                        // Total Balance Card
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                Image(systemName: "wallet.pass.fill")
                                    .font(.system(size: 24))
                                    .foregroundColor(.white)
                                Spacer()
                                Text("USD")
                                    .font(.marketplaceCaption)
                                    .bold()
                                    .foregroundColor(.white.opacity(0.8))
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(Color.white.opacity(0.2))
                                    .cornerRadius(8)
                            }
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Total Balance")
                                    .font(.marketplaceBody)
                                    .foregroundColor(.white.opacity(0.8))
                                
                                Text("$12,450.00")
                                    .font(.system(size: 40, weight: .bold, design: .rounded))
                                    .foregroundColor(.white)
                            }
                        }
                        .padding(24)
                        .background(
                            LinearGradient(
                                colors: [Color(hex: "065f46"), Color(hex: "10b981")], // Emerald Green
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .cornerRadius(24)
                        .overlay(
                            RoundedRectangle(cornerRadius: 24)
                                .stroke(Color.marketplace.stroke, lineWidth: 1.5)
                        )
                        .shadow(color: Color(hex: "10b981").opacity(0.3), radius: 10, x: 0, y: 5)
                        
                        // Soda Points Card
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                Image(systemName: "sparkles")
                                    .font(.system(size: 24))
                                    .foregroundColor(Color.marketplace.primaryText)
                                Spacer()
                                Text("POINTS")
                                    .font(.marketplaceCaption)
                                    .bold()
                                    .foregroundColor(Color.marketplace.primaryText.opacity(0.6))
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(Color.white.opacity(0.5))
                                    .cornerRadius(8)
                            }
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Soda Points")
                                    .font(.marketplaceBody)
                                    .foregroundColor(Color.marketplace.primaryText.opacity(0.7))
                                
                                Text("8,500")
                                    .font(.system(size: 40, weight: .bold, design: .rounded))
                                    .foregroundColor(Color.marketplace.primaryText)
                            }
                        }
                        .padding(24)
                        .background(Color.marketplace.palePink)
                        .cornerRadius(24)
                        .overlay(
                            RoundedRectangle(cornerRadius: 24)
                                .stroke(Color.marketplace.stroke, lineWidth: 1.5)
                        )
                    }
                    .padding(24)
                }
            }
        }
    }
}

#Preview {
    WalletView()
}
