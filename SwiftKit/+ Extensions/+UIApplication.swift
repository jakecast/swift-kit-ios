import UIKit

public extension UIApplication {
    var rootViewController: UIViewController? {
        return self.appRootViewController()
    }
    
    func appRootViewController() -> UIViewController? {
        return self.keyWindow?.rootViewController
    }
    
    func set(#minimumBackgroundFetchInterval: NSTimeInterval) {
        self.setMinimumBackgroundFetchInterval(minimumBackgroundFetchInterval)
    }
}
