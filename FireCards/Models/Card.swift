import FirebaseFirestoreSwift
import Foundation

struct Card: Identifiable, Codable {
    @DocumentID var id: String?
    var question: String
    var answer: String
    var successful: Bool = true
    var userID: String?
}

#if DEBUG
let testData = (1...10).map { i in
    Card(question: "Question #\(i)", answer: "Answer #\(i)")
}
#endif
