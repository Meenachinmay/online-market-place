import Foundation

enum AuthEndpoint: APIEndpoint {
    case login(LoginRequest)
    case register(SignupRequest)
    case logout
    case confirmRegistration(ConfirmRequest)
    case initiatePasswordReset(InitialPasswordResetRequest)
    case confirmPasswordReset(ConfirmPasswordResetRequest)
    
    var path: String {
        switch self {
        case .login:
            return "/api/v1/auth/login"
        case .register:
            return "/api/v1/auth/register"
        case .logout:
            return "/api/v1/auth/logout"
        case .confirmRegistration:
            return "/api/v1/auth/confirm"
        case .initiatePasswordReset:
            return "/api/v1/auth/password-reset/initiate"
        case .confirmPasswordReset:
            return "/api/v1/auth/password-reset/confirm"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .login, .register, .logout, .confirmRegistration, .initiatePasswordReset, .confirmPasswordReset:
            return .post
        }
    }
    
    var headers: [String: String]? {
        return nil
    }
    
    var requiresAuth: Bool {
        switch self {
        case .login, .register, .confirmRegistration, .initiatePasswordReset, .confirmPasswordReset:
            return false
        case .logout:
            return true
        }
    }
    
    var parameters: [String: Any]? {
        return nil
    }
    
    var body: Data? {
        switch self {
        case .login(let request):
            return try? JSONEncoder().encode(request)
        case .register(let request):
            return try? JSONEncoder().encode(request)
        case .confirmRegistration(let request):
            return try? JSONEncoder().encode(request)
        case .logout:
            return nil
        case .initiatePasswordReset(let request):
            return try? JSONEncoder().encode(request)
        case .confirmPasswordReset(let request):
            return try? JSONEncoder().encode(request)
        }
    }
}

protocol AuthServiceProtocol {
    func login(email: String, password: String) async throws -> LoginResponse
    func register(email: String, password: String, displayName: String, type: String?) async throws -> SignupResponse
    func logout() async throws
    func confirmRegistration(email: String, code: String) async throws -> ConfirmRegistrationResponse
    func initiatePasswordReset(email: String) async throws -> InitialPasswordResetResponse
    func confirmPasswordReset(email: String, code: String, newPassword: String) async throws -> ConfirmPasswordResetResponse
}

class AuthService: AuthServiceProtocol {
    static let shared = AuthService()
    private let apiClient = APIClient.shared
    
    private init() {}
    
    func login(email: String, password: String) async throws -> LoginResponse {
        let request = LoginRequest(email: email, password: password)
        let endpoint = AuthEndpoint.login(request)
        return try await apiClient.request(endpoint, responseType: LoginResponse.self)
    }
    
    func register(email: String, password: String, displayName: String, type: String? = nil) async throws -> SignupResponse {
        let request = SignupRequest(email: email, password: password, displayName: displayName, type: type)
        let endpoint = AuthEndpoint.register(request)
        return try await apiClient.request(endpoint, responseType: SignupResponse.self)
    }
    
    func logout() async throws {
        let endpoint = AuthEndpoint.logout
        let data = try await apiClient.request(endpoint)
        
        if let response = try? JSONDecoder().decode(LogoutResponse.self, from: data) {
            if !response.success {
                throw NetworkError.customError(message: response.message)
            }
            print("Logout response: \(response.message)")
        }
    }
    
    func confirmRegistration(email: String, code: String) async throws -> ConfirmRegistrationResponse {
        let request = ConfirmRequest(email: email, code: code)
        let endpoint = AuthEndpoint.confirmRegistration(request)
        return try await apiClient.request(endpoint, responseType: ConfirmRegistrationResponse.self)
    }
    
    func initiatePasswordReset(email: String) async throws -> InitialPasswordResetResponse {
        let request = InitialPasswordResetRequest(email: email)
        let endpoint = AuthEndpoint.initiatePasswordReset(request)
        return try await apiClient.request(endpoint, responseType: InitialPasswordResetResponse.self)
    }
    
    func confirmPasswordReset(email: String, code: String, newPassword: String) async throws -> ConfirmPasswordResetResponse {
        let request = ConfirmPasswordResetRequest(email: email, code: code, newPassword: newPassword)
        let endpoint = AuthEndpoint.confirmPasswordReset(request)
        return try await apiClient.request(endpoint, responseType: ConfirmPasswordResetResponse.self)
    }
}
