import Foundation
import UIKit

extension UINavigationController {
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        if let rootViewController = viewControllers.last {
            return rootViewController.preferredStatusBarStyle
        }

        return super.preferredStatusBarStyle
    }

    open override var prefersStatusBarHidden: Bool {
        if let rootViewController = viewControllers.last {
            return rootViewController.prefersStatusBarHidden
        }

        return super.prefersStatusBarHidden
    }

    open override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        if let rootViewController = viewControllers.last {
            return rootViewController.preferredStatusBarUpdateAnimation
        }

        return super.preferredStatusBarUpdateAnimation
    }
}
