import SwiftUI

struct ContentView: View {
    @StateObject private var navigator = Navigator()
    @StateObject private var authManager = AuthManager.shared
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // Global background
            Color.marketplace.background
                .ignoresSafeArea()
            
            // Grain Effect Overlay
            GrainBackground()
                .zIndex(100)
                .allowsHitTesting(false) // Pass touches through
            
            if authManager.isAuthenticated {
                // Authenticated -> Main App
                NavigationStack(path: $navigator.navigationPath) {
                    MainTabView()
                        .environmentObject(navigator)
                        .environmentObject(authManager)
                        .navigationBarBackButtonHidden(true)
                        .navigationDestination(for: Routes.self) { route in
                            route.view()
                                .environmentObject(navigator)
                                .environmentObject(authManager)
                                .navigationBarBackButtonHidden(true)
                        }
                }
                .onAppear {
                    // When switching to authenticated state, ensure navigator is set up correctly
                    // We don't necessarily need to force .mainTab here if MainTabView is the root view of this stack
                    // But we should ensure tabBar visibility
                    navigator.showTabBar = true
                }
            } else {
                // Not Authenticated -> Login Flow
                NavigationStack(path: $navigator.navigationPath) {
                    LoginView()
                        .environmentObject(navigator)
                        .environmentObject(authManager)
                        .navigationBarBackButtonHidden(true)
                        .navigationDestination(for: Routes.self) { route in
                            route.view()
                                .environmentObject(navigator)
                                .environmentObject(authManager)
                                .navigationBarBackButtonHidden(true)
                        }
                }
                .onAppear {
                     navigator.showTabBar = false
                }
            }
        }
        .ignoresSafeArea(.keyboard)
        .preferredColorScheme(.light)
        .onAppear {
            authManager.checkAuthStatus()
        }
    }
}

#Preview {
    ContentView()
}
