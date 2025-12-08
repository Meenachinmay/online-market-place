import Foundation

// MARK: - Product Models
struct Product: Codable, Identifiable {
    let id: String
    let name: String
    let description: String
    let price: Int64
    let buyerRewardPoints: Int32
    
    enum CodingKeys: String, CodingKey {
        case id, name, description, price
        case buyerRewardPoints = "buyer_reward_points"
    }
}

struct ProductList: Codable {
    let products: [Product]
}

// MARK: - Blog Models
struct Blog: Codable, Identifiable {
    let id: String
    let authorID: String
    let content: String
    let linkedProductID: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case authorID = "author_id"
        case content
        case linkedProductID = "linked_product_id"
    }
}

struct BlogList: Codable {
    let blogs: [Blog]
}

// MARK: - Order Models
struct Order: Codable, Identifiable {
    let id: String
    let buyerID: String
    let productID: String
    let amount: Int64
    let status: String
    let createdAt: Int64
    
    enum CodingKeys: String, CodingKey {
        case id
        case buyerID = "buyer_id"
        case productID = "product_id"
        case amount, status
        case createdAt = "created_at"
    }
}

struct OrderResponse: Codable {
    let order: Order
}

struct PlaceOrderRequest: Codable {
    let productID: String
    let blogID: String
    
    enum CodingKeys: String, CodingKey {
        case productID = "product_id"
        case blogID = "blog_id"
    }
}

// MARK: - Wallet Models
struct Wallet: Codable {
    let userID: String
    let sodaPoints: Int64
    let sodaBalance: Int64
    
    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case sodaPoints = "soda_points"
        case sodaBalance = "soda_balance"
    }
}

struct ConvertPointsRequest: Codable {
    let pointsToConvert: Int64
    
    enum CodingKeys: String, CodingKey {
        case pointsToConvert = "points_to_convert"
    }
}
