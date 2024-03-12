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
    
    //переменная с индексом текущего вопроса, начальное значение 0
    // (по этому индексу будем искать вопрос в массиве, где индекс первого элемента 0, а не 1)
    private var currentQuestionIndex = 0
    
    // переменная со счетчиком правильных ответов, начально значение закономерно 0
    private var correctAnswers = 0
    //123
    
    //метод конвертации, который принимает моковый вопрос и возвращает вью модель для экрана вопроса
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        let questionStep = QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(question.count)")
        return questionStep
    }
    
    //приватный метод вывода на экран вопроса, который принимает на вход вью модель вопроса и ничего не возвращает
    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        counterLabel.font = UIFont(name: "YS Display-Medium", size: 20)
//        for family in UIFont.familyNames.sorted() {
//            let names = UIFont.fontNames(forFamilyName: family)
//            print("Family: \(family) Font names \(names)")
//        }
        // берём текущий вопрос из массива вопросов по индексу текущего вопроса
        let currentQuestion = question[currentQuestionIndex]
        show(quiz: convert(model: currentQuestion))
    }
    
    // приватный метод, который меняет цвет рамки
    // принимает на вход булевое значение и ничего не возвращает
    private func showAnswerResult(isCorrect: Bool) {
        if isCorrect {
            correctAnswers += 1
        }
        
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        
        
        // запускаем задачу через 1 секунду c помощью диспетчера задач
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            // код, который мы хотим вызвать через 1 секунду
            self.showNextQuestionOrResults()
        }
    }
    
    //метод, который содержит логику перехода в один из сценариев
    
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == question.count - 1 {
            // константа с кнопкой для системного алерта
            let text = "Ваш результат: \(correctAnswers)/10"
            let viewModel = QuizResultsViewModel(
                title: "Этот раунд окончен!",
                text: text,
                buttonText: "Сыграть ещё раз")
            show(quiz: viewModel)
            
            let alert = UIAlertController(
                title: "Этот раунд окончен!",
                message: "Ваш результат ???",
                preferredStyle: .alert)
            
            let action = UIAlertAction(title: "Сыграть еще раз", style: .default) { _ in
                self.currentQuestionIndex = 0
                
                let firstQuestion = self.question[self.currentQuestionIndex]
                let viewModel = self.convert(model: firstQuestion)
                self.show(quiz: viewModel)
            }
            
            alert.addAction(action)
            
            self.present(alert, animated: true, completion: nil)
            
            
            
        } else {
            currentQuestionIndex += 1
            
            let nextQuestion = question[currentQuestionIndex]
            let viewModel = convert(model: nextQuestion)
            
            show(quiz: viewModel)
        }
    }
    
    // приватный метод для показа результатов раунда квиза
    // принимает вью модель QuizResultsViewModel и ничего не возвращает
    private func show(quiz result: QuizResultsViewModel) {
        let alert = UIAlertController(
            title: result.title,
            message: result.text,
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: result.buttonText, style: .default) { _ in
            self.currentQuestionIndex = 0
            self.correctAnswers = 0
            
            let firstQuestion = self.question[self.currentQuestionIndex]
            let viewModel = self.convert(model: firstQuestion)
            self.show(quiz: viewModel)
        }
        
        alert.addAction(action)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    
    // метод вызывается, когда пользователь нажимает на кнопку "Да"
    @IBAction private func yesButtonClicked(_ sender: Any) {
        let currentQuestion = question[currentQuestionIndex]
        let givenAnswer = true
        
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    // метод вызывается, когда пользователь нажимает на кнопку "Нет"
    @IBAction private func noButtonClicked(_ sender: Any) {
        let currentQuestion = question[currentQuestionIndex]
        let givenAnswer = false
        
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
        
    }
}


