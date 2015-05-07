import UIKit

public extension UIUserInterfaceIdiom {
    var isPhone: Bool {
        return (self == UIUserInterfaceIdiom.Phone)
    }
    
    var isPad: Bool {
        return (self == UIUserInterfaceIdiom.Pad)
    }
}
