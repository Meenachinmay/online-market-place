import SwiftUI

struct Sneaker: Identifiable {
    let id = UUID()
    let name: String
    let price: Double
    let brand: String
    let color: Color
    let size: String
}

struct HomeView: View {
    let sneakers: [Sneaker] = [
        Sneaker(name: "Air Jordan 1 High", price: 180.00, brand: "Jordan", color: Color(hex: "FF6B6B"), size: "US 10"),
        Sneaker(name: "Dunk Low Retro", price: 110.00, brand: "Nike", color: Color(hex: "4ECDC4"), size: "US 9"),
        Sneaker(name: "Yeezy Boost 350", price: 230.00, brand: "Adidas", color: Color(hex: "FFE66D"), size: "US 11"),
        Sneaker(name: "New Balance 550", price: 120.00, brand: "New Balance", color: Color.marketplace.lavender, size: "US 9.5"),
        Sneaker(name: "Air Max 90", price: 130.00, brand: "Nike", color: Color.marketplace.mintGreen, size: "US 10.5"),
        Sneaker(name: "Forum Low", price: 100.00, brand: "Adidas", color: Color.marketplace.palePink, size: "US 8")
    ]
    
    let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        ZStack {
            Color.marketplace.background.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    Text("Marketplace")
                        .font(.marketplaceHeadlineLG)
                        .foregroundColor(Color.marketplace.primaryText)
                    Spacer()
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 20))
                        .foregroundColor(Color.marketplace.primaryText)
                        .padding(12)
                        .background(Color.white)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.marketplace.stroke, lineWidth: 1.5))
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
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(sneakers) { sneaker in
                            SneakerCard(sneaker: sneaker)
                        }
                    }
                    .padding(24)
                }
            }
        }
    }
}

struct SneakerCard: View {
    let sneaker: Sneaker
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Image Placeholder
            ZStack {
                sneaker.color.opacity(0.3)
                Image(systemName: "shoe.fill") // Fallback icon
                    .font(.system(size: 40))
                    .foregroundColor(sneaker.color)
                    .rotationEffect(.degrees(-30))
            }
            .frame(height: 140)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.marketplace.stroke, lineWidth: 1.5)
            )
            
            // Info
            VStack(alignment: .leading, spacing: 4) {
                Text(sneaker.brand.uppercased())
                    .font(.system(size: 10, weight: .bold, design: .rounded))
                    .foregroundColor(Color.marketplace.primaryText.opacity(0.6))
                
                Text(sneaker.name)
                    .font(.marketplaceHeadlineMD)
                    .foregroundColor(Color.marketplace.primaryText)
                    .lineLimit(1)
                
                Text(sneaker.size)
                    .font(.marketplaceCaption)
                    .foregroundColor(Color.marketplace.primaryText.opacity(0.6))
                
                HStack {
                    Text(String(format: "$%.2f", sneaker.price))
                        .font(.marketplaceBody.bold())
                        .foregroundColor(Color.marketplace.primaryText)
                    
                    Spacer()
                    
                    Button(action: {}) {
                        Image(systemName: "plus")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.white)
                            .padding(8)
                            .background(Color.marketplace.primaryText)
                            .clipShape(Circle())
                    }
                }
                .padding(.top, 4)
            }
        }
        .padding(12)
        .background(Color.white)
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.marketplace.stroke, lineWidth: 1.5)
        )
    }
}

#Preview {
    HomeView()
}
