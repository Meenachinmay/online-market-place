import SwiftUI

struct OrnateCorner: View {
    let color: Color
    
    var body: some View {
        Canvas { context, size in
            // Draw a vintage "wrought iron" style flourish
            var path = Path()
            
            let w = size.width
            let h = size.height
            
            // Main corner curve
            path.move(to: CGPoint(x: w, y: 2))
            path.addCurve(
                to: CGPoint(x: 2, y: h),
                control1: CGPoint(x: w * 0.3, y: 2),
                control2: CGPoint(x: 2, y: h * 0.3)
            )
            
            // Inner decorative loop (fleur-like)
            path.move(to: CGPoint(x: w * 0.4, y: h * 0.4))
            path.addQuadCurve(to: CGPoint(x: w * 0.7, y: h * 0.1), control: CGPoint(x: w * 0.5, y: h * 0.1))
            
            // Dot/Accent
            let dotRect = CGRect(x: 3, y: 3, width: 3, height: 3)
            context.fill(Path(ellipseIn: dotRect), with: .color(color))
            
            context.stroke(path, with: .color(color), lineWidth: 1.5)
        }
        .frame(width: 24, height: 24)
    }
}

#Preview {
    ZStack {
        Color.paper.veryLight
        OrnateCorner(color: .ink.primary)
            .border(Color.red.opacity(0.2))
    }
    .frame(width: 100, height: 100)
}
