import UIKit

public extension UINavigationController {
    var controllers: [UIViewController] {
        get {
            return self.viewControllers
                .map { return $0 as? UIViewController }
                .filter { return $0 != nil }
                .map { return $0! }
        }
        set(newValue) {
            self.viewControllers = newValue
        }
    }

    public override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return self.visibleViewController?.preferredStatusBarStyle() ?? super.preferredStatusBarStyle()
    }

    public override func shouldAutorotate() -> Bool {
        return self.visibleViewController?.shouldAutorotate() ?? super.shouldAutorotate()
    }

    public override func supportedInterfaceOrientations() -> Int {
        return self.visibleViewController?.supportedInterfaceOrientations() ?? super.supportedInterfaceOrientations()
    }

    public override func preferredInterfaceOrientationForPresentation() -> UIInterfaceOrientation {
        return self.visibleViewController?.preferredInterfaceOrientationForPresentation() ?? super.preferredInterfaceOrientationForPresentation()
    }
}
