import Foundation
import UIKit
import SnapKit
import VragenSDKNetwork

protocol SurveyDisplayLogic: class {
    func displaySurvey(viewModel: Survey.Fetch.ViewModel)
    func displayError(error: Survey.Fetch.Error)

    func displayLoading()
    func hideLoading()

    func displayNextButtonEnabled()
    func displayNextButtonDisabled()
    func displaySubmitButton()

    func displayDismiss()

    func displayQuestion(at index: Int, direction: UIPageViewController.NavigationDirection)
}

class SurveyDetailViewController: UIViewController, SurveyDisplayLogic {
    var interactor: SurveyBusinessLogic!

    private let identifier: UUID
    private let userId: String?

    private var viewModel: Survey.Fetch.ViewModel?

    private let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    private var questionViewControllers: [UIViewController] = []

    private let bottomBar = SurveyBottomBarView()

    private let loadingView = SurveyLoadingView()

    init(identifier: UUID, userId: String?) {
        self.identifier = identifier
        self.userId = userId

        super.init(nibName: nil, bundle: nil)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder) not implemented")
    }

    // MARK: Setup

    private func setup() {
        let presenter = SurveyPresenter(viewController: self)
        let interactor = SurveyInteractor(presenter: presenter)

        self.interactor = interactor
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureViews()

        interactor.fetchSurvey(identifier: identifier, userId: userId)
    }

    // MARK: SurveyDisplayLogic

    func displaySurvey(viewModel: Survey.Fetch.ViewModel) {
        self.viewModel = viewModel

        // Create all the `QuestionViewController`'s that are going to be displayed in the `UIPageViewController`
        questionViewControllers = createViewControllers(viewModels: viewModel.questions)
        if let firstViewController = questionViewControllers.first {
            pageViewController.setViewControllers([firstViewController], direction: .forward, animated: false, completion: nil)
        }
    }

    func displayError(error: Survey.Fetch.Error) {
        let title = error.titleKey.localize()
        let confirm = error.confirmKey.localize()
        let alertController = UIAlertController(title: title, message: error.message, preferredStyle: .alert)

        alertController.addAction(.init(title: confirm, style: .default, handler: { [weak self] _ in
            self?.displayDismiss()
        }))

        self.present(alertController, animated: true, completion: nil)
    }

    func displayLoading() {
        bottomBar.isHidden = true
        loadingView.isHidden = false
    }

    func hideLoading() {
        bottomBar.isHidden = false
        loadingView.isHidden = true
    }

    func displayNextButtonEnabled() {
        bottomBar.buttonTitle = "vragensdk_next_button_title".localize()
        bottomBar.buttonTitleAccessibility = "vragensdk_next_button_title_accessibility".localize()
        bottomBar.isButtonEnabled = true

        UIAccessibility.post(notification: .screenChanged, argument: bottomBar)
    }

    func displayNextButtonDisabled() {
        bottomBar.buttonTitle = "vragensdk_next_button_title".localize()
        bottomBar.isButtonEnabled = false
    }

    func displaySubmitButton() {
        bottomBar.buttonTitle = "vragensdk_done_button_title".localize()
        bottomBar.buttonTitleAccessibility = "vragensdk_done_button_title_accessibility".localize()
        bottomBar.isButtonEnabled = true

        UIAccessibility.post(notification: .screenChanged, argument: bottomBar)
    }

    func displayDismiss() {
        dismiss(animated: true, completion: nil)
    }

    func displayQuestion(at index: Int, direction: UIPageViewController.NavigationDirection) {
        guard let nextViewController = questionViewControllers[safe: index] else { return }

        pageViewController.setViewControllers([nextViewController], direction: direction, animated: true) { [weak self] _ in
            self?.interactor.didScrollToPage(at: index)
        }
    }
}

private extension SurveyDetailViewController {
    var currentPageViewControllerIndex: Int? {
        guard let viewController = pageViewController.viewControllers?.first else { return nil }
        guard let viewControllerIndex = questionViewControllers.firstIndex(of: viewController) else { return nil }

        return viewControllerIndex
    }

    func createViewControllers(viewModels: [Survey.Fetch.ViewModel.Question]) -> [UIViewController] {
        return viewModels.map { (viewModel) -> UIViewController in
            return createViewController(viewModel: viewModel)
        }
    }

    func createViewController(viewModel: Survey.Fetch.ViewModel.Question) -> UIViewController {
        let controller = QuestionViewController(userId: viewModel.userId, surveyId: viewModel.surveyId, question: viewModel.question)
        controller.delegate = self
        return controller
    }
}

extension SurveyDetailViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = questionViewControllers.firstIndex(of: viewController) else { return nil }
        guard viewControllerIndex > 0 else { return nil }

        return questionViewControllers[viewControllerIndex - 1]
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = questionViewControllers.firstIndex(of: viewController) else { return nil }
        guard viewControllerIndex < questionViewControllers.count - 1 else { return nil }

        return questionViewControllers[viewControllerIndex + 1]
    }

    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return viewModel?.questions.count ?? 0
    }
}

extension SurveyDetailViewController: UIPageViewControllerDelegate {

    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard let currentIndex = currentPageViewControllerIndex else { return }

        interactor.didScrollToPage(at: currentIndex)
    }

}

extension SurveyDetailViewController: QuestionViewControllerDelegate {
    func questionViewControllerDidSelect(question id: UUID) {
        interactor.didSelectAnswer(question: id)
    }
}

extension SurveyDetailViewController: ConfigureViews {
    func configureView() {
        view.backgroundColor = .white
    }

    func configureSubviews() {
        pageViewController.dataSource = self
        pageViewController.delegate = self
        pageViewController.view.backgroundColor = .clear
        addChild(pageViewController)
        view.addSubview(pageViewController.view)
        pageViewController.didMove(toParent: self)

        bottomBar.layer.shadowColor = UIColor.black.cgColor
        bottomBar.layer.shadowOffset = CGSize(width: 0, height: 1)
        bottomBar.layer.shadowOpacity = 0.16
        bottomBar.layer.shadowRadius = 3
        bottomBar.isButtonEnabled = false
        bottomBar.onButtonTap = { [weak self] in
            guard let currentIndex = self?.currentPageViewControllerIndex else { return }
            self?.interactor.didSelectBottomButton(at: currentIndex)
        }
        view.addSubview(bottomBar)

        view.addSubview(loadingView)
    }

    func configureConstaints() {
        bottomBar.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview()
        }

        pageViewController.view.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(bottomBar.snp.top)
        }

        loadingView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
