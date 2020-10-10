@testable import VragenSDKNetwork
import Foundation
import VragenAPIModels
import Moya

class DefaultSubmitAnswerAsynchroniseNetworkableMock: SubmitAnswerAsynchroniseNetworkable {

    var invokedSubmit = false
    var invokedSubmitCount = 0
    var invokedSubmitParameters: (userId: String, surveyId: UUID, questionId: UUID, answerId: UUID, completion: (_ result: Result<SubmitAnswerResponse, MoyaError>) -> Void)?
    var invokedSubmitParametersList = [(userId: String, surveyId: UUID, questionId: UUID, answerId: UUID, completion: (result: Result<SubmitAnswerResponse, MoyaError>) -> Void)]()
    func submit(userId: String, surveyId: UUID, questionId: UUID, answerId: UUID, completion: @escaping (_ result: Result<SubmitAnswerResponse, MoyaError>) -> Void) {
        invokedSubmit = true
        invokedSubmitCount += 1
        invokedSubmitParameters = (userId, surveyId, questionId, answerId, completion)
        invokedSubmitParametersList.append((userId, surveyId, questionId, answerId, completion))
    }
}
