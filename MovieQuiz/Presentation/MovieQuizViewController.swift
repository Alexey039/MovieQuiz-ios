import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    
    
    private  struct ViewModel {
        let image: UIImage
        let question: String
        let questionNumber: String
    }
    
    //переменная с индексом текущего вопроса, начальное значение 0
    // (по этому индексу будем искать вопрос в массиве, где индекс первого элемента 0, а не 1)
    private var currentQuestionIndex = 0
    private var correctAnswers = 0
    private let questionsAmount: Int = 10
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    private var alertPresenter: AlertPresenter?
    private var statisticService: StatisticService?
    
    //метод конвертации, который принимает моковый вопрос и возвращает вью модель для экрана вопроса
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        let questionStep = QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
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
        statisticService = StatisticServiceImplementation()
        let questionFactory = QuestionFactory()
        questionFactory.delegate = self
        self.questionFactory = questionFactory
        
        questionFactory.requestNextQuestion()
        alertPresenter = AlertPresenter(viewController: self)
        setupView()
    }
    
    // MARK: - QuestionFactoryDelegate
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        
        currentQuestion = question
        let viewModel = convert(model: question)
        
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: viewModel)
        }
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
        if currentQuestionIndex == questionsAmount - 1 {
            showFinalResults()
            
            noButton.isEnabled = true
            yesButton.isEnabled = true
        }
        else {
            currentQuestionIndex += 1
            
            self.questionFactory?.requestNextQuestion()
            
            imageView.layer.masksToBounds = true
            imageView.layer.borderWidth = 0
            imageView.layer.cornerRadius = 20
            
            noButton.isEnabled = true
            yesButton.isEnabled = true
        }
    }
    
    private func showFinalResults() {
        statisticService?.store(correct: correctAnswers, total: questionsAmount)
        let alertModel = AlertModel(
            title: "Этот раунд окончен!",
            message: getResultMessage(),
            buttonText: "Сыграть ещё раз",
            completion: { [weak self] in
                self?.currentQuestionIndex = 0
                self?.correctAnswers = 0
                self?.questionFactory?.requestNextQuestion()
            }
        )
        alertPresenter?.show(alertModel: alertModel)
    }

    private func show(quiz result: QuizResultsViewModel) {
        let alert = UIAlertController(
            title: result.title,
            message: result.text,
            preferredStyle: .alert)

        let action = UIAlertAction(title: result.buttonText, style: .default) { _ in
            self.currentQuestionIndex = 0
            self.correctAnswers = 0
            self.questionFactory?.requestNextQuestion()

            self.imageView.layer.masksToBounds = true
            self.imageView.layer.borderWidth = 0
            self.imageView.layer.cornerRadius = 20

            self.noButton.isEnabled = true
            self.yesButton.isEnabled = true
        }

        alert.addAction(action)

        self.present(alert, animated: true, completion: nil)
    }
    
    private func setupView() {
        questionTitleLabel.font = UIFont(name: "YSDisplay-Medium", size: 20)
        counterLabel.font = UIFont(name: "YSDisplay-Medium", size: 20)
        textLabel.font = UIFont(name: "YSDisplay-Bold", size: 23)
        noButton.titleLabel?.font = UIFont(name: "YSDisplay-Medium", size: 20)
        yesButton.titleLabel?.font = UIFont(name: "YSDisplay-Medium", size: 20)
    }
    
    private func getResultMessage() -> String {
        guard let bestGame = statisticService?.bestGame else {
            assertionFailure("error")
            return ""
        }
        let totalPlaysQuizCount = "Количество сыгранных квизов: \(statisticService!.gamesCount)"
        let currentQuizResult = "Ваш результат: \(correctAnswers)\\\(questionsAmount)"
        let bestQuizInfo = "Рекорд: \(bestGame.correct)\\\(bestGame.total)" + "(\(bestGame.date.dateTimeString))"
        let averageAccuracyAllQuiz = "Средняя точность: \(String(format: "%.2f", statisticService!.totalAccuracy))%"
        let resultMessage = [currentQuizResult, totalPlaysQuizCount, bestQuizInfo, averageAccuracyAllQuiz].joined(separator: "\n")
        return resultMessage
    }

    
    private func changeStateButton(isEnabled: Bool){
        noButton.isEnabled = false
        yesButton.isEnabled = false
    }
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var questionTitleLabel: UILabel!
    
    
    @IBOutlet private var noButton: UIButton!
    @IBOutlet private var yesButton: UIButton!
    
    // метод вызывается, когда пользователь нажимает на кнопку "Да"
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = true
        
        changeStateButton(isEnabled: false)
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    // метод вызывается, когда пользователь нажимает на кнопку "Нет"
    @IBAction private func noButtonClicked(_ sender: UIButton ) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = false
        
        
        changeStateButton(isEnabled: false)
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
        
    }
}
