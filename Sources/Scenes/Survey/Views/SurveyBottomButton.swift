import UIKit

private enum Constants {
    static let verticalMargin: CGFloat = 16
    static let horizontalMargin: CGFloat = 24
    static let cornerRadius: CGFloat = 4

    static let textColor: UIColor = .white

    enum Enabled {
        static let backgroundColor: UIColor = .init(red: 40.0/255, green: 40.0/255, blue: 161.0/255, alpha: 1)
    }

    enum Disabled {
        static let backgroundColor: UIColor = .lightGray
    }

    enum Highlighted {
        static let backgroundColor: UIColor = .darkGray
    }
}

class SurveyBottomButton: UIControl {

    private let titleLabel: UILabel = UILabel()

    var title: String = "" {
        didSet {
            titleLabel.text = title
            accessibilityLabel = title
        }
    }

    override var isEnabled: Bool {
        didSet {
            backgroundColor = isEnabled ? Constants.Enabled.backgroundColor : Constants.Disabled.backgroundColor
            accessibilityTraits = isEnabled ? .button : .notEnabled
        }
    }

    override var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? Constants.Highlighted.backgroundColor : Constants.Enabled.backgroundColor
        }
    }

    var onTap: (() -> Void)?

    init() {
        super.init(frame: .zero)

        configureViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension SurveyBottomButton {

    @objc
    func onTapAction() {
        self.onTap?()
    }
}

extension SurveyBottomButton: ConfigureViews {

    func configureView() {
        layer.cornerRadius = Constants.cornerRadius

        backgroundColor = Constants.Enabled.backgroundColor

        isAccessibilityElement = true
        accessibilityTraits = .button

        addTarget(self, action: #selector(onTapAction), for: .touchUpInside)
    }

    func configureSubviews() {
        titleLabel.text = title
        titleLabel.font = UIFont.preferredFont(forTextStyle: .body).bold()
        titleLabel.textColor = Constants.textColor
        addSubview(titleLabel)
    }

    func configureConstaints() {
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.top.bottom.greaterThanOrEqualToSuperview()
            make.trailing.leading.equalToSuperview().inset(Constants.horizontalMargin)
        }
    }
}
