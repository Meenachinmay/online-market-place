import SwiftUI

enum Routes: Hashable {
    case login
    case signup
    case home
    case wallet
    case sodaRB
    case mainTab
    
    @ViewBuilder
    func view() -> some View {
        switch self {
        case .login:
            LoginView()
        case .signup:
            SignUpView(isPresented: .constant(true))
        case .home:
            HomeView()
        case .wallet:
            WalletView()
        case .sodaRB:
            SodaRBView()
        case .mainTab:
            MainTabView()
        }
    }
}
