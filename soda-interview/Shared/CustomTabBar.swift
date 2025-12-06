import SwiftUI

struct CustomTabBar: View {
    @Binding var selectedTab: Int
    var onFabTap: () -> Void = {}
    
    private let tabs: [(icon: String, title: String, index: Int)] = [
        ("house.fill", "Home", 0),
        ("plus.square.fill", "Post", 1),
        ("wallet.pass.fill", "Wallet", 2),
        ("gearshape.fill", "Settings", 3)
    ]
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(tabs, id: \.index) { item in
                Button {
                    let impact = UIImpactFeedbackGenerator(style: .light)
                    impact.impactOccurred()
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        selectedTab = item.index
                    }
                } label: {
                    VStack(spacing: 4) {
                        Image(systemName: item.icon)
                            .font(.system(size: 24))
                            .foregroundColor(selectedTab == item.index ? Color.marketplace.primaryAction : Color.marketplace.primaryText.opacity(0.4))
                            .scaleEffect(selectedTab == item.index ? 1.1 : 1.0)
                        
                        Text(item.title)
                            .font(.system(size: 10, weight: .medium, design: .rounded))
                            .foregroundColor(selectedTab == item.index ? Color.marketplace.primaryAction : Color.marketplace.primaryText.opacity(0.4))
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top, 12)
                    .padding(.bottom, 8) // Safe area handled by parent
                }
            }
        }
        .background(Color.marketplace.background)
        .overlay(
            Rectangle()
                .frame(height: 1)
                .foregroundColor(Color.marketplace.stroke.opacity(0.1)),
            alignment: .top
        )
    }
}

#Preview {
    ZStack {
        Color.marketplace.background.ignoresSafeArea()
        VStack {
            Spacer()
            CustomTabBar(selectedTab: .constant(0))
        }
    }
}
