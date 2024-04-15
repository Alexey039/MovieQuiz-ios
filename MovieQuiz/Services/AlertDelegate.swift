import UIKit

protocol AlertDelegate: AnyObject {
    func show(quiz result: QuizResultsViewModel)
}
