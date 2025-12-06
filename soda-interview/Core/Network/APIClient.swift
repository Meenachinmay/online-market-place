import Foundation

protocol APIClientProtocol {
    func request<T: Decodable>(_ endpoint: APIEndpoint, responseType: T.Type) async throws -> T
    func request(_ endpoint: APIEndpoint) async throws -> Data
}

class APIClient: APIClientProtocol {
    static let shared = APIClient()
    
    private let session: URLSession
    private let logger = APILogger.shared
    
    private init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30.0
        configuration.timeoutIntervalForResource = 60.0
        self.session = URLSession(configuration: configuration)
    }
    
    func request<T: Decodable>(_ endpoint: APIEndpoint, responseType: T.Type) async throws -> T {
        let data = try await request(endpoint)
        
        do {
            let decoder = JSONDecoder()
            // keyDecodingStrategy removed to rely on explicit CodingKeys
            return try decoder.decode(T.self, from: data)
        } catch {
            throw NetworkError.decodingError(error)
        }
    }
    
    func request(_ endpoint: APIEndpoint) async throws -> Data {
        let request = try endpoint.asURLRequest()
        logger.logRequest(request)
        
        do {
            let (data, response) = try await session.data(for: request)
            logger.logResponse(response, data: data, error: nil)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.unknown
            }
            
            switch httpResponse.statusCode {
            case 200...299:
                return data
            case 401:
                throw NetworkError.unauthorized
            case 400...499:
                // Try to parse error response
                if let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
                    throw NetworkError.customError(message: errorResponse.error)
                }
                throw NetworkError.serverError(statusCode: httpResponse.statusCode, data: data)
            case 500...599:
                throw NetworkError.serverError(statusCode: httpResponse.statusCode, data: data)
            default:
                throw NetworkError.unknown
            }
        } catch let error as NetworkError {
            logger.logResponse(nil, data: nil, error: error)
            throw error
        } catch {
            logger.logResponse(nil, data: nil, error: error)
            throw NetworkError.networkError(error)
        }
    }
}
