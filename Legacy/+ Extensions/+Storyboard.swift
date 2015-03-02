import UIKit

public extension Storyboard {
    convenience init(name: String) {
        self.init(name: name, bundle: nil)
    }

    func instantiateViewController(#viewControllerIdentifier: String) -> ViewController {
        return self.instantiateViewControllerWithIdentifier(viewControllerIdentifier) as ViewController
    }
}
