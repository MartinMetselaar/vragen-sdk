@testable import VragenSDKNetwork
import Foundation
import VragenAPIModels
import Moya

class DefaultSurveyAsynchroniseNetworkableMock: SurveyAsynchroniseNetworkable {
    var invokedGetWithChildren = false
    var invokedGetWithChildrenCount = 0
    var invokedGetWithChildrenParameters: (identifier: UUID, completion: (Result<SurveyWithQuestionsResponse, MoyaError>) -> Void)?
    var invokedGetWithChildrenParametersList = [(identifier: UUID, completion: (Result<SurveyWithQuestionsResponse, MoyaError>) -> Void)]()

    var stubbedGetWithChildrenCompletionResult: (Result<SurveyWithQuestionsResponse, MoyaError>, Void)?

    func getWithChildren(identifier: UUID, completion: @escaping (Result<SurveyWithQuestionsResponse, MoyaError>) -> Void) {
        invokedGetWithChildren = true
        invokedGetWithChildrenCount += 1
        invokedGetWithChildrenParameters = (identifier, completion)
        invokedGetWithChildrenParametersList.append((identifier, completion))
        if let result = stubbedGetWithChildrenCompletionResult {
            completion(result.0)
        }
    }
    
}
