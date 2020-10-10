import UIKit

class SurveyLoadingView: UIView {

    private let activityIndicatorView: UIActivityIndicatorView = UIActivityIndicatorView()

    override var isHidden: Bool {
        didSet {
            if isHidden {
                activityIndicatorView.stopAnimating()
            } else {
                activityIndicatorView.startAnimating()
            }
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

extension SurveyLoadingView: ConfigureViews {

    func configureView() {
        backgroundColor = .white
        isAccessibilityElement = true
        accessibilityLabel = "vragensdk_loading_accessibility".localize()
    }

    func configureSubviews() {
        addSubview(activityIndicatorView)
    }

    func configureConstaints() {
        activityIndicatorView.snp.makeConstraints { make in
            make.centerY.centerX.equalToSuperview()
        }
    }
}
