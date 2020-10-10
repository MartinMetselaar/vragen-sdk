import Foundation
import UIKit
import VragenSDKNetwork
import VragenAPIModels

protocol SurveyBusinessLogic {
    func fetchSurvey(identifier: UUID, userId: String?)

    func didScrollToPage(at index: Int)
    func didSelectAnswer(question: UUID)

    func didSelectBottomButton(at index: Int)
}

class SurveyInteractor: SurveyBusinessLogic {
    private let presenter: SurveyPresentationLogic

    private let client: SurveyAsynchroniseNetworkable

    private var survey: SurveyWithQuestionsResponse?
    private var answeredQuestions: Set<UUID>

    init(presenter: SurveyPresentationLogic,
         client: SurveyAsynchroniseNetworkable = SurveyAsynchroniseNetwork(),
         answeredQuestions: Set<UUID> = Set(),
         survey: SurveyWithQuestionsResponse? = nil
         ) {
        self.presenter = presenter
        self.client = client

        self.answeredQuestions = answeredQuestions
        self.survey = survey
    }

    func fetchSurvey(identifier: UUID, userId: String?) {
        presenter.presentLoading()
        presenter.presentNextButtonDisabled()

        // When there is no user identifier provided we create a random one
        let userId = userId ?? UUID().uuidString

        // Get the survey with questions and answers from the server
        client.getWithChildren(identifier: identifier) { [weak self] result in
            switch result {
                case .success(let survey):
                    self?.survey = survey
                    self?.presenter.presentSurvey(response: .init(data: survey, userId: userId, surveyId: survey.id))
                case .failure(let error):
                    self?.presenter.presentError(error: error)
            }

            self?.presenter.hideLoading()
        }
    }

    func didScrollToPage(at index: Int) {
        guard let questionId = survey?.questions[safe: index]?.id else { return }
        if answeredQuestions.count == survey?.questions.count {
            // First needed to check if all the questions are answered
            presenter.presentSubmitButton()
        } else if answeredQuestions.contains(questionId) {
            // When the question that is currently displayed is already answered
            presenter.presentNextButtonEnabled()
        } else {
            // When the question is not yet answered
            presenter.presentNextButtonDisabled()
        }
    }

    func didSelectAnswer(question: UUID) {
        answeredQuestions.insert(question) // Store the id of the answered question
        if answeredQuestions.count == survey?.questions.count {
            // Check if this was the final question that needed answering
            presenter.presentSubmitButton()
        } else {
            // There is still a question unanswered so display the next button
            presenter.presentNextButtonEnabled()
        }
    }

    func didSelectBottomButton(at index: Int) {
        let nextIndex = index + 1
        if answeredQuestions.count == survey?.questions.count {
            // When all the questions are answered, the submit button is displayed, and we can dismiss the survey
            presenter.presentDismiss()
        } else if nextIndex == survey?.questions.count {
            // When the end is reached (but not all the questions are answered), we want to show the user the unanswered question
            // Search for the first unanswered question
            let nextQuestionIndex = survey?.questions.firstIndex(where: { !answeredQuestions.contains($0.id) })

            // Present the unanswered question
            presenter.presentQuestion(at: nextQuestionIndex ?? -1, currentIndex: index)
        } else {
            // Go to the next question
            presenter.presentQuestion(at: nextIndex, currentIndex: index)
        }
    }
}

extension SurveyAsynchroniseNetwork {
    convenience init() {
        guard let settings = VragenSDK.settings else {
            fatalError("Did not initialise VragenSDK. Initialise by using VragenSDK#set(url:token:)")
        }


        let url = URL(string: "https://vragenapi.example.org")!
        let token = "the-correct-token-from-your-server"
        let client = SurveyAsynchroniseNetwork(server: url, token: token)
        client.getWithChildren(identifier: UUID()) { (result) in

        }

        self.init(server: settings.server, token: settings.token)
    }
}
