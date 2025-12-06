import SwiftUI

struct NewspaperBorderModifier: ViewModifier {
    let width: CGFloat
    let color: Color
    let double: Bool
    let ornate: Bool
    
    func body(content: Content) -> some View {
        let borderedContent = Group {
            if double {
                content
                    .padding(3)
                    .overlay(
                        Rectangle()
                            .stroke(color, lineWidth: 1)
                    )
                    .padding(2)
                    .overlay(
                        Rectangle()
                            .stroke(color, lineWidth: 1)
                    )
            } else {
                content
                    .overlay(
                        Rectangle()
                            .stroke(color, lineWidth: width)
                    )
            }
        }
        
        if ornate {
            borderedContent.overlay(
                ZStack {
                    OrnateCorner(color: color)
                        .rotationEffect(.degrees(0))
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                        .offset(x: 2, y: 2)
                    
                    OrnateCorner(color: color)
                        .rotationEffect(.degrees(90))
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                        .offset(x: -2, y: 2)
                    
                    OrnateCorner(color: color)
                        .rotationEffect(.degrees(180))
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                        .offset(x: -2, y: -2)
                    
                    OrnateCorner(color: color)
                        .rotationEffect(.degrees(270))
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
                        .offset(x: 2, y: -2)
                }
                .allowsHitTesting(false) // Ensure touches pass through ornaments
            )
        } else {
            borderedContent
        }
    }
}

struct NeoBrutalistShadowModifier: ViewModifier {
    let color: Color
    let x: CGFloat
    let y: CGFloat
    
    func body(content: Content) -> some View {
        content
            .background(
                Rectangle()
                    .fill(color)
                    .offset(x: x, y: y)
            )
    }
}

extension View {
    func newspaperBorder(width: CGFloat = 1, color: Color = Color.ink.tertiary) -> some View {
        modifier(NewspaperBorderModifier(width: width, color: color, double: false, ornate: false))
    }
    
    func newspaperBorderThick(color: Color = Color.ink.secondary) -> some View {
        modifier(NewspaperBorderModifier(width: 1.5, color: color, double: false, ornate: true))
    }
    
    func newspaperBorderOrnate(color: Color = Color.ink.tertiary) -> some View {
        modifier(NewspaperBorderModifier(width: 1, color: color, double: true, ornate: true))
    }
    
    func newspaperBackground() -> some View {
        self.background(Color.paper.base)
    }
    
    /// Adds a hard, non-blurred shadow characteristic of Neobrutalism
    func neoShadow(color: Color = Color.ink.secondary, x: CGFloat = 4, y: CGFloat = 4) -> some View {
        modifier(NeoBrutalistShadowModifier(color: color, x: x, y: y))
    }
}
