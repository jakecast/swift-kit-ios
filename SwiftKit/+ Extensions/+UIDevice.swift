import UIKit

public extension UIDevice {
    static var currentInstance: UIDevice {
        return self.currentDevice()
    }
    
    static var interfaceOrientation: UIInterfaceOrientation {
        let currentInstanceOrientation: UIInterfaceOrientation
        if let orientationRawValue = self.currentInstance.valueForKey("orientation") as? Int {
            currentInstanceOrientation = UIInterfaceOrientation(rawValue: orientationRawValue) ?? UIInterfaceOrientation.Unknown
        }
        else {
            currentInstanceOrientation = UIInterfaceOrientation.Unknown
        }
        return currentInstanceOrientation
    }

    static var isSimulator: Bool {
        return (self.currentInstance.name.rangeOfString("Simulator") != nil)
    }
    
    static var isLandscapeOrientation: Bool {
        return (self.interfaceOrientation == UIInterfaceOrientation.LandscapeLeft || self.interfaceOrientation == UIInterfaceOrientation.LandscapeRight)
    }
    
    static var isPortraitOrientation: Bool {
        return (self.interfaceOrientation == UIInterfaceOrientation.Portrait || self.interfaceOrientation == UIInterfaceOrientation.PortraitUpsideDown)
    }
}