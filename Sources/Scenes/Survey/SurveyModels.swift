import Foundation
import VragenAPIModels

struct Survey {
    enum Fetch {
        struct Response {
            let data: SurveyWithQuestionsResponse
            let userId: String
            let surveyId: UUID
        }

        struct ViewModel {
            let title: String
            let questions: [Question]

            struct Question {
                let userId: String
                let surveyId: UUID
                let question: QuestionWithAnswersResponse
            }
        }

        struct Error {
            let titleKey: String
            let message: String
            let confirmKey: String
        }
    }
}
