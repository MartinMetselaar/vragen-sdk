import Moya
import VragenAPIModels

protocol SurveyPresentationLogic {
    func presentSurvey(response: Survey.Fetch.Response)
    func presentError(error: MoyaError)

    func presentLoading()
    func hideLoading()

    func presentNextButtonEnabled()
    func presentNextButtonDisabled()
    func presentSubmitButton()

    func presentDismiss()

    func presentQuestion(at index: Int, currentIndex: Int)
}

class SurveyPresenter: SurveyPresentationLogic {
    private weak var viewController: SurveyDisplayLogic?

    init(viewController: SurveyDisplayLogic) {
        self.viewController = viewController
    }

    func presentSurvey(response: Survey.Fetch.Response) {
        viewController?.displaySurvey(viewModel: .init(title: response.data.title, questions: response.data.questions.map({ question -> Survey.Fetch.ViewModel.Question in
            .init(userId: response.userId, surveyId: response.surveyId, question: question)
        })))
    }

    func presentError(error: MoyaError) {
        viewController?.displayError(
            error: .init(
                titleKey: "vragensdk_error_title",
                message: error.localizedDescription,
                confirmKey: "vragensdk_error_confirm_title"
            )
        )
    }

    func presentLoading() {
        viewController?.displayLoading()
    }

    func hideLoading() {
        viewController?.hideLoading()
    }

    func presentNextButtonEnabled() {
        viewController?.displayNextButtonEnabled()
    }

    func presentNextButtonDisabled() {
        viewController?.displayNextButtonDisabled()
    }

    func presentSubmitButton() {
        viewController?.displaySubmitButton()
    }

    func presentDismiss() {
        viewController?.displayDismiss()
    }

    func presentQuestion(at index: Int, currentIndex: Int) {
        // Display the question but also check if the index is the (next) index or a previous index.
        // When the index is larger than the current index we want to move forward
        viewController?.displayQuestion(at: index, direction: index > currentIndex ?  .forward : .reverse)
    }
}
