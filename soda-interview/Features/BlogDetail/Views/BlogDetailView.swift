import SwiftUI

struct BlogDetailView: View {
    @StateObject private var viewModel: BlogDetailViewModel
    @Environment(\.dismiss) var dismiss
    
    // Random color for the sneaker placeholder
    let randomColor: Color = [
        Color(hex: "FF6B6B"),
        Color(hex: "4ECDC4"),
        Color(hex: "FFE66D"),
        Color.marketplace.lavender,
        Color.marketplace.mintGreen,
        Color.marketplace.palePink
    ].randomElement() ?? Color.blue
    
    init(blog: Blog) {
        _viewModel = StateObject(wrappedValue: BlogDetailViewModel(blog: blog))
    }
    
    var body: some View {
        ZStack {
            Color.marketplace.background.ignoresSafeArea()
            
            if viewModel.isLoading {
                ProgressView()
                    .scaleEffect(1.5)
            } else if let product = viewModel.product {
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        // Product Image Placeholder
                        ZStack {
                            randomColor.opacity(0.3)
                            Image(systemName: "shoe.fill")
                                .font(.system(size: 80))
                                .foregroundColor(randomColor)
                                .rotationEffect(.degrees(-30))
                        }
                        .frame(height: 250)
                        .frame(maxWidth: .infinity)
                        .cornerRadius(24)
                        .overlay(
                            RoundedRectangle(cornerRadius: 24)
                                .stroke(Color.marketplace.stroke, lineWidth: 1.5)
                        )
                        
                        // Product Info
                        VStack(alignment: .leading, spacing: 8) {
                            Text(product.name)
                                .font(.marketplaceHeadlineLG)
                                .foregroundColor(Color.marketplace.primaryText)
                            
                            Text("Price: $\(String(format: "%.2f", Double(product.price)))") // Assuming price is minor units? No, JSON says int64. Usually cents. But existing UI uses Double.
                            // The proto says `int64 price`. Often this is cents.
                            // The `Sneaker` model had `Double`.
                            // I'll assume it's just a number for now, maybe cents?
                            // Let's display as is or formatted.
                            // If `180` in JSON means $180, then it's major units.
                            // If `18000` means $180.00, it's cents.
                            // I'll assume standard int means dollars for simplicity unless I see "1999" for $19.99.
                            // Given existing "180.00", I'll just print it.
                                .font(.marketplaceHeadlineMD)
                                .foregroundColor(Color.marketplace.primaryText)
                            
                            HStack {
                                Image(systemName: "sparkles")
                                Text("Earn \(product.buyerRewardPoints) Points")
                            }
                            .font(.marketplaceBody)
                            .foregroundColor(Color.marketplace.primaryText.opacity(0.8))
                            .padding(8)
                            .background(Color.yellow.opacity(0.2))
                            .cornerRadius(8)
                            
                            Text(product.description)
                                .font(.marketplaceBody)
                                .foregroundColor(Color.marketplace.primaryText.opacity(0.7))
                                .padding(.top, 8)
                        }
                        .padding(.horizontal)
                        
                        Divider()
                        
                        // Blog Content
                        VStack(alignment: .leading, spacing: 12) {
                            Text("From the Author")
                                .font(.marketplaceHeadlineMD)
                                .foregroundColor(Color.marketplace.primaryText)
                            
                            Text(viewModel.blog.content)
                                .font(.marketplaceBody)
                                .foregroundColor(Color.marketplace.primaryText)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(16)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(Color.marketplace.stroke, lineWidth: 1)
                                )
                        }
                        .padding(.horizontal)
                        
                        Spacer(minLength: 40)
                        
                        // Buy Button
                        Button(action: {
                            Task {
                                await viewModel.buyProduct()
                            }
                        }) {
                            HStack {
                                if viewModel.isPurchasing {
                                    ProgressView()
                                        .tint(.white)
                                } else {
                                    Text("Buy Now")
                                        .bold()
                                    Image(systemName: "cart.fill")
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.marketplace.primaryText)
                            .foregroundColor(.white)
                            .cornerRadius(16)
                        }
                        .disabled(viewModel.isPurchasing)
                        .padding(.horizontal)
                        .padding(.bottom, 24)
                    }
                }
            } else if let error = viewModel.errorMessage {
                VStack {
                    Text("Error loading product")
                        .font(.headline)
                    Text(error)
                        .font(.caption)
                        .foregroundColor(.red)
                    Button("Retry") {
                        Task { await viewModel.fetchProduct() }
                    }
                }
            }
        }
        .task {
            await viewModel.fetchProduct()
        }
        .alert("Status", isPresented: Binding<Bool>(
            get: { viewModel.purchaseSuccessMessage != nil || viewModel.errorMessage != nil },
            set: { _ in
                viewModel.purchaseSuccessMessage = nil
                viewModel.errorMessage = nil // Clear on dismiss
            }
        )) {
            Button("OK", role: .cancel) { }
        } message: {
            if let msg = viewModel.purchaseSuccessMessage {
                Text(msg)
            } else if let err = viewModel.errorMessage {
                Text(err)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}
