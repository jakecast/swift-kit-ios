import UIKit

public extension UIDevice {
    class var currentInstance: UIDevice {
        return self.currentDevice()
    }
    
    class var interfaceOrientation: UIInterfaceOrientation {
        let currentInstanceOrientation: UIInterfaceOrientation
        if let orientationRawValue = self.currentInstance.valueForKey("orientation") as? Int {
            currentInstanceOrientation = UIInterfaceOrientation(rawValue: orientationRawValue) ?? UIInterfaceOrientation.Unknown
        }
        else {
            currentInstanceOrientation = UIInterfaceOrientation.Unknown
        }
        return currentInstanceOrientation
    }

    class var isSimulator: Bool {
        return (self.currentInstance.name.rangeOfString("Simulator") != nil)
    }
    
    class var isLandscapeOrientation: Bool {
        return (self.interfaceOrientation == UIInterfaceOrientation.LandscapeLeft || self.interfaceOrientation == UIInterfaceOrientation.LandscapeRight)
    }
    
    class var isPortraitOrientation: Bool {
        return (self.interfaceOrientation == UIInterfaceOrientation.Portrait || self.interfaceOrientation == UIInterfaceOrientation.PortraitUpsideDown)
    }
}