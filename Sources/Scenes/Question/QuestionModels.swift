import Foundation
import VragenAPIModels

struct Question {
    enum Fetch {
        struct Response {
            let data: QuestionWithAnswersResponse
            let selected: UUID?
        }

        struct ViewModel {
            let id: UUID
            let title: String
            let answers: [Answer]

            struct Answer {
                let id: UUID
                let selected: Bool
                let title: String
            }
        }

        struct Error {
            let title: String
        }
    }
}
