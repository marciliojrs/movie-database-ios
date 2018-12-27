import RxSwift
import RxCocoa
import Layout
import Domain
import Foundation

typealias ViewState = [String: Any?]
typealias LayoutConstants = [String: Any]

protocol LayoutableController: LayoutLoading {
    var initialViewState: ViewState { get }
    var constants: LayoutConstants { get }

    func bindOutlets()
    func layoutLoad()
    func setState(_ state: ViewState)
    func setState(_ state: ViewState, animated: Bool)
}

extension LayoutableController where Self: UIViewController {
    var constants: LayoutConstants { return [:] }
    var initialViewState: ViewState { return [:] }

    func layoutDidLoad(_ layoutNode: LayoutNode) {
        layoutLoad()
    }

    func setState(_ state: ViewState) {
        layoutNode?.setState(state, animated: false)
    }

    func setState(_ state: ViewState, animated: Bool) {
        layoutNode?.setState(state, animated: animated)
    }
}

class BaseViewController<T: RxViewModel>: UIViewController, ViewModelController, LayoutableController {
    private(set) var bag = DisposeBag()
    private(set) var viewModel: T

    open var layout: LayoutFile? { return nil }
    open var hideNavigationBarWhenAppear: Bool = false
    open var hideBackButtonTitle: Bool = true
    open var prefersNavigationTransparent: Bool { return false }
    open var constants: LayoutConstants { return [:] }
    open var initialViewState: ViewState { return [:] }

//    fileprivate(set) lazy var loadingView: LoadingView = LoadingView.addTo(view: UIApplication.shared.keyWindow!)
    private lazy var closeButton: UIBarButtonItem = {
        return UIBarButtonItem(title: "Close", style: .plain, target: nil, action: nil)
    }()

    required init(viewModel: T) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)

        if let layout = layout {
            loadLayout(layout, state: initialViewState, constants: constants)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init?(coder:) not implemented")
    }

    deinit { bag = DisposeBag() }

    func bindOutlets() {}
    func layoutLoad() {}

    override func viewDidLoad() {
        super.viewDidLoad()

        if hideBackButtonTitle {
            navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.setNavigationBarHidden(hideNavigationBarWhenAppear, animated: true)
        addCloseButtonForModalIfNeeded()

        if prefersNavigationTransparent {
            enableTransparentNavigationBar()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if prefersNavigationTransparent {
            disableTransparentNavigationBar()
        }
    }

    func layoutDidLoad(_ layoutNode: LayoutNode) {
        bag = DisposeBag()
        addCloseButtonForModalIfNeeded()
        layoutLoad()
        bindOutlets()
    }

    private func addCloseButtonForModalIfNeeded() {
        if isModal && navigationController?.viewControllers.first == self {
            navigationItem.leftBarButtonItem = closeButton
            bag << closeButton.rx.tap.subscribe(onNext: { [unowned self] _ in
                dismissViewController(self, animated: true, completion: nil)
            })
        }
    }

    private func enableTransparentNavigationBar() {
        navigationController?.navigationBar.barTintColor = .clear
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.backgroundColor = .clear
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.prefersLargeTitles = false
    }

    private func disableTransparentNavigationBar() {
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.shadowImage = nil
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}

extension BaseViewController {
    func setDatePickerKeyboard(for textField: UITextField) {
        let datePicker = UIDatePicker(frame: .zero)
        datePicker.datePickerMode = .date
        textField.inputView = datePicker

        bag << datePicker.rx.value.skip(1).map { (date) -> String in
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yyyy"
            return formatter.string(from: date)
        }.bind(to: textField.rx.value)
    }

    func presentImageSelector() -> Observable<RxAlertControllerResult> {
        var actions: [RxAlertAction] = []
        if !Platform.isRunningOnSimulator {
            actions.append(RxAlertAction(title: R.string.localizable.imagePickerSourceSelectCamera(),
                                         style: .default,
                                         result: .action("camera")))
        }
        actions.append(RxAlertAction(title: R.string.localizable.imagePickerSourceSelectLibrary(),
                                     style: .default,
                                     result: .action("library")))
        actions.append(RxAlertAction(title: R.string.localizable.imagePickerSourceSelectCancel(),
                                     style: .cancel,
                                     result: .cancel))

        return UIAlertController.rx.present(from: self,
                                            title: nil,
                                            message: nil,
                                            preferredStyle: .actionSheet,
                                            actions: actions)
            .filter { $0 == .action("camera") || $0 == .action("library") }
    }

    func showImagePickerAndProcessSelectedImage(source: UIImagePickerController.SourceType) -> Observable<UIImage?> {
        return UIImagePickerController.rx.present(
            fromParent: self,
            configureImagePicker: { (picker) in
                picker.sourceType = source
            }
        ).flatMap { $0.rx.didFinishPickingMediaWithInfo }
        .map { info -> UIImage? in
            return info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        }.do(onNext: { [unowned self] _ in self.dismiss(animated: true, completion: nil) })
    }
}

extension Reactive where Base: LayoutableController {
    var state: Binder<ViewState> {
        return Binder(self.base) { (target: LayoutableController, value: ViewState) in
            target.setState(value)
        }
    }

    var stateAnimated: Binder<ViewState> {
        return Binder(self.base) { (target: LayoutableController, value: ViewState) in
            target.setState(value, animated: true)
        }
    }
}

func dismissViewController(_ viewController: UIViewController, animated: Bool, completion: (() -> Void)?) {
    if viewController.isBeingDismissed || viewController.isBeingPresented {
        DispatchQueue.main.async {
            dismissViewController(viewController, animated: animated, completion: completion)
        }

        return
    }

    if viewController.presentingViewController != nil {
        viewController.dismiss(animated: animated, completion: completion)
    }
}
