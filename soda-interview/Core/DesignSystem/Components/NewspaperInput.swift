import SwiftUI

struct NewspaperInput: View {
    let title: String
    @Binding var text: String
    var isSecure: Bool = false
    var error: String? = nil
    @FocusState private var isFocused: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.newspaperCaption.bold())
                .foregroundColor(Color.ink.primary)
                .textCase(.uppercase)
            
            Group {
                if isSecure {
                    SecureField("", text: $text)
                } else {
                    TextField("", text: $text)
                }
            }
            .focused($isFocused)
            .font(.newspaperBody)
            .padding(16)
            .background(Color.paper.veryLight)
            .newspaperBorder(width: (isFocused || error != nil) ? 2 : 1, color: (error != nil) ? Color.signal.error : Color.ink.secondary)
            .tint(Color.signal.action)
            // Subtle hard shadow for inputs to give depth
            .neoShadow(color: Color.ink.secondary.opacity(0.2), x: 4, y: 4)
            
            if let error = error, !error.isEmpty {
                HStack(alignment: .top, spacing: 6) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(.system(size: 10))
                        .padding(.top, 2)
                    Text(error)
                        .font(.newspaperFinePrint)
                        .italic()
                        .fixedSize(horizontal: false, vertical: true)
                }
                .foregroundColor(Color.signal.error)
                .padding(.leading, 4)
                .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.2), value: error)
    }
}

#Preview {
    ZStack {
        Color.paper.base.ignoresSafeArea()
        VStack(spacing: 20) {
            NewspaperInput(title: "Full Name", text: .constant("John Doe"))
            
            NewspaperInput(title: "Email", text: .constant("invalid-email"), error: "Please enter a valid email address.")
            
            NewspaperInput(title: "Password", text: .constant("Secret"), isSecure: true)
        }
        .padding()
    }
}
