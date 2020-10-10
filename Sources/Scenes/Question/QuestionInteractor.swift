import Foundation
import UIKit
import VragenSDKNetwork
import VragenAPIModels

protocol QuestionBusinessLogic {
    func fetchQuestion()
    func didSelectAnswer(index: Int)
}

class QuestionInteractor: QuestionBusinessLogic {
    private let presenter: QuestionPresentationLogic
    private let client: SubmitAnswerAsynchroniseNetworkable

    private let userId: String
    private let surveyId: UUID
    private let question: QuestionWithAnswersResponse

    private var selectedAnswer: UUID? = nil

    init(presenter: QuestionPresentationLogic,
         userId: String,
         surveyId: UUID,
         question: QuestionWithAnswersResponse,
         client: SubmitAnswerAsynchroniseNetworkable = SubmitAnswerAsynchroniseNetwork()
    ) {
        self.presenter = presenter
        self.userId = userId
        self.surveyId = surveyId
        self.question = question
        self.client = client
    }

    func fetchQuestion() {
        let response = Question.Fetch.Response(data: question, selected: selectedAnswer)
        presenter.presentQuestion(response: response)
    }

    func didSelectAnswer(index: Int) {
        guard let answer = question.answers[safe: index] else { return }

        // Submit the answer on the question from the survey by the user to the server
        client.submit(userId: userId, surveyId: surveyId, questionId: question.id, answerId: answer.id) { (result) in
            switch result {
                case .success: break
                case .failure(let error):
                    print("Failed submitting: \(error)")
            }
        }

        // Remember the selected answer so it can be displayed as selected
        selectedAnswer = answer.id

        // Fetch the question again to display the selected answer
        fetchQuestion()
    }
}

extension SubmitAnswerAsynchroniseNetwork {
    convenience init() {
        guard let settings = VragenSDK.settings else {
            fatalError("Did not initialise VragenSDK. Initialise by using VragenSDK#set(url:token:)")
        }

        self.init(server: settings.server, token: settings.token)
    }
}
