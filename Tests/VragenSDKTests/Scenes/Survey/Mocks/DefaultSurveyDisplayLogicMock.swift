@testable import VragenSDK
import UIKit

class DefaultSurveyDisplayLogicMock: SurveyDisplayLogic {

    var invokedDisplaySurvey = false
    var invokedDisplaySurveyCount = 0
    var invokedDisplaySurveyParameters: (viewModel: Survey.Fetch.ViewModel, Void)?
    var invokedDisplaySurveyParametersList = [(viewModel: Survey.Fetch.ViewModel, Void)]()

    func displaySurvey(viewModel: Survey.Fetch.ViewModel) {
        invokedDisplaySurvey = true
        invokedDisplaySurveyCount += 1
        invokedDisplaySurveyParameters = (viewModel, ())
        invokedDisplaySurveyParametersList.append((viewModel, ()))
    }

    var invokedDisplayError = false
    var invokedDisplayErrorCount = 0
    var invokedDisplayErrorParameters: (error: Survey.Fetch.Error, Void)?
    var invokedDisplayErrorParametersList = [(error: Survey.Fetch.Error, Void)]()

    func displayError(error: Survey.Fetch.Error) {
        invokedDisplayError = true
        invokedDisplayErrorCount += 1
        invokedDisplayErrorParameters = (error, ())
        invokedDisplayErrorParametersList.append((error, ()))
    }

    var invokedDisplayLoading = false
    var invokedDisplayLoadingCount = 0

    func displayLoading() {
        invokedDisplayLoading = true
        invokedDisplayLoadingCount += 1
    }

    var invokedHideLoading = false
    var invokedHideLoadingCount = 0

    func hideLoading() {
        invokedHideLoading = true
        invokedHideLoadingCount += 1
    }

    var invokedDisplayNextButtonEnabled = false
    var invokedDisplayNextButtonEnabledCount = 0

    func displayNextButtonEnabled() {
        invokedDisplayNextButtonEnabled = true
        invokedDisplayNextButtonEnabledCount += 1
    }

    var invokedDisplayNextButtonDisabled = false
    var invokedDisplayNextButtonDisabledCount = 0

    func displayNextButtonDisabled() {
        invokedDisplayNextButtonDisabled = true
        invokedDisplayNextButtonDisabledCount += 1
    }

    var invokedDisplaySubmitButton = false
    var invokedDisplaySubmitButtonCount = 0

    func displaySubmitButton() {
        invokedDisplaySubmitButton = true
        invokedDisplaySubmitButtonCount += 1
    }

    var invokedDisplayDismiss = false
    var invokedDisplayDismissCount = 0

    func displayDismiss() {
        invokedDisplayDismiss = true
        invokedDisplayDismissCount += 1
    }

    var invokedDisplayQuestion = false
    var invokedDisplayQuestionCount = 0
    var invokedDisplayQuestionParameters: (index: Int, direction: UIPageViewController.NavigationDirection)?
    var invokedDisplayQuestionParametersList = [(index: Int, direction: UIPageViewController.NavigationDirection)]()

    func displayQuestion(at index: Int, direction: UIPageViewController.NavigationDirection) {
        invokedDisplayQuestion = true
        invokedDisplayQuestionCount += 1
        invokedDisplayQuestionParameters = (index, direction)
        invokedDisplayQuestionParametersList.append((index, direction))
    }
}
