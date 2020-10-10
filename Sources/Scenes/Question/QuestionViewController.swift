import Foundation
import UIKit
import VragenAPIModels

private enum Constants {
    static let horizontalMargin: CGFloat = 16
    static let verticalMargin: CGFloat = 16

    static let spacing: CGFloat = 16
}

protocol QuestionDisplayLogic: class {
    func displayQuestion(viewModel: Question.Fetch.ViewModel)
}

protocol QuestionViewControllerDelegate: class {
    func questionViewControllerDidSelect(question id: UUID)
}

class QuestionViewController: UIViewController, QuestionDisplayLogic {
    var interactor: QuestionBusinessLogic!

    private let titleLabel = UILabel()
    private let buttonStackView = UIStackView()
    private let scrollView = UIScrollView()

    weak var delegate: QuestionViewControllerDelegate?
    private let questionId: UUID

    init(userId: String, surveyId: UUID, question: QuestionWithAnswersResponse) {
        questionId = question.id
        super.init(nibName: nil, bundle: nil)

        setup(userId: userId, surveyId: surveyId, question: question)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder) not implemented")
    }

    // MARK: Setup

    private func setup(userId: String, surveyId: UUID, question: QuestionWithAnswersResponse) {
        let presenter = QuestionPresenter(viewController: self)
        let interactor = QuestionInteractor(presenter: presenter, userId: userId, surveyId: surveyId, question: question)

        self.interactor = interactor
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        configureViews()

        interactor.fetchQuestion()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        UIAccessibility.post(notification: .screenChanged, argument: titleLabel)
    }

    // MARK: SurveyDisplayLogic
    func displayError(error: Question.Fetch.Error) {
        print("Error: \(error.title)")
    }

    func displayQuestion(viewModel: Question.Fetch.ViewModel) {
        // Clean slate
        buttonStackView.removeAllArrangedSubviews()

        titleLabel.text = viewModel.title

        // Create an `AnswerButton` for each answer
        viewModel.answers.forEach { (answer) in
            let button = AnswerButton(title: answer.title)
            button.isSelected = answer.selected
            button.addTarget(self, action: #selector(didSelectAnswer), for: .touchUpInside)
            buttonStackView.addArrangedSubview(button)
        }
    }

    @objc
    func didSelectAnswer(button: UIButton) {
        guard let index = buttonStackView.arrangedSubviews.firstIndex(of: button) else { return }
        interactor.didSelectAnswer(index: index)

        delegate?.questionViewControllerDidSelect(question: questionId)
    }
}

extension QuestionViewController: ConfigureViews {
    func configureView() {
        view.backgroundColor = .white
    }

    func configureSubviews() {
        titleLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        titleLabel.numberOfLines = 0
        view.addSubview(titleLabel)

        view.addSubview(scrollView)

        buttonStackView.axis = .vertical
        buttonStackView.spacing = Constants.spacing
        buttonStackView.alignment = .fill
        buttonStackView.distribution = .fill
        scrollView.addSubview(buttonStackView)
    }

    func configureConstaints() {
        titleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(Constants.horizontalMargin)
            make.top.equalToSuperview().offset(Constants.verticalMargin)
        }

        scrollView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(Constants.spacing)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }

        buttonStackView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.trailing.leading.equalToSuperview().offset(Constants.horizontalMargin)
            make.width.equalTo(scrollView).inset(Constants.horizontalMargin)
            make.bottom.equalToSuperview().inset(Constants.spacing)
        }
    }
}

