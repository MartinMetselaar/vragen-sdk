import XCTest
@testable import VragenSDK
import VragenAPIModels
import Foundation

final class QuestionInteractorTests: XCTestCase {

    var sut: QuestionInteractor!

    var mockPresenter: DefaultQuestionPresentationLogicMock!
    var mockClient: DefaultSubmitAnswerAsynchroniseNetworkableMock!

    override func setUp() {
        let response = QuestionWithAnswersResponse(id: UUID(), title: "title", answers: [])
        setupSUT(question: response)
    }

    func setupSUT(question: QuestionWithAnswersResponse) {
        mockPresenter = DefaultQuestionPresentationLogicMock()
        mockClient = DefaultSubmitAnswerAsynchroniseNetworkableMock()

        sut = QuestionInteractor(presenter: mockPresenter, userId: "user-id", surveyId: UUID(), question: question, client: mockClient)
    }

    // MARK: - fetchQuestion

    func test_fetchQuestion_shouldPresentQuestion() {
        // When
        sut.fetchQuestion()

        // Then
        XCTAssertTrue(mockPresenter.invokedPresentQuestion)
        XCTAssertEqual(mockPresenter.invokedPresentQuestionCount, 1)
    }

    func test_fetchQuestion_shouldNotHaveSelectedAnswer() {
        // Given
        let question = createQuestion(question: "question", answers: [
            "Answer 1",
            "Answer 2",
            "Answer 3",
        ])
        setupSUT(question: question)

        // When
        sut.fetchQuestion()

        // Then
        XCTAssertNil(mockPresenter.invokedPresentQuestionParameters?.response.selected)
    }

    // MARK: - didSelectAnswer

    func test_didSelectAnswer_shouldPresentSelectedQuestion() {
        // Given
        let question = createQuestion(question: "question", answers: ["Answer 1"])
        setupSUT(question: question)


        // When
        sut.didSelectAnswer(index: 0)

        // Then
        XCTAssertTrue(mockPresenter.invokedPresentQuestion)
        XCTAssertEqual(mockPresenter.invokedPresentQuestionCount, 1)
    }

    func test_didSelectAnswer_shouldPresentSubmitAnswer() {
        // Given
        let question = createQuestion(question: "question", answers: ["Answer 1"])
        setupSUT(question: question)


        // When
        sut.didSelectAnswer(index: 0)

        // Then
        XCTAssertTrue(mockClient.invokedSubmit)
        XCTAssertEqual(mockClient.invokedSubmitCount, 1)
        XCTAssertEqual(mockClient.invokedSubmitParameters?.questionId, question.id)
    }

    func test_didSelectAnswer_shouldInvokePresentQuestionWithSelectedAnswer() {
        // Given
        let question = createQuestion(question: "question", answers: [
            "Answer 1",
            "Answer 2",
            "Answer 3",
        ])
        setupSUT(question: question)


        // When
        let selectedIndex = 1
        sut.didSelectAnswer(index: selectedIndex)

        // Then
        let expectedAnswer = question.answers[safe: selectedIndex]
        XCTAssertEqual(mockPresenter.invokedPresentQuestionParameters?.response.selected, expectedAnswer?.id)
    }
}
extension QuestionInteractorTests {
    func createQuestion(question: String, answers: [String] = []) -> QuestionWithAnswersResponse {
        return QuestionWithAnswersResponse(id: UUID(), title: question, answers: answers.map { AnswerResponse(id: UUID(), title: $0) })
    }
}
