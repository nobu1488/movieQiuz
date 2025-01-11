import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate, AlertPresenterDelegate {
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private weak var yesButton: UIButton!
    @IBOutlet private weak var noButton: UIButton!
    @IBOutlet private weak var questionTitle: UILabel!
    
    private var currentQuestionIndex = 0
    private var correctAnswers = 0
    private let questionsAmount: Int = 10
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    private var alertPresenter: AlertPresenterProtocol?
    private var statisticService: StatisticServiceProtocol = StatisticService()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //fonts
        textLabel.font = UIFont(name: "YSDisplay-Bold", size: 23)
        counterLabel.font = UIFont(name: "YSDisplay-Medium", size: 20)
        questionTitle.font = UIFont(name: "YSDisplay-Medium", size: 20)
        yesButton.titleLabel?.font = UIFont(name: "YSDisplay-Medium"
        , size: 20)
        noButton.titleLabel?.font = UIFont(name: "YSDisplay-Medium"
        , size: 20)
        
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        
        
        let alertPresenter = AlertPresenter()
        alertPresenter.delegate = self
        self.alertPresenter = alertPresenter
        
        let questionFactory = QuestionFactory()
        questionFactory.delegate = self
        self.questionFactory = questionFactory
        
        questionFactory.requestNextQuestion()
        
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer: Bool = false
        changeButtonState(isEnabled: false)
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    @IBAction  private func yesButtonClicked(_ sender: UIButton) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer: Bool = true
        changeButtonState(isEnabled: false)
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    func show(alert: UIAlertController) {
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.show(quizStep: viewModel)
        }
    }
    
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        let questionConvert = QuizStepViewModel(
            image: UIImage(imageLiteralResourceName: model.image),
            question: model.text,
            questionNumber: "\(currentQuestionIndex+1)/\(questionsAmount)")
        return questionConvert
    }
    
    private func changeButtonState(isEnabled: Bool) {
        yesButton.isEnabled = isEnabled
        noButton.isEnabled = isEnabled
    }
    
    private func show(quizStep: QuizStepViewModel) {
        imageView.image = quizStep.image
        textLabel.text = quizStep.question
        counterLabel.text = quizStep.questionNumber
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        if isCorrect {
            imageView.layer.borderColor = UIColor.ypGreen.cgColor
            correctAnswers += 1
        } else {imageView.layer.borderColor = UIColor.ypRed.cgColor}
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.showNextQuestionOrResults()
            imageView.layer.borderColor = UIColor.clear.cgColor
            changeButtonState(isEnabled: true)
        }
    }
    
    private func show(quizResult:QuizResultsViewModel){
        
        let alertModel = AlertModel(title: quizResult.title, message: quizResult.text, buttonText: quizResult.buttonText,
                                    completion: { [weak self] in
            guard let self = self else { return}
            self.currentQuestionIndex = 0
            self.correctAnswers = 0
            self.imageView.layer.borderColor = UIColor.clear.cgColor
            questionFactory?.requestNextQuestion()
        })
        alertPresenter?.show(alertModel: alertModel)
    }
    
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questionsAmount - 1{
            statisticService.store(correct: correctAnswers, total: questionsAmount)
            let gamesCount = statisticService.gamesCount
            let bestGame = statisticService.bestGame
            let Accuracy = String(format: "%.2f", statisticService.totalAccuracy)
            let text = "Ваш результат: \(correctAnswers)/10 \n Количество сыгранных квизов: \(gamesCount) \n Рекорд:\(bestGame.correct) (\(bestGame.date.dateTimeString)) \n Средняя точность: \(Accuracy) %"
            
            let viewModel = QuizResultsViewModel(
                title: "Раунд окончен", text:text, buttonText: "Сыграть еще раз"
            )
            show(quizResult: viewModel)
        } else {
            currentQuestionIndex += 1
            questionFactory?.requestNextQuestion()
        }
    }
}
