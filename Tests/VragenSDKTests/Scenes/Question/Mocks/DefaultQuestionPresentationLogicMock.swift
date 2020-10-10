@testable import VragenSDK

class DefaultQuestionPresentationLogicMock: QuestionPresentationLogic {

    var invokedPresentQuestion = false
    var invokedPresentQuestionCount = 0
    var invokedPresentQuestionParameters: (response: Question.Fetch.Response, Void)?
    var invokedPresentQuestionParametersList = [(response: Question.Fetch.Response, Void)]()

    func presentQuestion(response: Question.Fetch.Response) {
        invokedPresentQuestion = true
        invokedPresentQuestionCount += 1
        invokedPresentQuestionParameters = (response, ())
        invokedPresentQuestionParametersList.append((response, ()))
    }
}
