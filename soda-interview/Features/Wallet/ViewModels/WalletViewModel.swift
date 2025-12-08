import Foundation
import Combine

@MainActor
class WalletViewModel: ObservableObject {
    @Published var wallet: Wallet?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let sodaService: SodaServiceProtocol
    
    init(sodaService: SodaServiceProtocol = SodaService.shared) {
        self.sodaService = sodaService
    }
    
    func fetchWallet() async {
        isLoading = true
        errorMessage = nil
        
        do {
            self.wallet = try await sodaService.getWallet()
        } catch {
            self.errorMessage = error.localizedDescription
            print("Error fetching wallet: \(error)")
        }
        
        isLoading = false
    }
}