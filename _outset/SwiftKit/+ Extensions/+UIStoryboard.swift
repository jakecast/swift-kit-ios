import UIKit

public extension UIStoryboard {
    convenience init(name: String) {
        self.init(name: name, bundle: nil)
    }
    
    func instantiateViewController(#viewControllerIdentifier: String) -> UIViewController {
        return self.instantiateViewControllerWithIdentifier(viewControllerIdentifier) as! UIViewController
    }
}
