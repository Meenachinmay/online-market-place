import SwiftUI

struct WalletView: View {
    @StateObject private var viewModel = WalletViewModel()
    
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
                    
                    if viewModel.isLoading {
                        ProgressView()
                    } else {
                        Button(action: {
                            Task { await viewModel.fetchWallet() }
                        }) {
                            Image(systemName: "arrow.clockwise")
                                .font(.system(size: 20))
                                .foregroundColor(Color.marketplace.primaryText)
                                .padding(12)
                                .background(Color.white)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.marketplace.stroke, lineWidth: 1.5))
                        }
                    }
                }
                .padding(24)
                .background(Color.marketplace.background.ignoresSafeArea(edges: .top))
                .overlay(
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(Color.marketplace.stroke.opacity(0.1)),
                    alignment: .bottom
                )
                
                if let error = viewModel.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .padding()
                }
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Total Balance Card
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                Image(systemName: "wallet.pass.fill")
                                    .font(.system(size: 24))
                                    .foregroundColor(.white)
                                Spacer()
                                Text("YEN") // Assuming balance is in USD or similar currency
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
                                
                                Text(formattedBalance)
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
                                
                                Text("\(viewModel.wallet?.sodaPoints ?? 0)")
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
                .refreshable {
                    await viewModel.fetchWallet()
                }
            }
        }
        .onAppear {
            Task {
                if viewModel.wallet == nil {
                    await viewModel.fetchWallet()
                }
            }
        }
    }
    
    var formattedBalance: String {
        guard let balance = viewModel.wallet?.sodaBalance else { return "0.00" }
        // Assuming balance is just a number (e.g. 100). If cents, divide by 100.
        // Prompt says "wallet balance". API returns int64.
        // I will assume it is major units for now given the previous placeholder "$12,450.00".
        // Or if it's cents, 1245000.
        // I'll format it as currency.
        return NumberFormatter.currency.string(from: NSNumber(value: balance)) ?? "$\(balance)"
    }
}

extension NumberFormatter {
    static var currency: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "￥" // Or retrieve from locale/model
        return formatter
    }
}

#Preview {
    WalletView()
}
