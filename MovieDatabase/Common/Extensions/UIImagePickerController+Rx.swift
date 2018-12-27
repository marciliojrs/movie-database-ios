import UIKit
import RxSwift
import RxCocoa

open class RxImagePickerDelegateProxy: RxNavigationControllerDelegateProxy, UIImagePickerControllerDelegate {
    public init(imagePicker: UIImagePickerController) {
        super.init(navigationController: imagePicker)
    }
}

extension Reactive where Base: UIImagePickerController {
    public var didFinishPickingMediaWithInfo: Observable<[UIImagePickerController.InfoKey: Any]> {
        return RxImagePickerDelegateProxy.proxy(for: base)
            .methodInvoked(#selector(UIImagePickerControllerDelegate
                .imagePickerController(_:didFinishPickingMediaWithInfo:)))
            .map { (param) in return try castOrThrow([UIImagePickerController.InfoKey: Any].self, param[1]) }
    }

    public var didCancel: Observable<()> {
        return RxImagePickerDelegateProxy.proxy(for: base)
            .methodInvoked(#selector(UIImagePickerControllerDelegate.imagePickerControllerDidCancel(_:)))
            .map { _ in () }
    }

    static func present(
        fromParent parent: UIViewController?,
        animated: Bool = true,
        configureImagePicker: @escaping (UIImagePickerController) throws -> Void = { _ in }
    ) -> Observable<UIImagePickerController> {
        return Observable.create { [weak parent] observer in
            let imagePicker = UIImagePickerController()

            let dismissDisposable = imagePicker.rx.didCancel
                .subscribe(onNext: { [weak imagePicker] in
                    guard let imagePicker = imagePicker else { return }
                    dismissViewController(imagePicker, animated: animated, completion: nil)
                })

            do {
                try configureImagePicker(imagePicker)
            } catch let error {
                observer.on(.error(error))
                return Disposables.create()
            }

            guard let parent = parent else {
                observer.on(.completed)
                return Disposables.create()
            }

            parent.present(imagePicker, animated: animated, completion: nil)
            observer.on(.next(imagePicker))

            return Disposables.create(dismissDisposable, Disposables.create {
                dismissViewController(imagePicker, animated: animated, completion: nil)
            })
        }
    }
}

private func castOrThrow<T>(_ resultType: T.Type, _ object: Any) throws -> T {
    guard let returnValue = object as?   T else {
        throw RxCocoaError.castingError(object: object, targetType: resultType)
    }

    return returnValue
}
