import UIKit

extension UIFont {

    /// Return new UIFont with provided `UIFontDescriptor.SymbolicTraits`
    func withTraits(traits: UIFontDescriptor.SymbolicTraits) -> UIFont {
        let descriptor = fontDescriptor.withSymbolicTraits(traits)
        return UIFont(descriptor: descriptor!, size: 0) //size 0 means keep the size as it is
    }

    /// Returns UIFont as bold when the bold font trait is available
    func bold() -> UIFont {
        return withTraits(traits: .traitBold)
    }

    /// Returns UIFont as italic when the bold font trait is available
    func italic() -> UIFont {
        return withTraits(traits: .traitItalic)
    }

    /// Returns UIFont as regular when the bold font trait is available
    func regular() -> UIFont {
        return withTraits(traits: .classMask)
    }
}
