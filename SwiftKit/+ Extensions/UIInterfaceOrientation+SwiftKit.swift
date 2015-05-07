import UIKit

public extension UIInterfaceOrientation {
    var isLandscape: Bool {
        return (self == UIInterfaceOrientation.LandscapeLeft || self == UIInterfaceOrientation.LandscapeRight)
    }
    
    var isPortrait: Bool {
        return (self == UIInterfaceOrientation.Portrait || self == UIInterfaceOrientation.PortraitUpsideDown)
    }
}
