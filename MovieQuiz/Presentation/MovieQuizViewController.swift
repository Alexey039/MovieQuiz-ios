import UIKit

final class MovieQuizViewController: UIViewController{
    
//    private let presenter = MovieQuizPresenter()
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var questionTitleLabel: UILabel!
    
    
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private var noButton: UIButton!
    @IBOutlet private var yesButton: UIButton!
    
    private  struct ViewModel {
        let image: UIImage
        let question: String
        let questionNumber: String
    }
        
    private var presenter: MovieQuizPresenter!
    private var currentQuestion: QuizQuestion?
    private var alertPresenter: AlertPresenter?
    private var statisticService: StatisticService?
    
    //приватный метод вывода на экран вопроса, который принимает на вход вью модель вопроса и ничего не возвращает
    func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        statisticService = StatisticServiceImplementation()
        presenter = MovieQuizPresenter(viewController: self)
//        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        
        presenter.viewController = self
        showLoadingIndicator()
//        questionFactory?.loadData()
//        questionFactory?.requestNextQuestion()
        alertPresenter = AlertPresenter(viewController: self)
        setupView()
    }

    
//    func didReceiveNextQuestion(question: QuizQuestion?) {
//        presenter.didRecieveNextQuestion(question: question)
//    }
//    
    // приватный метод, который меняет цвет рамки
//    // принимает на вход булевое значение и ничего не возвращает
//    func showAnswerResult(isCorrect: Bool) {
//        presenter.didAnswer(isCorrectAnswer: isCorrect)
//
////        self.presenter.questionFactory = self.questionFactory
//        self.presenter.showNextQuestionOrResults()
//
////        imageView.layer.masksToBounds = true
////        imageView.layer.borderWidth = 8
////        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
//
//
//        // запускаем задачу через 1 секунду c помощью диспетчера задач
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
//            guard let self = self else { return }
////            self.presenter.questionFactory = self.questionFactory
//            self.presenter.showNextQuestionOrResults()
//        }
//    }
    
    //метод, который содержит логику перехода в один из сценариев
    //    удалить?
//    private func showNextQuestionOrResults() {
//        if presenter.isLastQuestion() {
//            showFinalResults()
//
//            changeStateButton(isEnabled: true)
//
//            imageView.layer.masksToBounds = true
//            imageView.layer.borderWidth = 0
//            imageView.layer.cornerRadius = 20
//        }
//        else {
//            presenter.switchToNextQuestion()
//
////            self.questionFactory?.requestNextQuestion()
//
//            imageView.layer.masksToBounds = true
//            imageView.layer.borderWidth = 0
//            imageView.layer.cornerRadius = 20
//
//            changeStateButton(isEnabled: true)
//        }
//    }
    
    private func showFinalResults() {
        statisticService?.store(correct: presenter.correctAnswers, total: presenter.questionsAmount)
        let alertModel = AlertModel(
            title: "Этот раунд окончен!",
            message: getResultMessage(),
            buttonText: "Сыграть ещё раз",
            completion: { [weak self] in
                self?.presenter.currentQuestionIndex = 0
                self?.presenter.correctAnswers = 0
//                self?.questionFactory?.requestNextQuestion()
            }
        )
        alertPresenter?.show(alertModel: alertModel)
    }
    
    private func show(quiz result: QuizResultsViewModel) {
        let message = presenter.makeResultsMessage()
        
        let alert = UIAlertController(
            title: result.title,
            message: result.text,
            preferredStyle: .alert
        )
        
        let action = UIAlertAction(title: result.buttonText, style: .default) { [weak self] _ in
                guard let self = self else { return }
                
                self.presenter.restartGame()
            
            self.changeStateButton(isEnabled: true)
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
        let currentQuizResult = "Ваш результат: \(presenter.correctAnswers)\\\(presenter.questionsAmount)"
        let bestQuizInfo = "Рекорд: \(bestGame.correct)\\\(bestGame.total)" + "(\(bestGame.date.dateTimeString))"
        let averageAccuracyAllQuiz = "Средняя точность: \(String(format: "%.2f", statisticService!.totalAccuracy))%"
        let resultMessage = [currentQuizResult, totalPlaysQuizCount, bestQuizInfo, averageAccuracyAllQuiz].joined(separator: "\n")
        return resultMessage
    }
    
    
    private func changeStateButton(isEnabled: Bool){
        noButton.isEnabled = isEnabled
        yesButton.isEnabled = isEnabled
    }
    
   func showLoadingIndicator() {
        activityIndicator.isHidden = false // говорим, что индикатор загрузки не скрыт
        activityIndicator.startAnimating() // включаем анимацию
    }
    
    func showNetworkError(message: String) {
        hideLoadingIndicator()
        
        let model = AlertModel(title: "Ошибка",
                               message: message,
                               buttonText: "Попробовать еще раз") { [weak self] in
            guard let self = self else { return }
            
//            self.presenter.resetQuestionIndex()
//            self.correctAnswers = 0
            self.presenter.restartGame()
//            self.questionFactory?.requestNextQuestion()
        }
        
        alertPresenter?.show(alertModel: model)
    }
    
//    func didFailToLoadData(with error: Error) {
//        showNetworkError(message: error.localizedDescription)
//    }
    
//    func didLoadDataFromServer() {
//        activityIndicator.isHidden = true
//        questionFactory?.requestNextQuestion()
//    }
    
    func hideLoadingIndicator() {
        activityIndicator.isHidden = true
    }
    
    func highlightImageBorder(isCorrectAnswer: Bool) {
           imageView.layer.masksToBounds = true
           imageView.layer.borderWidth = 8
           imageView.layer.borderColor = isCorrectAnswer ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
       }
    
    
    
    // метод вызывается, когда пользователь нажимает на кнопку "Да"
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        presenter.yesButtonClicked()
        
//        changeStateButton(isEnabled: false)
    }
    
    // метод вызывается, когда пользователь нажимает на кнопку "Нет"
    @IBAction private func noButtonClicked(_ sender: UIButton ) {
        presenter.noButtonClicked()
        
//        changeStateButton(isEnabled: false)
    }
}
