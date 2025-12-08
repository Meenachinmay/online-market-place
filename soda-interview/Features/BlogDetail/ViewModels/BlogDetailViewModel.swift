import Foundation
import Combine

@MainActor
class BlogDetailViewModel: ObservableObject {
    @Published var product: Product?
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var purchaseSuccessMessage: String?
    @Published var isPurchasing = false
    
    let blog: Blog
    private let sodaService: SodaServiceProtocol
    
    init(blog: Blog, sodaService: SodaServiceProtocol = SodaService.shared) {
        self.blog = blog
        self.sodaService = sodaService
    }
    
    func fetchProduct() async {
        isLoading = true
        errorMessage = nil
        
        do {
            self.product = try await sodaService.getProduct(id: blog.linkedProductID)
        } catch {
            self.errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    func buyProduct() async {
        guard let product = product else { return }
        
        isPurchasing = true
        errorMessage = nil
        purchaseSuccessMessage = nil
        
        do {
            _ = try await sodaService.placeOrder(productID: product.id, blogID: blog.id)
            purchaseSuccessMessage = "Purchase successful! We will deliver your product."
        } catch {
            self.errorMessage = error.localizedDescription
        }
        
        isPurchasing = false
    }
}