import Foundation

protocol MovieQuizViewControllerProtocol: AnyObject {
    func show(quizStep: QuizStepViewModel)
    func show(quizResult: QuizResultsViewModel)
    
    func highlightImageBorder(isCorrectAnswer: Bool)
    
    func showLoadingIndicator()
    func hideLoadingIndicator()
    func changeButtonState(isEnabled: Bool)
    func removeImageBorder()
    
    func showNetworkError(message: String)
}
