import UIKit

public extension UIViewController {
    var isDisplayed: Bool {
        return self.isViewLoaded() && self.view.window != nil
    }

    var isDismissing: Bool {
        return self.isBeingDismissed()
    }
    
    var navigationBarHeight: CGFloat {
        let navigationBarHeight: CGFloat
        if let navigationBar = self.navigationController?.navigationBar ?? (self as? UINavigationController)?.navigationBar {
            navigationBarHeight = navigationBar.minY + navigationBar.height
        }
        else {
            navigationBarHeight = 0
        }
        return navigationBarHeight
    }

    func add(#childViewController: UIViewController, containerView: UIView, frame: CGRect?=nil) {
        childViewController.view.frame = frame ?? containerView.bounds
        self.addChildViewController(childViewController)
        containerView.add(subview: childViewController.view)
        childViewController.didMoveToParentViewController(self)
    }

    func dismiss(#animated: Bool!, completionHandler: (Void -> Void)?=nil) {
        self.dismissViewControllerAnimated(animated, completion: completionHandler)
    }

    func present(#viewController: UIViewController!, animated: Bool!, completionHandler: (Void -> Void)?=nil) {
        self.presentViewController(viewController, animated: animated, completion: completionHandler)
    }

    func pop(#animated: Bool!) {
        self.navigationController?.popViewControllerAnimated(animated)
    }

    func push(#viewController: UIViewController!, animated: Bool!) {
        self.navigationController?.pushViewController(viewController, animated: animated)
    }

    func performSegue(#identifier: String) {
        self.performSegueWithIdentifier(identifier, sender: nil)
    }

    func set(#parentViewController: UIViewController!) {
        parentViewController.addChildViewController(self)
    }

    func set(#orientation: UIInterfaceOrientation) {
        UIDevice.currentInstance.setValue(orientation.rawValue, forKey: "orientation")
    }

    func transitionControllers(
        #fromViewController: UIViewController,
        toViewController: UIViewController,
        duration: NSTimeInterval,
        options: UIViewAnimationOptions=UIViewAnimationOptions.allZeros,
        animations: ((Void) -> (Void))?=nil,
        completionHandler: ((Bool) -> (Void))?=nil
    ) {
        self.transitionFromViewController(
            fromViewController,
            toViewController: toViewController,
            duration: duration,
            options: options,
            animations: animations,
            completion: {(didComplete) -> (Void) in
                toViewController.didMoveToParentViewController(self)
                fromViewController.removeFromParentViewController()

                completionHandler?(didComplete)
        })
    }
}
