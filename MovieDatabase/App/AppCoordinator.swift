import Foundation
import UIKit
import URLNavigator

final class AppCoordinator {
    init(window: UIWindow, navigator: NavigatorType) {
        let viewController = navigator.viewController(for: "upcoming")!
        let navigationController = AppNavigationController(rootViewController: viewController)
        navigationController.navigationBar.prefersLargeTitles = true
        window.rootViewController = navigationController
    }
}
