import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var navigator: Navigator
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // Content
            TabView(selection: $navigator.selectedTab) {
                HomeView()
                    .tag(0)
                
                WalletView()
                    .tag(1)
                
                SodaRBView()
                    .tag(2)
            }
            .tabViewStyle(.page(indexDisplayMode: .never)) // Disable default tab bar
            .ignoresSafeArea(.keyboard) 
            
            // Custom Tab Bar
            if navigator.showTabBar {
                CustomTabBar(selectedTab: $navigator.selectedTab)
            }
        }
        .ignoresSafeArea(.keyboard)
    }
}

#Preview {
    MainTabView()
        .environmentObject(Navigator())
}
