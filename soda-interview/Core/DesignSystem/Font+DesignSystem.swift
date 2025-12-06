import SwiftUI

extension Font {
    // MARK: - Newspaper Typography
    
    /// For Masthead ONLY (equivalent to 6rem/4rem)
    static let newspaperMasthead: Font = .system(size: 48, weight: .black, design: .serif)
    
    /// Primary Headlines (equivalent to 4rem/2.5rem)
    static let newspaperHeadlineXL: Font = .system(size: 36, weight: .bold, design: .serif)
    
    /// Section Headlines (equivalent to 2.5rem/1.75rem)
    static let newspaperHeadlineLG: Font = .system(size: 28, weight: .bold, design: .serif)
    
    /// Sub-headlines (equivalent to 1.5rem/1.25rem)
    static let newspaperHeadlineMD: Font = .system(size: 20, weight: .semibold, design: .serif)
    
    /// Small Headlines
    static let newspaperHeadlineSM: Font = .system(size: 18, weight: .semibold, design: .serif)
    
    /// Body Text (equivalent to 1rem)
    static let newspaperBody: Font = .system(size: 16, weight: .regular, design: .serif)
    
    /// Small Text (equivalent to 0.875rem)
    static let newspaperCaption: Font = .system(size: 14, weight: .regular, design: .serif)
    
    /// Fine Print (equivalent to 0.75rem)
    static let newspaperFinePrint: Font = .system(size: 12, weight: .regular, design: .serif)
    
    // MARK: - Functional UI Fonts (Modern/Sans)
    // Only use when absolutely necessary for readability in small UI controls
    
    static let newspaperUI: Font = .system(size: 14, weight: .medium, design: .default)
}
