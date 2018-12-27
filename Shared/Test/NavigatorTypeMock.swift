import URLNavigator

class NavigatorTypeMock: NavigatorType {
    var matcher: URLMatcher = URLMatcher()
    var delegate: NavigatorDelegate?

    var registerCalled = false
    func register(_ pattern: URLPattern, _ factory: @escaping ViewControllerFactory) {
        registerCalled = true
    }

    var handleCalled = false
    func handle(_ pattern: URLPattern, _ factory: @escaping URLOpenHandlerFactory) {
        handleCalled = true
    }

    var viewControllerForContextCalled = false
    func viewController(for url: URLConvertible, context: Any?) -> UIViewController? {
        viewControllerForContextCalled = true
        return nil
    }

    var handlerForContextCalled = false
    func handler(for url: URLConvertible, context: Any?) -> URLOpenHandler? {
        handlerForContextCalled = true
        return nil
    }

    var pushURLContextFromAnimatedCalled = false
    @discardableResult
    func pushURL(_ url: URLConvertible, context: Any?, from: UINavigationControllerType?, animated: Bool) -> UIViewController? {
        pushURLContextFromAnimatedCalled = true
        return nil
    }

    var pushViewControllerFromAnimatedCalled = false
    @discardableResult
    func pushViewController(_ viewController: UIViewController, from: UINavigationControllerType?, animated: Bool) -> UIViewController? {
        pushViewControllerFromAnimatedCalled = true
        return nil
    }

    var presentURLContextWrapFromAnimatedCompletionCalled = false
    @discardableResult
    func presentURL(_ url: URLConvertible, context: Any?, wrap: UINavigationController.Type?, from: UIViewControllerType?, animated: Bool, completion: (() -> Void)?) -> UIViewController? {
        presentURLContextWrapFromAnimatedCompletionCalled = true
        return nil
    }

    var presentViewControllerWrapFromAnimatedCompletionCalled = false
    @discardableResult
    func presentViewController(_ viewController: UIViewController, wrap: UINavigationController.Type?, from: UIViewControllerType?, animated: Bool, completion: (() -> Void)?) -> UIViewController? {
        presentViewControllerWrapFromAnimatedCompletionCalled = true
        return nil
    }

    var openURLContextCalled = false
    @discardableResult
    func openURL(_ url: URLConvertible, context: Any?) -> Bool {
        openURLContextCalled = true
        return false
    }
}
