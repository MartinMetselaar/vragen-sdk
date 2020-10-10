@testable import VragenSDK

class DefaultQuestionDisplayLogicMock: QuestionDisplayLogic {

    var invokedDisplayQuestion = false
    var invokedDisplayQuestionCount = 0
    var invokedDisplayQuestionParameters: (viewModel: Question.Fetch.ViewModel, Void)?
    var invokedDisplayQuestionParametersList = [(viewModel: Question.Fetch.ViewModel, Void)]()

    func displayQuestion(viewModel: Question.Fetch.ViewModel) {
        invokedDisplayQuestion = true
        invokedDisplayQuestionCount += 1
        invokedDisplayQuestionParameters = (viewModel, ())
        invokedDisplayQuestionParametersList.append((viewModel, ()))
    }
}
