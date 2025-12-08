import Foundation

enum SodaEndpoint: APIEndpoint {
    case listProducts
    case getProduct(id: String)
    case listBlogs
    case getBlog(id: String)
    case createBlog(request: CreateBlogRequest) // Assuming this struct exists if we need it, but prompt only asked for fetch.
    // Actually the user said "This app is where user (as author) writes a blog...". 
    // But currently the requirement is "Fetch all the products... blog creation api...".
    // "Update the home screen here to render all the blogs... click a blog...".
    // The prompt says "we need to fetch all the products, we need to fetch wallet balance, wallet points, blog creation api, blog fetching api."
    // So I should include blog creation just in case, though the UI flow described focuses on Consumption.
    // I'll stick to what's needed for the described flow first: Home (Fetch Blogs) -> Detail (Fetch Product, Buy) -> Wallet (Fetch).
    
    case placeOrder(request: PlaceOrderRequest)
    case getWallet
    case convertPoints(request: ConvertPointsRequest)
    
    var path: String {
        switch self {
        case .listProducts:
            return "/api/v1/soda/products"
        case .getProduct(let id):
            return "/api/v1/soda/products/\(id)"
        case .listBlogs:
            return "/api/v1/soda/blogs"
        case .getBlog(let id):
            return "/api/v1/soda/blogs/\(id)"
        case .createBlog:
            return "/api/v1/soda/blogs"
        case .placeOrder:
            return "/api/v1/soda/orders"
        case .getWallet:
            return "/api/v1/soda/wallet"
        case .convertPoints:
            return "/api/v1/soda/wallet/convert"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .listProducts, .getProduct, .listBlogs, .getBlog, .getWallet:
            return .get
        case .createBlog, .placeOrder, .convertPoints:
            return .post
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
    
    var requiresAuth: Bool {
        switch self {
        case .listProducts, .getProduct, .listBlogs, .getBlog:
            return true // Typically these might be public, but checking router:
            // productsGroup GET "" -> sodaHandler.ListProducts (No authMw.RequireAuth() in router? Let's check router again)
            // blogsGroup GET "" -> sodaHandler.ListBlogs (No authMw.RequireAuth())
            // createBlog -> Yes
            // placeOrder -> Yes
            // getWallet -> Yes
        case .createBlog, .placeOrder, .getWallet, .convertPoints:
            return true
        }
    }
    
    // Re-checking router.go from memory/previous turn:
    // productsGroup := v1.Group("/soda/products") { ... } (No Auth Middleware on group)
    // blogsGroup := v1.Group("/soda/blogs") { ... } (No Auth Middleware on group)
    // ordersGroup.Use(authMw.RequireAuth())
    // walletGroup.Use(authMw.RequireAuth())
    
    // So Products and Blogs List/Get are PUBLIC?
    // "Update the home screen here to render all the blogs"
    // Usually fetching blogs might be public.
    // But let's look at router.go again.
    // productsGroup := v1.Group("/soda/products")
    // blogsGroup := v1.Group("/soda/blogs")
    // blogsGroup.POST("", authMw.RequireAuth(), sodaHandler.CreateBlog) -> Explicitly adds auth
    // So GET blogs is likely public.
    // However, if `requiresAuth` is true, it just adds the token. If the endpoint doesn't require it, it might ignore it, or might fail if it validates strictly.
    // APIEndpoint.swift says: "Default to true (secure by default)".
    // I will set requiresAuth to false for public ones if I am sure.
    // For now, I'll set it to false for GETs.
    
    var parameters: [String : Any]? {
        return nil
    }
    
    var body: Data? {
        switch self {
        case .placeOrder(let request):
            return try? JSONEncoder().encode(request)
        case .convertPoints(let request):
            return try? JSONEncoder().encode(request)
        case .createBlog(let request):
             return try? JSONEncoder().encode(request)
        default:
            return nil
        }
    }
}

// Need CreateBlogRequest struct if I include it in the enum
struct CreateBlogRequest: Codable {
    let content: String
    let productID: String
    
    enum CodingKeys: String, CodingKey {
        case content
        case productID = "product_id"
    }
}

protocol SodaServiceProtocol {
    func listBlogs() async throws -> BlogList
    func getProduct(id: String) async throws -> Product
    func placeOrder(productID: String, blogID: String) async throws -> OrderResponse
    func getWallet() async throws -> Wallet
    // Add others if needed
}

class SodaService: SodaServiceProtocol {
    static let shared = SodaService()
    private let apiClient = APIClient.shared
    
    private init() {}
    
    func listBlogs() async throws -> BlogList {
        let endpoint = SodaEndpoint.listBlogs
        return try await apiClient.request(endpoint, responseType: BlogList.self)
    }
    
    func getProduct(id: String) async throws -> Product {
        let endpoint = SodaEndpoint.getProduct(id: id)
        return try await apiClient.request(endpoint, responseType: Product.self)
    }
    
    func placeOrder(productID: String, blogID: String) async throws -> OrderResponse {
        let request = PlaceOrderRequest(productID: productID, blogID: blogID)
        let endpoint = SodaEndpoint.placeOrder(request: request)
        return try await apiClient.request(endpoint, responseType: OrderResponse.self)
    }
    
    func getWallet() async throws -> Wallet {
        let endpoint = SodaEndpoint.getWallet
        return try await apiClient.request(endpoint, responseType: Wallet.self)
    }
}
