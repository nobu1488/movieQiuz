import UIKit

class AlertPresenter:AlertPresenterProtocol{
    var delegate: AlertPresenterDelegate?
    func show(alertModel: AlertModel) {
        let alert = UIAlertController(title: alertModel.title, message: alertModel.message, preferredStyle: .alert)
        let action = UIAlertAction(title: alertModel.buttonText, style: .default){_ in alertModel.completion()}
        alert.addAction(action)
        delegate?.show(alert: alert)
    }
}
