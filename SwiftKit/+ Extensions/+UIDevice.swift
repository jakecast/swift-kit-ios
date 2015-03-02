import UIKit

public extension UIDevice {
    class var currentInstance: UIDevice {
        return self.currentDevice()
    }

    class var isSimulator: Bool {
        return (self.currentInstance.name.rangeOfString("Simulator") != nil)
    }
}