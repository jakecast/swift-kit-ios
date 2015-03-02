import UIKit

public extension Double {
    var cgfloat: CGFloat {
        return self.asCGFloat()
    }
    
    func asCGFloat() -> CGFloat {
        return CGFloat(self)
    }
}