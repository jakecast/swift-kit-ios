import UIKit

public extension UIApplication {
    var rootViewController: UIViewController? {
        return self.initialViewController()
    }
    
    var rootView: UIView? {
        return self.initialView()
    }
    
    func initialViewController() -> UIViewController? {
        return self.keyWindow?.rootViewController
    }
    
    func initialView() -> UIView? {
        return self.rootViewController?.view
    }
    
    func set(#minimumBackgroundFetchInterval: NSTimeInterval) {
        self.setMinimumBackgroundFetchInterval(minimumBackgroundFetchInterval)
    }
}
