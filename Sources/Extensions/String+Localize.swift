import Foundation

extension String {

    func localize() -> String {
        return NSLocalizedString(self, bundle: .module, comment: "I have no comment 🤷‍♂️")
    }
}
