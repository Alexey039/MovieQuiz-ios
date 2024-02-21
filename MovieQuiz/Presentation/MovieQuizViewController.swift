import UIKit

final class MovieQuizViewController: UIViewController {
    
    struct ViewModel {
        let image: UIImage
        let question: String
        let questionNumber: String
    }

    // для состояния  "Вопрос показан"
    struct QuizStepViewModel {
        let image: UIImage
        let question: String
        let questionNumber: String
    }

    // для состояния "Результат квиза"
    struct QuizResultsViewModel {
        let title: String
        let text: String
        let buttonText: String
    }

    struct QuizQuestion {
        // строка с названием фильма.
        // совпадает с название картинки афиши фильма в Assets
        let image: String
        // строка с вопросом о рейтинге фильма
        let text: String
        // булевое значение (true, false), правильный ответ на вопрос
        let correctAnswer: Bool
    }

    private let question: [QuizQuestion] = [
        QuizQuestion(image: "The Godfather",
                     text: "9,2",
                     correctAnswer: true),
        QuizQuestion(image: "The Dark Knight",
                     text: "9",
                     correctAnswer: true),
        QuizQuestion(image: "Kill Bill",
                     text: "8,1",
                     correctAnswer: true),
        QuizQuestion(image: "The Avengers",
                     text: "8", correctAnswer: true),
        QuizQuestion(image: "Deadpool",
                     text: "8",
                     correctAnswer: true),
        QuizQuestion(image: "The Green Knight",
                     text: "6,6",
                     correctAnswer: true),
        QuizQuestion(image: "Old",
                     text: "5,8",
                     correctAnswer: false),
        QuizQuestion(image: "The Ice Age Adventures of Buck Wild",
                     text: "4,3",
                     correctAnswer: false),
        QuizQuestion(image: "Tesla",
                     text: "5,1",
                     correctAnswer: false),
        QuizQuestion(image: "Vivarium",
                     text: "5,8",
                     correctAnswer: false)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    
    @IBAction private func yesButtonClicked(_ sender: Any) {
    }
    
    @IBAction private func noButtonClicked(_ sender: Any) {
    }
}

/*
 Mock-данные
 
 
 Картинка: The Godfather
 Настоящий рейтинг: 9,2
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА


 Картинка: The Dark Knight
 Настоящий рейтинг: 9
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА


 Картинка: Kill Bill
 Настоящий рейтинг: 8,1
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА


 Картинка: The Avengers
 Настоящий рейтинг: 8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА


 Картинка: Deadpool
 Настоящий рейтинг: 8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА


 Картинка: The Green Knight
 Настоящий рейтинг: 6,6
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА


 Картинка: Old
 Настоящий рейтинг: 5,8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ


 Картинка: The Ice Age Adventures of Buck Wild
 Настоящий рейтинг: 4,3
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ


 Картинка: Tesla
 Настоящий рейтинг: 5,1
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ


 Картинка: Vivarium
 Настоящий рейтинг: 5,8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 */
