import UIKit

//protocol QuestionFactoryProtocol {
//    func requestNextQuestion()
//}

protocol QuestionFactoryProtocol {
    var delegate: QuestionFactoryDelegate? { get set }
    func requestNextQuestion()
    func loadData()
}
