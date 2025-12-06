import SwiftUI

struct NewspaperHeader<Content: View>: View {
    let title: String
    let topSafeArea: CGFloat
    let backAction: (() -> Void)?
    let content: Content
    
    init(
        title: String,
        topSafeArea: CGFloat = 0,
        backAction: (() -> Void)? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.title = title
        self.topSafeArea = topSafeArea
        self.backAction = backAction
        self.content = content()
    }
    
    var body: some View {
        VStack(spacing: 4) {
            ZStack {
                if let backAction = backAction {
                    HStack {
                        Button(action: backAction) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 22, weight: .black)) // Larger & Bolder
                                .foregroundColor(Color.ink.primary)
                                .padding(12) // Larger touch area
                                .contentShape(Rectangle())
                        }
                        .padding(.leading, 4) // Tighter to the edge
                        
                        Spacer()
                    }
                }
                
                Text(title)
                    .font(.newspaperHeadlineLG)
                    .foregroundColor(Color.ink.primary)
                    .multilineTextAlignment(.center)
                    .textCase(.uppercase)
                    .padding(.top, -10) // Lift text further up to minimize gap
            }
            .padding(.top, topSafeArea > 0 ? topSafeArea : 24)
            
            content
        }
        .padding(.bottom, 16)
        .frame(maxWidth: .infinity)
        .background(Color.paper.veryLight)
        .overlay(
            Rectangle()
                .frame(height: 1)
                .foregroundColor(Color.ink.tertiary),
            alignment: .bottom
        )
    }
}

extension NewspaperHeader where Content == Text {
    init(title: String, subtitle: String, topSafeArea: CGFloat = 0, backAction: (() -> Void)? = nil) {
        self.title = title
        self.topSafeArea = topSafeArea
        self.backAction = backAction
        self.content = Text(subtitle)
            .font(.newspaperBody.italic())
            .foregroundColor(Color.ink.secondary)
    }
}

extension NewspaperHeader where Content == EmptyView {
    init(title: String, topSafeArea: CGFloat = 0, backAction: (() -> Void)? = nil) {
        self.title = title
        self.topSafeArea = topSafeArea
        self.backAction = backAction
        self.content = EmptyView()
    }
}

#Preview {
    ZStack {
        Color.paper.base.ignoresSafeArea()
        VStack(spacing: 40) {
            NewspaperHeader(title: "The Daily News", subtitle: "Vol. 1 - No. 1")
            
            NewspaperHeader(title: "Simple Header")
            
            NewspaperHeader(title: "Custom Content") {
                HStack {
                    Text("Left Item")
                    Spacer()
                    Text("Right Item")
                }
                .font(.newspaperFinePrint)
                .padding(.horizontal)
            }
        }
    }
}
