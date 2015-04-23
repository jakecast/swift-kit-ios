import UIKit

public extension UIScreen {
    static var mainScreenScale: CGFloat {
        return self.mainInstance.scale
    }
    
    static var mainScreenBounds: CGRect {
        return self.mainInstance.bounds
    }

    static var mainScreenWidth: CGFloat {
        return self.mainScreenBounds.width
    }

    static var mainScreenHeight: CGFloat {
        return self.mainScreenBounds.height
    }

    static var mainInstance: UIScreen {
        return self.mainScreen()
    }
}