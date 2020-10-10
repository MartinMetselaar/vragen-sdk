import XCTest
@testable import VragenSDK
import VragenAPIModels
import Foundation

final class QuestionPresenterTests: XCTestCase {

    var sut: QuestionPresenter!

    var mockViewController: DefaultQuestionDisplayLogicMock!

    override func setUp() {
        mockViewController = DefaultQuestionDisplayLogicMock()

        sut = QuestionPresenter(viewController: mockViewController)
    }

    // MARK: - presentQuestion

    func test_presentQuestion_shouldInvokeDisplayQuestion() {
        // When
        let question = createQuestion(question: "question", answers: [
            "Answer 1",
            "Answer 2",
        ])
        sut.presentQuestion(response: Question.Fetch.Response(data: question, selected: nil))

        // Then
        XCTAssertTrue(mockViewController.invokedDisplayQuestion)
        XCTAssertEqual(mockViewController.invokedDisplayQuestionCount, 1)
        XCTAssertEqual(mockViewController.invokedDisplayQuestionParameters?.viewModel.title, "question")
        XCTAssertEqual(mockViewController.invokedDisplayQuestionParameters?.viewModel.answers.count, 2)
    }

    func test_presentQuestion_whenSelectedAnswer_shouldInvokeDisplayQuestionWithSelectedAnswer() {
        // When
        let question = createQuestion(question: "question", answers: [
            "Answer 1",
            "Answer 2",
            "Answer 3",
        ])
        let selectedAnswer = question.answers[safe: 1]?.id
        sut.presentQuestion(response: Question.Fetch.Response(data: question, selected: selectedAnswer))

        // Then
        XCTAssertTrue(mockViewController.invokedDisplayQuestion)
        XCTAssertEqual(mockViewController.invokedDisplayQuestionCount, 1)
        XCTAssertEqual(mockViewController.invokedDisplayQuestionParameters?.viewModel.answers.count, 3)

        XCTAssertEqual(mockViewController.invokedDisplayQuestionParameters?.viewModel.answers[safe: 0]?.selected, false)
        XCTAssertEqual(mockViewController.invokedDisplayQuestionParameters?.viewModel.answers[safe: 1]?.selected, true)
        XCTAssertEqual(mockViewController.invokedDisplayQuestionParameters?.viewModel.answers[safe: 2]?.selected, false)
    }
}
extension QuestionPresenterTests {
    func createQuestion(question: String, answers: [String] = []) -> QuestionWithAnswersResponse {
        return QuestionWithAnswersResponse(id: UUID(), title: question, answers: answers.map { AnswerResponse(id: UUID(), title: $0) })
    }
}
