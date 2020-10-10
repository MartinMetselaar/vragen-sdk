import XCTest
@testable import VragenSDK
import VragenAPIModels
import Foundation
import Moya

final class SurveyPresenterTests: XCTestCase {

    var sut: SurveyPresenter!

    var mockViewController: DefaultSurveyDisplayLogicMock!

    override func setUp() {
        mockViewController = DefaultSurveyDisplayLogicMock()

        sut = SurveyPresenter(viewController: mockViewController)
    }

    // MARK: - presentSurvey

    func test_presentSurvey_shouldInvokeDisplaySurvey() {
        // When
        let survey = createSurvey(title: "survey", questions: [
            "Are?",
            "You?",
        ])
        let userId = "user-id"
        let surveyId = UUID()
        sut.presentSurvey(response: Survey.Fetch.Response(data: survey, userId: userId, surveyId: surveyId))

        // Then
        XCTAssertTrue(mockViewController.invokedDisplaySurvey)
        XCTAssertEqual(mockViewController.invokedDisplaySurveyCount, 1)
        XCTAssertEqual(mockViewController.invokedDisplaySurveyParameters?.viewModel.title, "survey")
        XCTAssertEqual(mockViewController.invokedDisplaySurveyParameters?.viewModel.questions.count, 2)
    }

    // MARK: - presentError

    func test_presentError() {
        // Given
        let nsError = NSError(domain: "domain", code: -1, userInfo: [NSLocalizedDescriptionKey: "So."])

        let error: MoyaError = .parameterEncoding(nsError)

        // When
        sut.presentError(error: error)

        // Then
        let expectedError = Survey.Fetch.Error(titleKey: "vragensdk_error_title", message: "Failed to encode parameters for URLRequest. So.", confirmKey: "vragensdk_error_confirm_title")
        XCTAssertTrue(mockViewController.invokedDisplayError)
        XCTAssertEqual(mockViewController.invokedDisplayErrorCount, 1)
        XCTAssertEqual(mockViewController.invokedDisplayErrorParameters?.error.titleKey, expectedError.titleKey)
        XCTAssertEqual(mockViewController.invokedDisplayErrorParameters?.error.message, expectedError.message)
        XCTAssertEqual(mockViewController.invokedDisplayErrorParameters?.error.confirmKey, expectedError.confirmKey)
    }

    // MARK: - presentLoading
    func test_presentLoading_shouldInvokeDisplayLoading() {
        // When
        sut.presentLoading()

        // Then
        XCTAssertTrue(mockViewController.invokedDisplayLoading)
    }

    // MARK: - hideLoading
    func test_hideLoading_shouldInvokeHideLoading() {
        // When
        sut.hideLoading()

        // Then
        XCTAssertTrue(mockViewController.invokedHideLoading)
    }

    // MARK: - presentNextButtonEnabled
    func test_presentNextButtonEnabled_shouldInvokeDisplayNextButtonEnabled() {
        // When
        sut.presentNextButtonEnabled()

        // Then
        XCTAssertTrue(mockViewController.invokedDisplayNextButtonEnabled)
    }

    // MARK: - presentNextButtonDisabled
    func test_presentNextButtonDisabled_shouldInvokeDisplayNextButtonDisabled() {
        // When
        sut.presentNextButtonDisabled()

        // Then
        XCTAssertTrue(mockViewController.invokedDisplayNextButtonDisabled)
    }

    // MARK: - presentSubmitButton
    func test_presentSubmitButton_shouldInvokeDisplaySubmitButton() {
        // When
        sut.presentSubmitButton()

        // Then
        XCTAssertTrue(mockViewController.invokedDisplaySubmitButton)
    }

    // MARK: - presentDismiss
    func test_presentDismiss_shouldInvokeDisplayDismiss() {
        // When
        sut.presentDismiss()

        // Then
        XCTAssertTrue(mockViewController.invokedDisplayDismiss)
    }

    // MARK: - presentQuestion
    func test_presentQuestion_whenNextIndex_shouldDisplayQuestionWithDirectionForward() {
        // When
        sut.presentQuestion(at: 1, currentIndex: 0)

        // Then
        XCTAssertTrue(mockViewController.invokedDisplayQuestion)
        XCTAssertEqual(mockViewController.invokedDisplayQuestionParameters?.index, 1)
        XCTAssertEqual(mockViewController.invokedDisplayQuestionParameters?.direction, .forward)
    }

    func test_presentQuestion_whenPreviousIndex_shouldDisplayQuestionWithDirectionReverse() {
        // When
        sut.presentQuestion(at: 0, currentIndex: 2)

        // Then
        XCTAssertTrue(mockViewController.invokedDisplayQuestion)
        XCTAssertEqual(mockViewController.invokedDisplayQuestionParameters?.index, 0)
        XCTAssertEqual(mockViewController.invokedDisplayQuestionParameters?.direction, .reverse)
    }

}

extension SurveyPresenterTests {
    func createSurvey(title: String, questions: [String]) -> SurveyWithQuestionsResponse {
        return SurveyWithQuestionsResponse(id: UUID(), title: title, questions: questions.map { QuestionWithAnswersResponse(id: UUID(), title: $0, answers: []) })
    }
}
