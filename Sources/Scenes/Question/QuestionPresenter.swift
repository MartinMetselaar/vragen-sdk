import Moya
import VragenAPIModels

protocol QuestionPresentationLogic {
    func presentQuestion(response: Question.Fetch.Response)
}

class QuestionPresenter: QuestionPresentationLogic {
    private weak var viewController: QuestionDisplayLogic?

    init(viewController: QuestionDisplayLogic) {
        self.viewController = viewController
    }

    /// Map the `QuestionWithAnswersResponse` to a `Question.Fetch.ViewModel` and check what the selected answer is
    func presentQuestion(response: Question.Fetch.Response) {
        viewController?.displayQuestion(viewModel: .init(id: response.data.id, title: response.data.title, answers: response.data.answers.map({ answer -> Question.Fetch.ViewModel.Answer in
            .init(id: answer.id, selected: response.selected == answer.id, title: answer.title)
        })))
    }
}
