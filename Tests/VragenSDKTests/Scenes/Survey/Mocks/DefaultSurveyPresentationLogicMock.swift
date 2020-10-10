@testable import VragenSDK
import Moya

class DefaultSurveyPresentationLogicMock: SurveyPresentationLogic {

    var invokedPresentSurvey = false
    var invokedPresentSurveyCount = 0
    var invokedPresentSurveyParameters: (response: Survey.Fetch.Response, Void)?
    var invokedPresentSurveyParametersList = [(response: Survey.Fetch.Response, Void)]()

    func presentSurvey(response: Survey.Fetch.Response) {
        invokedPresentSurvey = true
        invokedPresentSurveyCount += 1
        invokedPresentSurveyParameters = (response, ())
        invokedPresentSurveyParametersList.append((response, ()))
    }

    var invokedPresentError = false
    var invokedPresentErrorCount = 0
    var invokedPresentErrorParameters: (error: MoyaError, Void)?
    var invokedPresentErrorParametersList = [(error: MoyaError, Void)]()

    func presentError(error: MoyaError) {
        invokedPresentError = true
        invokedPresentErrorCount += 1
        invokedPresentErrorParameters = (error, ())
        invokedPresentErrorParametersList.append((error, ()))
    }

    var invokedPresentLoading = false
    var invokedPresentLoadingCount = 0

    func presentLoading() {
        invokedPresentLoading = true
        invokedPresentLoadingCount += 1
    }

    var invokedHideLoading = false
    var invokedHideLoadingCount = 0

    func hideLoading() {
        invokedHideLoading = true
        invokedHideLoadingCount += 1
    }

    var invokedPresentNextButtonEnabled = false
    var invokedPresentNextButtonEnabledCount = 0

    func presentNextButtonEnabled() {
        invokedPresentNextButtonEnabled = true
        invokedPresentNextButtonEnabledCount += 1
    }

    var invokedPresentNextButtonDisabled = false
    var invokedPresentNextButtonDisabledCount = 0

    func presentNextButtonDisabled() {
        invokedPresentNextButtonDisabled = true
        invokedPresentNextButtonDisabledCount += 1
    }

    var invokedPresentSubmitButton = false
    var invokedPresentSubmitButtonCount = 0

    func presentSubmitButton() {
        invokedPresentSubmitButton = true
        invokedPresentSubmitButtonCount += 1
    }

    var invokedPresentDismiss = false
    var invokedPresentDismissCount = 0

    func presentDismiss() {
        invokedPresentDismiss = true
        invokedPresentDismissCount += 1
    }

    var invokedPresentQuestion = false
    var invokedPresentQuestionCount = 0
    var invokedPresentQuestionParameters: (index: Int, currentIndex: Int)?
    var invokedPresentQuestionParametersList = [(index: Int, currentIndex: Int)]()

    func presentQuestion(at index: Int, currentIndex: Int) {
        invokedPresentQuestion = true
        invokedPresentQuestionCount += 1
        invokedPresentQuestionParameters = (index, currentIndex)
        invokedPresentQuestionParametersList.append((index, currentIndex))
    }
}
