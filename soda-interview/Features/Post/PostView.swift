import SwiftUI

struct PostImage: Identifiable {
    let id = UUID()
    let color: Color
}

struct PostView: View {
    @State private var title: String = ""
    @State private var description: String = ""
    @State private var price: String = ""
    @State private var selectedImages: [PostImage] = []
    
    var body: some View {
        ZStack {
            Color.marketplace.background.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    Text("New Listing")
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
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 24) {
                        // Photo Upload Area
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                // Add Button
                                Button(action: {
                                    withAnimation {
                                        selectedImages.append(PostImage(color: Color(
                                            red: .random(in: 0.8...1),
                                            green: .random(in: 0.8...1),
                                            blue: .random(in: 0.8...1)
                                        )))
                                    }
                                }) {
                                    VStack(spacing: 8) {
                                        Image(systemName: "camera.fill")
                                            .font(.system(size: 24))
                                            .foregroundColor(Color.marketplace.primaryAction)
                                        Text("Add Photo")
                                            .font(.marketplaceCaption)
                                            .foregroundColor(Color.marketplace.primaryAction)
                                    }
                                    .frame(width: 100, height: 100)
                                    .background(Color.white)
                                    .cornerRadius(12)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(style: StrokeStyle(lineWidth: 1.5, dash: [5]))
                                            .foregroundColor(Color.marketplace.primaryAction.opacity(0.5))
                                    )
                                }
                                
                                // Selected Images
                                ForEach(selectedImages) { image in
                                    image.color
                                        .frame(width: 100, height: 100)
                                        .cornerRadius(12)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(Color.marketplace.stroke, lineWidth: 1)
                                        )
                                        .overlay(
                                            Button(action: {
                                                withAnimation {
                                                    if let index = selectedImages.firstIndex(where: { $0.id == image.id }) {
                                                        selectedImages.remove(at: index)
                                                    }
                                                }
                                            }) {
                                                Image(systemName: "xmark.circle.fill")
                                                    .foregroundColor(.red)
                                                    .background(Color.white.clipShape(Circle()))
                                            }
                                            .offset(x: 8, y: -8),
                                            alignment: .topTrailing
                                        )
                                }
                            }
                            .padding(.horizontal, 24)
                            .padding(.top, 24)
                        }
                        
                        // Form Fields
                        VStack(spacing: 20) {
                            MarketplaceInput(
                                title: "Product Name",
                                text: $title,
                                placeholder: "e.g. Air Jordan 1 Chicago"
                            )
                            
                            MarketplaceInput(
                                title: "Price",
                                text: $price,
                                placeholder: "$ 0.00"
                            )
                            .keyboardType(.decimalPad)
                            
                            // Description
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Description")
                                    .font(.marketplaceBody)
                                    .foregroundColor(Color.marketplace.primaryText)
                                
                                TextEditor(text: $description)
                                    .font(.marketplaceBody)
                                    .frame(height: 120)
                                    .padding(12)
                                    .background(Color.white)
                                    .cornerRadius(16)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(Color.marketplace.stroke, lineWidth: 1.5)
                                    )
                            }
                        }
                        .padding(.horizontal, 24)
                        
                        // Submit Button
                        Button("Post Listing") {
                            let impact = UIImpactFeedbackGenerator(style: .medium)
                            impact.impactOccurred()
                            // Action
                        }
                        .buttonStyle(MarketplaceButtonStyle(isPrimary: true))
                        .padding(24)
                    }
                }
            }
        }
    }
}

#Preview {
    PostView()
}