import SwiftUI

struct GrainBackground: View {
    let opacity: Double
    
    init(opacity: Double = 0.08) {
        self.opacity = opacity
    }
    
    var body: some View {
        GeometryReader { geometry in
            Image(uiImage: NoiseTexture.generate(size: CGSize(width: 128, height: 128)))
                .resizable(resizingMode: .tile)
                .opacity(opacity)
                .blendMode(.multiply)
                .ignoresSafeArea()
        }
    }
}

private struct NoiseTexture {
    static func generate(size: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { context in
            UIColor.white.withAlphaComponent(0).setFill()
            context.fill(CGRect(origin: .zero, size: size))
            
            let rect = CGRect(origin: .zero, size: size)
            for _ in 0..<Int(size.width * size.height * 0.5) {
                let x = CGFloat.random(in: 0...size.width)
                let y = CGFloat.random(in: 0...size.height)
                let pointRect = CGRect(x: x, y: y, width: 1, height: 1)
                
                let gray = CGFloat.random(in: 0...1)
                UIColor(white: gray, alpha: 1.0).setFill()
                context.fill(pointRect)
            }
        }
    }
}

#Preview {
    ZStack {
        Color.paper.base
        GrainBackground(opacity: 0.1)
    }
}
