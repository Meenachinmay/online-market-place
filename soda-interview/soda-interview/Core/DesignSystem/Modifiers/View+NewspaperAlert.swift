import SwiftUI

extension View {
    /// Presents a newspaper-styled alert when the binding is true.
    /// - Parameters:
    ///   - title: The title of the alert.
    ///   - isPresented: A binding to whether the alert is currently presented.
    ///   - actions: A view builder returning the alert's actions (usually Buttons).
    ///   - message: A view builder returning the message content.
    func newspaperAlert<Actions: View, Message: View>(
        _ title: String,
        isPresented: Binding<Bool>,
        @ViewBuilder actions: @escaping () -> Actions,
        @ViewBuilder message: @escaping () -> Message
    ) -> some View {
        self.overlay(
            ZStack {
                if isPresented.wrappedValue {
                    NewspaperAlert(
                        title: title,
                        isPresented: isPresented,
                        actions: actions,
                        message: message
                    )
                }
            }
            .animation(.easeInOut(duration: 0.2), value: isPresented.wrappedValue)
        )
    }
    
    /// Convenience overload for text-only message strings.
    func newspaperAlert<Actions: View>(
        _ title: String,
        isPresented: Binding<Bool>,
        @ViewBuilder actions: @escaping () -> Actions,
        message: String
    ) -> some View {
        self.newspaperAlert(
            title,
            isPresented: isPresented,
            actions: actions,
            message: { Text(message) }
        )
    }
}
