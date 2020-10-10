import UIKit

// Thanks to: https://gist.github.com/Deub27/5eadbf1b77ce28abd9b630eadb95c1e2
extension UIStackView {


    /// Remove all arranged subviews including the nested subviews
    /// - Returns: all the removed arranged subviews
    @discardableResult
    func removeAllArrangedSubviews() -> [UIView] {
        return arrangedSubviews.reduce([UIView]()) {
            $0 + [removeArrangedSubviewProperly($1)]
        }
    }

    /// Remove an arrange subview by also deactivating the constraints and finally removing it from super view
    /// - Parameter view: view that needs to be removed
    /// - Returns: the removed view
    func removeArrangedSubviewProperly(_ view: UIView) -> UIView {
        removeArrangedSubview(view)
        NSLayoutConstraint.deactivate(view.constraints)
        view.removeFromSuperview()
        return view
    }
}
