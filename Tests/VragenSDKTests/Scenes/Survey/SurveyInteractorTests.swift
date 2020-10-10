import XCTest
@testable import VragenSDK
import VragenAPIModels
import Foundation
import Moya

final class SurveyInteractorTests: XCTestCase {

    var sut: SurveyInteractor!

    var mockPresenter: DefaultSurveyPresentationLogicMock!
    var mockClient: DefaultSurveyAsynchroniseNetworkableMock!

    override func setUp() {
        let survey = SurveyWithQuestionsResponse(id: UUID(), title: "title", questions: [])
        setupSUT(survey: survey, answeredQuestions: Set())
    }

    func setupSUT(survey: SurveyWithQuestionsResponse, answeredQuestions: Set<UUID>) {
        mockPresenter = DefaultSurveyPresentationLogicMock()
        mockClient = DefaultSurveyAsynchroniseNetworkableMock()

        sut = SurveyInteractor(presenter: mockPresenter, client: mockClient, answeredQuestions: answeredQuestions, survey: survey)
    }

    // MARK: - fetchSurvey

    func test_fetchSurvey_shouldInvokePresentLoading() {
        // Give
        let identifier = UUID()
        let userId = "user-id"

        // Given
        sut.fetchSurvey(identifier: identifier, userId: userId)

        // Then
        XCTAssertTrue(mockPresenter.invokedPresentLoading)
        XCTAssertEqual(mockPresenter.invokedPresentLoadingCount, 1)
    }

    func test_fetchSurvey_shouldInvokePresentNextButtonDisabled() {
        // Give
        let identifier = UUID()
        let userId = "user-id"

        // Given
        sut.fetchSurvey(identifier: identifier, userId: userId)

        // Then
        XCTAssertTrue(mockPresenter.invokedPresentNextButtonDisabled)
        XCTAssertEqual(mockPresenter.invokedPresentNextButtonDisabledCount, 1)
    }

    func test_fetchSurvey_shouldInvokeClientGetWithChildren() {
        // Give
        let identifier = UUID()
        let userId = "user-id"

        // Given
        sut.fetchSurvey(identifier: identifier, userId: userId)

        // Then
        XCTAssertTrue(mockClient.invokedGetWithChildren)
        XCTAssertEqual(mockClient.invokedGetWithChildrenCount, 1)
    }

    func test_fetchSurvey_whenSuccess_shouldInvokePresentSurvey() {
        // Give
        let userId = "user-id"
        let survey = createSurvey(title: "title", questions: [])
        mockClient.stubbedGetWithChildrenCompletionResult = (.success(survey), ())

        // Given
        sut.fetchSurvey(identifier: survey.id, userId: userId)

        // Then
        XCTAssertTrue(mockPresenter.invokedPresentSurvey)
        XCTAssertEqual(mockPresenter.invokedPresentSurveyCount, 1)
        XCTAssertEqual(mockPresenter.invokedPresentSurveyParameters?.response.data, survey)
        XCTAssertEqual(mockPresenter.invokedPresentSurveyParameters?.response.userId, userId)
        XCTAssertEqual(mockPresenter.invokedPresentSurveyParameters?.response.surveyId, survey.id)
        XCTAssertTrue(mockPresenter.invokedHideLoading)
    }

    func test_fetchSurvey_whenNoUserIdProvided_shouldCreateUserId() {
        // Give
        let survey = createSurvey(title: "title", questions: [])
        mockClient.stubbedGetWithChildrenCompletionResult = (.success(survey), ())

        // Given
        sut.fetchSurvey(identifier: survey.id, userId: nil)

        // Then
        XCTAssertNotNil(mockPresenter.invokedPresentSurveyParameters?.response.userId)
    }

    func test_fetchSurvey_whenFailed_shouldInvokePresentError() {
        // Give
        let survey = createSurvey(title: "title", questions: [])
        let error: MoyaError = .parameterEncoding(NSError())
        mockClient.stubbedGetWithChildrenCompletionResult = (.failure(error), ())

        // Given
        sut.fetchSurvey(identifier: survey.id, userId: "")

        // Then
        XCTAssertTrue(mockPresenter.invokedPresentError)
        XCTAssertEqual(mockPresenter.invokedPresentErrorCount, 1)
        XCTAssertTrue(mockPresenter.invokedHideLoading)
    }

    // MARK: - didScrollToPage

    func test_didScrollToPage_whenAllQuestionsAnswered_shouldInvokePresentSubmitButton() {
        // Given
        let question1 = createQuestion(question: "question 1")
        let question2 = createQuestion(question: "question 2")
        let question3 = createQuestion(question: "question 3")
        let questions = [question1, question2, question3]
        let survey = SurveyWithQuestionsResponse(id: UUID(), title: "title", questions: questions)
        let answeredQuestions = Set(questions.map { $0.id })
        setupSUT(survey: survey, answeredQuestions: answeredQuestions)

        // When
        sut.didScrollToPage(at: 0)

        // Then
        XCTAssertTrue(mockPresenter.invokedPresentSubmitButton)
        XCTAssertEqual(mockPresenter.invokedPresentSubmitButtonCount, 1)

        XCTAssertFalse(mockPresenter.invokedPresentNextButtonEnabled)
        XCTAssertFalse(mockPresenter.invokedPresentNextButtonDisabled)
    }

    func test_didScrollToPage_whenNotAllQuestionsAnswered_shouldInvokePresentNextButtonEnabled() {
        // Given
        let question1 = createQuestion(question: "question 1")
        let question2 = createQuestion(question: "question 2")
        let questions = [question1, question2]
        let survey = SurveyWithQuestionsResponse(id: UUID(), title: "title", questions: questions)
        let answeredQuestions = Set([question1.id])
        setupSUT(survey: survey, answeredQuestions: answeredQuestions)

        // When
        sut.didScrollToPage(at: 0)

        // Then
        XCTAssertTrue(mockPresenter.invokedPresentNextButtonEnabled)
        XCTAssertEqual(mockPresenter.invokedPresentNextButtonEnabledCount, 1)

        XCTAssertFalse(mockPresenter.invokedPresentSubmitButton)
        XCTAssertFalse(mockPresenter.invokedPresentNextButtonDisabled)

    }

    func test_didScrollToPage_whenNoQuestionAnswered_shouldInvokePresentNextButtonDisabled() {
        // Given
        let question1 = createQuestion(question: "question 1")
        let question2 = createQuestion(question: "question 2")
        let questions = [question1, question2]
        let survey = SurveyWithQuestionsResponse(id: UUID(), title: "title", questions: questions)
        let answeredQuestions = Set<UUID>()
        setupSUT(survey: survey, answeredQuestions: answeredQuestions)

        // When
        sut.didScrollToPage(at: 0)

        // Then
        XCTAssertTrue(mockPresenter.invokedPresentNextButtonDisabled)
        XCTAssertEqual(mockPresenter.invokedPresentNextButtonDisabledCount, 1)

        XCTAssertFalse(mockPresenter.invokedPresentSubmitButton)
        XCTAssertFalse(mockPresenter.invokedPresentNextButtonEnabled)

    }

    // MARK: - didSelectAnswer

    func test_didSelectAnswer_whenAllQuestionsAnswered_shouldInvokePresentSubmitButton() {
        // Given
        let question1 = createQuestion(question: "question 1")
        let question2 = createQuestion(question: "question 2")
        let questions = [question1, question2]
        let survey = SurveyWithQuestionsResponse(id: UUID(), title: "title", questions: questions)
        let answeredQuestions = Set([question1.id])
        setupSUT(survey: survey, answeredQuestions: answeredQuestions)

        // When
        sut.didSelectAnswer(question: question2.id)

        // Then
        XCTAssertTrue(mockPresenter.invokedPresentSubmitButton)
        XCTAssertEqual(mockPresenter.invokedPresentSubmitButtonCount, 1)

        XCTAssertFalse(mockPresenter.invokedPresentNextButtonEnabled)
    }

    func test_didSelectAnswer_whenNotAllQuestionsAnswered_shouldInvokePresentNextButtonEnabled() {
        // Given
        let question1 = createQuestion(question: "question 1")
        let question2 = createQuestion(question: "question 2")
        let questions = [question1, question2]
        let survey = SurveyWithQuestionsResponse(id: UUID(), title: "title", questions: questions)
        let answeredQuestions = Set<UUID>()
        setupSUT(survey: survey, answeredQuestions: answeredQuestions)

        // When
        sut.didSelectAnswer(question: question2.id)

        // Then
        XCTAssertTrue(mockPresenter.invokedPresentNextButtonEnabled)
        XCTAssertEqual(mockPresenter.invokedPresentNextButtonEnabledCount, 1)

        XCTAssertFalse(mockPresenter.invokedPresentSubmitButton)
    }

    func test_didSelectAnswer_whenQuestionAnsweredTwice_shouldNotPresentSubmitButton() {
        // Given
        let question1 = createQuestion(question: "question 1")
        let question2 = createQuestion(question: "question 2")
        let questions = [question1, question2]
        let survey = SurveyWithQuestionsResponse(id: UUID(), title: "title", questions: questions)
        let answeredQuestions = Set([question1.id])
        setupSUT(survey: survey, answeredQuestions: answeredQuestions)

        // When
        sut.didSelectAnswer(question: question1.id)

        // Then
        XCTAssertTrue(mockPresenter.invokedPresentNextButtonEnabled)
        XCTAssertEqual(mockPresenter.invokedPresentNextButtonEnabledCount, 1)

        XCTAssertFalse(mockPresenter.invokedPresentSubmitButton)
    }

    // MARK: - didSelectBottomButton

    func test_didSelectBottomButton_whenAllQuestionsAnswered_shouldInvokePresentDismiss() {
        // Given
        let question1 = createQuestion(question: "question 1")
        let question2 = createQuestion(question: "question 2")
        let questions = [question1, question2]
        let survey = SurveyWithQuestionsResponse(id: UUID(), title: "title", questions: questions)
        let answeredQuestions = Set([question1.id, question2.id])
        setupSUT(survey: survey, answeredQuestions: answeredQuestions)

        // When
        sut.didSelectBottomButton(at: 0)

        // Then
        XCTAssertTrue(mockPresenter.invokedPresentDismiss)
        XCTAssertEqual(mockPresenter.invokedPresentDismissCount, 1)

        XCTAssertFalse(mockPresenter.invokedPresentQuestion)
    }

    func test_didSelectBottomButton_whenQuestionAnswered_shouldInvokePresentQuestionToGoToTheNextQuestion() {
        // Given
        let question1 = createQuestion(question: "question 1")
        let question2 = createQuestion(question: "question 2")
        let questions = [question1, question2]
        let survey = SurveyWithQuestionsResponse(id: UUID(), title: "title", questions: questions)
        let answeredQuestions = Set([question1.id])
        setupSUT(survey: survey, answeredQuestions: answeredQuestions)

        // When
        sut.didSelectBottomButton(at: 0)

        // Then
        XCTAssertTrue(mockPresenter.invokedPresentQuestion)
        XCTAssertEqual(mockPresenter.invokedPresentQuestionCount, 1)
        XCTAssertEqual(mockPresenter.invokedPresentQuestionParameters?.currentIndex, 0)
        XCTAssertEqual(mockPresenter.invokedPresentQuestionParameters?.index, 1)

        XCTAssertFalse(mockPresenter.invokedPresentDismiss)
    }

    func test_didSelectBottomButton_when() {
        // Given
        let question1 = createQuestion(question: "question 1")
        let question2 = createQuestion(question: "question 2")
        let questions = [question1, question2]
        let survey = SurveyWithQuestionsResponse(id: UUID(), title: "title", questions: questions)
        let answeredQuestions = Set([question2.id])
        setupSUT(survey: survey, answeredQuestions: answeredQuestions)

        // When
        sut.didSelectBottomButton(at: 1)

        // Then
        XCTAssertTrue(mockPresenter.invokedPresentQuestion)
        XCTAssertEqual(mockPresenter.invokedPresentQuestionCount, 1)
        XCTAssertEqual(mockPresenter.invokedPresentQuestionParameters?.currentIndex, 1)
        XCTAssertEqual(mockPresenter.invokedPresentQuestionParameters?.index, 0)

        XCTAssertFalse(mockPresenter.invokedPresentDismiss)
    }

}

extension SurveyInteractorTests {
    func createSurvey(title: String, questions: [String]) -> SurveyWithQuestionsResponse {
        return SurveyWithQuestionsResponse(id: UUID(), title: title, questions: questions.map { QuestionWithAnswersResponse(id: UUID(), title: $0, answers: []) })
    }

    func createQuestion(question: String, answers: [String] = []) -> QuestionWithAnswersResponse {
        return QuestionWithAnswersResponse(id: UUID(), title: question, answers: answers.map { AnswerResponse(id: UUID(), title: $0) })
    }
}
