import UIKit

public extension UIViewController {
    var navigationBarHeight: CGFloat {
        let navigationBarHeight: CGFloat
        if let navigationBar = self.navigationController?.navigationBar {
            navigationBarHeight = navigationBar.minY + navigationBar.height
        }
        else {
            navigationBarHeight = 0
        }
        return navigationBarHeight
    }

    var isDisplayed: Bool {
        return self.isViewLoaded() && self.view.window != nil
    }

    var isDismissing: Bool {
        return self.isBeingDismissed()
    }

    func present(#viewController: UIViewController!, animated: Bool!, completion: (Void -> Void)?=nil) {
        self.presentViewController(viewController, animated: animated, completion: completion)
    }

    func dismiss(#animated: Bool!, completion: (Void -> Void)?=nil) {
        self.dismissViewControllerAnimated(animated, completion: completion)
    }

    func push(#viewController: UIViewController!, animated: Bool!) {
        self.navigationController?.pushViewController(viewController, animated: animated)
    }

    func pop(#animated: Bool!) {
        self.navigationController?.popViewControllerAnimated(animated)
    }

    func set(#parentViewController: UIViewController!) {
        parentViewController.addChildViewController(self)
    }
}
