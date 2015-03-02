import UIKit

public extension UIScreen {
    class var mainScreenBounds: CGRect {
        return self.mainInstance.bounds
    }

    class var mainScreenWidth: CGFloat {
        return self.mainScreenBounds.width
    }

    class var mainScreenHeight: CGFloat {
        return self.mainScreenBounds.height
    }

    class var mainInstance: UIScreen {
        return self.mainScreen()
    }
}