import Foundation
import SwiftUI
import Combine

@MainActor
final class Navigator: ObservableObject {
    @Published var navigationPath: [Routes] = []
    @Published var startingPath: Routes = .login
    @Published var selectedTab: Int = 0
    @Published var showTabBar: Bool = false
    
    func navigateTo(_ route: Routes) {
        navigationPath.append(route)
        updateTabBarVisibility(for: route)
    }
    
    func pop() {
        if !navigationPath.isEmpty {
            navigationPath.removeLast()
        }
        
        if let lastRoute = navigationPath.last {
            updateTabBarVisibility(for: lastRoute)
        } else {
            // Stack is empty, we are at the root
            if startingPath == .mainTab {
                showTabBar = true
            } else {
                updateTabBarVisibility(for: startingPath)
            }
        }
    }
    
    func goBack() {
        if !navigationPath.isEmpty {
            pop()
        }
    }
    
    func setRoot(_ route: Routes) {
        startingPath = route
        navigationPath = []
        updateTabBarVisibility(for: route)
    }
    
    func switchToTab(_ tab: Int) {
        selectedTab = tab
        if startingPath != .mainTab {
             setRoot(.mainTab)
        }
    }
        
    private func updateTabBarVisibility(for route: Routes) {
        switch route {
        case .login, .signup:
            showTabBar = false
        case .mainTab:
            showTabBar = true
        default:
            // Default to false for pushed screens unless specified
            showTabBar = false 
        }
    }
}
