import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var navigator: Navigator
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // Content
            TabView(selection: $navigator.selectedTab) {
                HomeView()
                    .tag(0)
                
                PostView()
                    .tag(1)
                
                WalletView()
                    .tag(2)
                
                SettingsView()
                    .tag(3)
            }
            .tabViewStyle(.page(indexDisplayMode: .never)) // Disable default tab bar
            .ignoresSafeArea(.keyboard) 
            
            // Custom Tab Bar
            if navigator.showTabBar {
                VStack(spacing: 0) {
                    Spacer()
                    CustomTabBar(selectedTab: $navigator.selectedTab)
                }
                .ignoresSafeArea(.keyboard)
            }
        }
        .ignoresSafeArea(.keyboard)
    }
}

#Preview {
    MainTabView()
        .environmentObject(Navigator())
}
