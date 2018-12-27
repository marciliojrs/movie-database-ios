import RxSwift
import RxCocoa
import UIKit
import Foundation

struct RxAlertAction {
    let title: String
    let style: UIAlertAction.Style
    let result: RxAlertControllerResult

    init(title: String, style: UIAlertAction.Style = .default, result: RxAlertControllerResult) {
        self.title = title
        self.style = style
        self.result = result
    }
}

enum RxAlertControllerResult: Equatable {
    case action(String)
    case cancel

    static func == (lhs: RxAlertControllerResult, rhs: RxAlertControllerResult) -> Bool {
        switch (lhs, rhs) {
        case (.action(let left), .action(let right)): return left == right
        case (.cancel, .cancel): return true
        default: return false
        }
    }
}

extension Reactive where Base: UIAlertController {
    static func present(from viewController: UIViewController,
                        title: String?,
                        message: String?,
                        preferredStyle: UIAlertController.Style = .alert,
                        animated: Bool = true,
                        actions: [RxAlertAction],
                        originView: UIView? = nil) -> Observable<RxAlertControllerResult> {
        return Observable.create { observer -> Disposable in
            let alertController = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
            actions.map { rxAction in
                UIAlertAction(title: rxAction.title, style: rxAction.style, handler: { _ in
                    observer.on(.next(rxAction.result))
                    observer.on(.completed)
                })
            }.forEach(alertController.addAction)

            viewController.present(alertController, animated: animated, completion: nil)

            return Disposables.create {
                dismissViewController(alertController, animated: true, completion: nil)
            }
        }
    }
}
