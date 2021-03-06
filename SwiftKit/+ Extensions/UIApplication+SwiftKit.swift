import UIKit

public extension UIApplication {
    private struct Extension {
        static weak var mainInstance: UIApplication?
    }
    
    static var mainInstance: UIApplication? {
        return self.mainApplication()
    }
    
    static var mainInstanceViewController: UIViewController? {
        return self.mainApplicationViewController()
    }
    
    static func mainApplication() -> UIApplication? {
        return Extension.mainInstance
    }
    
    static func mainApplicationViewController() -> UIViewController? {
        return self
            .mainApplication()?
            .initialViewController()
    }
    
    var rootViewController: UIViewController? {
        return self.initialViewController()
    }
    
    var rootView: UIView? {
        return self.initialView()
    }

    func applicationDelegate() -> UIApplicationDelegate? {
        return self.delegate
    }
    
    func becomeMainApplication() -> Self {
        Extension.mainInstance = self
        return self
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
