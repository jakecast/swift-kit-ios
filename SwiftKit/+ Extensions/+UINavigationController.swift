import UIKit

public extension UINavigationController {
    var visibleStatusBarStyle: UIStatusBarStyle {
        let visibleStatusBarStyle: UIStatusBarStyle
        if self.visibleViewController?.isDismissing == false {
            visibleStatusBarStyle = self.visibleViewController.preferredStatusBarStyle()
        }
        else {
            visibleStatusBarStyle = UIStatusBarStyle.Default
        }
        return visibleStatusBarStyle
    }
}