import SwiftUI

extension Color {
    
    // MARK: - Design System Entry Points
    
    /// Palette for Backgrounds and Surfaces (Paper tones)
    static let paper = PaperPalette()
    
    /// Palette for Text and Icons (Ink tones)
    static let ink = InkPalette()
    
    /// Palette for Functional Signals (Action, Error, Success)
    static let signal = SignalPalette()
    
    // MARK: - Palettes
    
    struct PaperPalette {
        /// Darkest paper tone, used for thick borders or deep depth (#D9C298)
        let dark = Color(hex: "D9C298")
        
        /// Medium-dark paper, used for secondary backgrounds (#EBD4AA)
        let mediumDark = Color(hex: "EBD4AA")
        
        /// The primary aged newsprint background (#FBE2AA)
        let base = Color(hex: "FBE2AA")
        
        /// Light paper for active cards or high contrast areas (#FDF5E6)
        let light = Color(hex: "FDF5E6")
        
        /// The cleanest paper, effectively white (#FFFFFF)
        let veryLight = Color.white
    }
    
    struct InkPalette {
        /// Deepest black for primary text and headers (#000000)
        let primary = Color.black
        
        /// Dark charcoal for body text and secondary info (#2C2C2C)
        let secondary = Color(hex: "2C2C2C")
        
        /// Medium gray for disabled text, borders, or placeholders (#4A4A4A)
        let tertiary = Color(hex: "4A4A4A")
        
        /// Light gray for watermarks or subtle dividers (#808080)
        let quaternary = Color(hex: "808080")
    }
    
    struct SignalPalette {
        /// Primary action color (Saddle Brown #8B4513)
        let action = Color(hex: "8B4513")
        
        /// Error or Destructive color (Blood Red #8B0000)
        let error = Color(hex: "8B0000")
        
        /// Success or Validation color (Forest Green #228B22)
        let success = Color(hex: "228B22")
        
        /// Warning or Caution color (Mustard #FFDB58)
        let warning = Color(hex: "FFDB58")
    }

    // MARK: - Helper
    
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
