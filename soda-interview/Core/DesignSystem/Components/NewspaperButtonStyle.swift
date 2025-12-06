import SwiftUI

struct NewspaperButtonStyle: ButtonStyle {
    var isUrgent: Bool = false
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(isUrgent ? .newspaperHeadlineMD : .newspaperBody)
            .textCase(isUrgent ? .uppercase : .none)
            .padding(.horizontal, 24)
            .padding(.vertical, 12)
            .frame(maxWidth: .infinity)
            .background(
                // Invert colors on press
                configuration.isPressed ? Color.ink.primary : (isUrgent ? Color.signal.action : Color.paper.veryLight)
            )
            .foregroundColor(
                configuration.isPressed ? Color.paper.veryLight : (isUrgent ? Color.paper.veryLight : Color.ink.primary)
            )
            .newspaperBorder(width: 1.5, color: Color.ink.secondary)
            // Neobrutalist Hard Shadow
            .neoShadow(color: Color.ink.secondary, x: configuration.isPressed ? 0 : 4, y: configuration.isPressed ? 0 : 4)
            // Offset the whole button to simulate "pressing" down into the shadow
            .offset(x: configuration.isPressed ? 4 : 0, y: configuration.isPressed ? 4 : 0)
            .animation(.easeOut(duration: 0.1), value: configuration.isPressed)
    }
}

#Preview {
    ZStack {
        Color.paper.base.ignoresSafeArea()
        VStack(spacing: 30) {
            Button("Standard Action") {}
                .buttonStyle(NewspaperButtonStyle())
            
            Button("Urgent Action") {}
                .buttonStyle(NewspaperButtonStyle(isUrgent: true))
        }
        .padding()
    }
}
