import Foundation
import Combine

@MainActor
class HomeViewModel: ObservableObject {
    @Published var blogs: [Blog] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let sodaService: SodaServiceProtocol
    
    init(sodaService: SodaServiceProtocol = SodaService.shared) {
        self.sodaService = sodaService
    }
    
    func fetchBlogs() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let response = try await sodaService.listBlogs()
            self.blogs = response.blogs
        } catch {
            self.errorMessage = error.localizedDescription
            print("Error fetching blogs: \(error)")
        }
        
        isLoading = false
    }
}
