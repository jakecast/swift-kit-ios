import UIKit

public extension UIDevice {
    static var currentInstance: UIDevice {
        return self.currentDevice()
    }
    
    static var currentInterfaceOrientation: UIInterfaceOrientation {
        let currentInstanceOrientation: UIInterfaceOrientation
        if let orientationRawValue = self.currentInstance.valueForKey("orientation") as? Int {
            currentInstanceOrientation = UIInterfaceOrientation(rawValue: orientationRawValue) ?? UIInterfaceOrientation.Unknown
        }
        else {
            currentInstanceOrientation = UIInterfaceOrientation.Unknown
        }
        return currentInstanceOrientation
    }
    
    static var currentUserInterfaceIdiom: UIUserInterfaceIdiom {
        return self.currentInstance.userInterfaceIdiom
    }
    
    static var isLandscapeOrientation: Bool {
        return self.currentInterfaceOrientation.isLandscape
    }
    
    static var isPortraitOrientation: Bool {
        return self.currentInterfaceOrientation.isPortrait
    }
    
    static var isPhoneIdiom: Bool {
        return self.currentUserInterfaceIdiom.isPhone
    }
    
    static var isPadIdiom: Bool {
        return self.currentUserInterfaceIdiom.isPad
    }
    
    static var isSimulator: Bool {
        return (self.currentInstance.name.rangeOfString("Simulator") != nil)
    }
}
