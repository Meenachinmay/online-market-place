import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    
    let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.marketplace.background.ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Header
                    HStack {
                        Text("Marketplace Blogs")
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
                    
                    if viewModel.isLoading {
                        Spacer()
                        ProgressView("Loading Blogs...")
                        Spacer()
                    } else if let error = viewModel.errorMessage {
                        Spacer()
                        Text(error)
                            .foregroundColor(.red)
                        Button("Retry") {
                            Task { await viewModel.fetchBlogs() }
                        }
                        Spacer()
                    } else {
                        ScrollView {
                            LazyVGrid(columns: columns, spacing: 16) {
                                ForEach(viewModel.blogs) { blog in
                                    NavigationLink(destination: BlogDetailView(blog: blog)) {
                                        BlogCard(blog: blog)
                                    }
                                }
                            }
                            .padding(24)
                        }
                        .refreshable {
                            await viewModel.fetchBlogs()
                        }
                    }
                }
            }
            .onAppear {
                Task {
                    if viewModel.blogs.isEmpty {
                        await viewModel.fetchBlogs()
                    }
                }
            }
        }
    }
}

struct BlogCard: View {
    let blog: Blog
    
    // Generate a consistent color based on ID to make it look persistent but random
    var randomColor: Color {
        let colors = [
            Color(hex: "FF6B6B"), Color(hex: "4ECDC4"), Color(hex: "FFE66D"),
            Color.marketplace.lavender, Color.marketplace.mintGreen, Color.marketplace.palePink
        ]
        let index = abs(blog.id.hashValue) % colors.count
        return colors[index]
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Image Placeholder (Abstract Art for Blog)
            ZStack {
                randomColor.opacity(0.3)
                Image(systemName: "doc.text.image")
                    .font(.system(size: 40))
                    .foregroundColor(randomColor)
            }
            .frame(height: 140)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.marketplace.stroke, lineWidth: 1.5)
            )
            
            // Info
            VStack(alignment: .leading, spacing: 4) {
                Text("AUTHOR: \(blog.authorID.prefix(8))")
                    .font(.system(size: 10, weight: .bold, design: .rounded))
                    .foregroundColor(Color.marketplace.primaryText.opacity(0.6))
                
                Text(blog.content)
                    .font(.marketplaceBody)
                    .foregroundColor(Color.marketplace.primaryText)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                
                HStack {
                    Text("View Product")
                        .font(.marketplaceCaption.bold())
                        .foregroundColor(Color.marketplace.primaryText)
                    
                    Spacer()
                    
                    Image(systemName: "arrow.right")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.white)
                        .padding(8)
                        .background(Color.marketplace.primaryText)
                        .clipShape(Circle())
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
