import UIKit

final class AlertPresenter: AlertProtocol {
    private weak var delegate: UIViewController?
    init(viewController: UIViewController? = nil) {
        self.delegate = viewController
    }
    func show(alertModel: AlertModel) {
        let alert = UIAlertController(
            title: alertModel.title,
            message: alertModel.message,
            preferredStyle: .alert)
        let action = UIAlertAction(title: alertModel.buttonText, style: .default) { _ in
            alertModel.completion()
        }
        alert.addAction(action)
        alert.view.accessibilityIdentifier = "Game results"
        delegate?.present(alert, animated: true)
    }
}
