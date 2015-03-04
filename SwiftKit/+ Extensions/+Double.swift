import UIKit

public extension Double {
    var cgfloat: CGFloat {
        return self.asCGFloat()
    }
    
    var string: String {
        return self.asString()
    }
    
    func asCGFloat() -> CGFloat {
        return CGFloat(self)
    }
    
    func asString() -> String {
        return "\(self)"
    }
}