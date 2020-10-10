import UIKit

private enum Constants {
    static let backgroundColor: UIColor = .white

    static let verticalMargin: CGFloat = 12
    static let horizontalMargin: CGFloat = 16

    enum Separator {
        static let color: UIColor = UIColor(red: 230.0/255, green: 230.0/255, blue: 230.0/255, alpha: 1)
        static let height: CGFloat = 1
    }

    enum Button {
        static let height: CGFloat = 44
    }
}

class SurveyBottomBarView: UIView {
    private let separatorView = UIView()
    private let button = SurveyBottomButton()

    var isButtonEnabled: Bool = false {
        didSet {
            button.isEnabled = isButtonEnabled
        }
    }

    var onButtonTap: (() -> Void)? {
        didSet {
            button.onTap = onButtonTap
        }
    }

    var buttonTitle: String = "" {
        didSet {
            button.title = buttonTitle
        }
    }

    var buttonTitleAccessibility: String = "" {
        didSet {
            button.accessibilityLabel = buttonTitleAccessibility
        }
    }

    init() {
        super.init(frame: .zero)
        configureViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SurveyBottomBarView: ConfigureViews {
    func configureView() {
        backgroundColor = Constants.backgroundColor
    }

    func configureSubviews() {
        separatorView.backgroundColor = Constants.Separator.color
        addSubview(separatorView)

        addSubview(button)
    }

    func configureConstaints() {
        separatorView.snp.makeConstraints { make in
            make.leading.top.trailing.equalToSuperview()
            make.height.equalTo(Constants.Separator.height)
        }

        button.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(Constants.verticalMargin)
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).inset(Constants.verticalMargin)
            make.trailing.equalToSuperview().inset(Constants.horizontalMargin)
            make.height.equalTo(Constants.Button.height)
        }
    }
}
