import UIKit

public extension UIWindow {
    static var mainInstance: UIWindow? {
        return self.mainWindow()
    }
    
    static func mainWindow() -> UIWindow? {
        return UIApplication.mainInstance?.keyWindow
    }
    
    override func add(#gestureRecognizer: UIGestureRecognizer?) {
        weak var weakGesture: UIGestureRecognizer? = gestureRecognizer
        if let gesture = weakGesture {
            self.addGestureRecognizer(gesture)
        }
    }
}