import UIKit

public class SurveyViewController: UINavigationController {
    public init(identifier: UUID, userId: String? = nil) {
        let viewController = SurveyDetailViewController(identifier: identifier, userId: userId)

        super.init(rootViewController: viewController)

        viewController.navigationItem.rightBarButtonItem = createSaveCloseButton()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        // Remove the transparency in the navigation bar
        navigationBar.isTranslucent = false

        // Remove the shadow from the navigation bar
        navigationBar.setValue(true, forKey: "hidesShadow")
    }
}

private extension SurveyViewController {
    func createSaveCloseButton() -> UIBarButtonItem {
        let closeButton = UIButton(type: .custom)

        let title = "vragensdk_close_button_title".localize()
        let attributes: [NSAttributedString.Key: Any] = [
            .underlineStyle: NSUnderlineStyle.single.rawValue,
        ]
        let attributedString = NSAttributedString(string: title, attributes: attributes)

        let highlightedAttributes: [NSAttributedString.Key: Any] = [
            .underlineStyle: NSUnderlineStyle.single.rawValue,
            .foregroundColor: UIColor.darkGray,
        ]
        let highlightedAttributedString = NSAttributedString(string: title, attributes: highlightedAttributes)

        closeButton.setAttributedTitle(attributedString, for: .normal)
        closeButton.setAttributedTitle(highlightedAttributedString, for: .highlighted)
        closeButton.addTarget(self, action: #selector(dismissNavigationViewController), for: .touchUpInside)
        return UIBarButtonItem(customView: closeButton)
    }

    @objc
    func dismissNavigationViewController() {
        dismiss(animated: true, completion: nil)
    }
}
