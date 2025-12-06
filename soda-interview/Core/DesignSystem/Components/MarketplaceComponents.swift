import SwiftUI

// MARK: - Components

struct MarketplaceInput: View {
    let title: String
    @Binding var text: String
    var isSecure: Bool = false
    var placeholder: String = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.marketplaceBody)
                .foregroundColor(Color.marketplace.primaryText)
            
            Group {
                if isSecure {
                    SecureField(placeholder, text: $text)
                } else {
                    TextField(placeholder, text: $text)
                }
            }
            .font(.marketplaceBody)
            .padding(16)
            .background(Color.white)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.marketplace.stroke, lineWidth: 1.5)
            )
        }
    }
}

struct MarketplaceButtonStyle: ButtonStyle {
    var isPrimary: Bool = true
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.marketplaceHeadlineMD)
            .foregroundColor(isPrimary ? .white : Color.marketplace.primaryText)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(isPrimary ? Color.marketplace.primaryAction : Color.white)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.marketplace.stroke, lineWidth: 1.5)
            )
            .opacity(configuration.isPressed ? 0.8 : 1.0)
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(.easeOut(duration: 0.1), value: configuration.isPressed)
    }
}

struct SocialLoginButton: View {
    let iconName: String
    let label: String
    let accentColor: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(accentColor)
                        .frame(width: 48, height: 48)
                        .overlay(
                            Circle()
                                .stroke(Color.marketplace.stroke, lineWidth: 1.5)
                        )
                    
                    Image(systemName: iconName)
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(Color.marketplace.primaryText)
                }
                
                Text(label)
                    .font(.marketplaceCaption)
                    .foregroundColor(Color.marketplace.primaryText)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(Color.white)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.marketplace.stroke, lineWidth: 1.5)
            )
        }
    }
}

// MARK: - Modifiers

struct MarketplaceBackgroundModifier: ViewModifier {
    func body(content: Content) -> some View {
        ZStack {
            Color.marketplace.background
                .ignoresSafeArea()
            
            GrainBackground(opacity: 0.05)
                .ignoresSafeArea()
            
            content
        }
    }
}

extension View {
    func marketplaceBackground() -> some View {
        modifier(MarketplaceBackgroundModifier())
    }
}

#Preview {
    VStack(spacing: 20) {
        MarketplaceInput(title: "Email", text: .constant(""), placeholder: "hello@example.com")
        
        Button("Login") {}
            .buttonStyle(MarketplaceButtonStyle())
        
        HStack(spacing: 16) {
            SocialLoginButton(iconName: "apple.logo", label: "Apple", accentColor: Color.marketplace.lavender) {}
            SocialLoginButton(iconName: "g.circle.fill", label: "Google", accentColor: Color.marketplace.softYellow) {}
        }
    }
    .padding()
    .marketplaceBackground()
}

// MARK: - Alerts

struct MarketplaceAlert<Actions: View, Message: View>: View {
    let title: String
    @Binding var isPresented: Bool
    let actions: Actions
    let message: Message
    
    init(
        title: String,
        isPresented: Binding<Bool>,
        @ViewBuilder actions: () -> Actions,
        @ViewBuilder message: () -> Message
    ) {
        self.title = title
        self._isPresented = isPresented
        self.actions = actions()
        self.message = message()
    }
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Text(title)
                    .font(.marketplaceHeadlineMD)
                    .foregroundColor(Color.marketplace.primaryText)
                
                message
                    .font(.marketplaceBody)
                    .foregroundColor(Color.marketplace.primaryText.opacity(0.8))
                    .multilineTextAlignment(.center)
                
                VStack(spacing: 12) {
                    actions
                }
                .buttonStyle(MarketplaceButtonStyle(isPrimary: false)) // Default style for alert buttons
            }
            .padding(24)
            .background(Color.white)
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.marketplace.stroke, lineWidth: 1.5)
            )
            .padding(24)
            .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
        }
        .zIndex(9999)
        .transition(.opacity)
    }
}

extension View {
    func marketplaceAlert<Actions: View, Message: View>(
        _ title: String,
        isPresented: Binding<Bool>,
        @ViewBuilder actions: @escaping () -> Actions,
        @ViewBuilder message: @escaping () -> Message
    ) -> some View {
        ZStack {
            self
            
            if isPresented.wrappedValue {
                MarketplaceAlert(
                    title: title,
                    isPresented: isPresented,
                    actions: actions,
                    message: message
                )
            }
        }
    }
}
