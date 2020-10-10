import UIKit


private enum Constants {
    static let margin: CGFloat = 16
    static let cornerRadius: CGFloat = 6
    static let borderWidth: CGFloat = 1

    static let textColor: UIColor = .init(red: 30.0/255, green: 30.0/255, blue: 30.0/255, alpha: 1)

    enum Checkmark {
        static let size: CGFloat = 24
        static let margin: CGFloat = 8
    }

    enum Selected {
        static let backgroundColor: UIColor = UIColor(red: 240.0/255, green: 240.0/255, blue: 240.0/255, alpha: 1)//UIColor.init(red: 161.0/255, green: 161.0/255, blue: 161.0/255, alpha: 1)
        static let borderColor: CGColor = UIColor.init(red: 140.0/255, green: 140.0/255, blue: 161.0/255, alpha: 1).cgColor
    }

    enum NotSelected {
        static let backgroundColor: UIColor = .clear
        static let borderColor: CGColor = UIColor(red: 240.0/255, green: 240.0/255, blue: 240.0/255, alpha: 1).cgColor
    }
}

/// `AnserButton` is the view which is used to display an unselected and selected answer
class AnswerButton: UIControl {

    private let title: String
    private let checkmarkView: AnswerButtonCheckmark = AnswerButtonCheckmark()
    private let titleLabel: UILabel = UILabel()

    override var isSelected: Bool {
        didSet {
            backgroundColor = isSelected ? Constants.Selected.backgroundColor : Constants.NotSelected.backgroundColor
            layer.borderColor = isSelected ? Constants.Selected.borderColor : Constants.NotSelected.borderColor

            titleLabel.font = isSelected ? titleLabel.font.bold() : titleLabel.font.regular()

            checkmarkView.isSelected = isSelected
        }
    }

    override var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? Constants.Selected.backgroundColor : Constants.NotSelected.backgroundColor
            layer.borderColor = isHighlighted ? Constants.Selected.borderColor : Constants.NotSelected.borderColor

            titleLabel.font = isHighlighted ? titleLabel.font.bold() : titleLabel.font.regular()

            checkmarkView.isHighlighted = isHighlighted
        }
    }

    init(title: String) {
        self.title = title
        super.init(frame: .zero)

        configureViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension AnswerButton: ConfigureViews {

    func configureView() {
        layer.cornerRadius = Constants.cornerRadius
        layer.borderWidth = Constants.borderWidth
        layer.borderColor = Constants.NotSelected.borderColor

        backgroundColor = Constants.NotSelected.backgroundColor

        isAccessibilityElement = true
        accessibilityLabel = title
    }

    func configureSubviews() {
        titleLabel.text = title
        titleLabel.font = UIFont.preferredFont(forTextStyle: .body)
        titleLabel.textColor = Constants.textColor
        addSubview(titleLabel)

        addSubview(checkmarkView)
    }

    func configureConstaints() {
        checkmarkView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(Constants.Checkmark.margin)
            make.centerY.equalToSuperview()
            make.height.equalTo(Constants.Checkmark.size)
            make.width.equalTo(checkmarkView.snp.height)
        }

        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(checkmarkView.snp.trailing).offset(Constants.Checkmark.margin)
            make.top.bottom.equalToSuperview().inset(Constants.margin)
            make.trailing.equalToSuperview().inset(Constants.margin)
        }
    }
}
