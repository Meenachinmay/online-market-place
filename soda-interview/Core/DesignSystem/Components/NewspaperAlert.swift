import SwiftUI

/// A custom alert view that follows the newspaper design system.
/// It mimics the standard SwiftUI alert but with custom styling.
struct NewspaperAlert<Actions: View, Message: View>: View {
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
            // Dimmed background
            Color.black.opacity(0.6)
                .ignoresSafeArea()
                .onTapGesture {
                    // Consider if we want tap-to-dismiss or force user action
                    // For critical alerts, forcing action is often better.
                }
            
            // Alert Content
            VStack(spacing: 0) {
                // Header Strip
                HStack {
                    Image(systemName: "exclamationmark.triangle.fill")
                    Text("NOTICE")
                        .font(.newspaperHeadlineSM)
                        .textCase(.uppercase)
                    Spacer()
                }
                .padding(12)
                .foregroundColor(Color.paper.veryLight)
                .background(Color.ink.primary)
                
                // Body
                VStack(spacing: 20) {
                    Text(title)
                        .font(.newspaperHeadlineLG)
                        .foregroundColor(Color.ink.primary)
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    Divider()
                        .background(Color.ink.tertiary)
                    
                    message
                        .font(.newspaperBody)
                        .foregroundColor(Color.ink.primary)
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    Spacer().frame(height: 4)
                    
                    // Actions Container
                    VStack(spacing: 12) {
                        actions
                    }
                    // Apply button style to all buttons within the actions closure
                    .buttonStyle(NewspaperButtonStyle(isUrgent: false))
                }
                .padding(24)
                .background(Color.paper.light)
            }
            .frame(maxWidth: 320)
            .newspaperBorderThick()
            .neoShadow(x: 8, y: 8)
            .padding()
        }
        .zIndex(9999) // Ensure it floats above everything
        .transition(.opacity.combined(with: .scale(scale: 0.95)))
    }
}

// Convenience init for when message is just text
extension NewspaperAlert where Message == Text {
    init(
        title: String,
        isPresented: Binding<Bool>,
        @ViewBuilder actions: () -> Actions,
        messageText: String
    ) {
        self.init(
            title: title,
            isPresented: isPresented,
            actions: actions,
            message: { Text(messageText) }
        )
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State private var showSimpleAlert = true
        @State private var showActionAlert = false
        
        var body: some View {
            ZStack {
                Color.paper.base.ignoresSafeArea()
                
                VStack(spacing: 20) {
                    Button("Show Simple Alert") {
                        showSimpleAlert = true
                    }
                    .buttonStyle(NewspaperButtonStyle())
                    
                    Button("Show Action Alert") {
                        showActionAlert = true
                    }
                    .buttonStyle(NewspaperButtonStyle(isUrgent: true))
                }
                .padding()
                
                if showSimpleAlert {
                    NewspaperAlert(
                        title: "Error",
                        isPresented: $showSimpleAlert,
                        actions: {
                            Button("Dismiss") {
                                showSimpleAlert = false
                            }
                        },
                        messageText: "Something went wrong with the printing press."
                    )
                }
                
                if showActionAlert {
                    NewspaperAlert(
                        title: "Confirm",
                        isPresented: $showActionAlert,
                        actions: {
                            Button("Proceed") {
                                showActionAlert = false
                            }
                            .buttonStyle(NewspaperButtonStyle(isUrgent: true))
                            
                            Button("Cancel") {
                                showActionAlert = false
                            }
                        },
                        message: {
                            Text("Are you sure you want to publish this article without review?")
                        }
                    )
                }
            }
        }
    }
    
    return PreviewWrapper()
}
