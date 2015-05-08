import UIKit

public extension UIScreen {
    static var isLandscapeOrientation: Bool {
        return UIDevice.isLandscapeOrientation
    }

    static var isPortraitOrientation: Bool {
        return UIDevice.isPortraitOrientation
    }

    static var mainInstance: UIScreen {
        return self.mainScreen()
    }

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
    
    static var mainScreenCenter: CGPoint {
        return CGPoint(x: self.mainScreenWidth / 2, y: self.mainScreenHeight / 2)
    }

    static var mainScreenOrientation: UIInterfaceOrientation {
        return UIDevice.currentInterfaceOrientation
    }
}