import UIKit

public extension UIWindow {
    static var applicationKeyInstance: UIWindow? {
        return self.applicationKeyWindow()
    }
    
    static func applicationKeyWindow() -> UIWindow? {
        return UIApplication.mainInstance?.keyWindow
    }
    
    override func add(#gestureRecognizer: UIGestureRecognizer?) {
        weak var weakGesture: UIGestureRecognizer? = gestureRecognizer
        if let gesture = weakGesture {
            self.addGestureRecognizer(gesture)
        }
    }
}