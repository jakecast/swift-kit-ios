import UIKit

public extension Double {
    var floatValue: Float {
        return self.asFloat()
    }

    var cgfloatValue: CGFloat {
        return self.asCGFloat()
    }

    var stringValue: String {
        return self.asString()
    }

    func asFloat() -> Float {
        return Float(self)
    }

    func asCGFloat() -> CGFloat {
        return CGFloat(self)
    }
    
    func asString() -> String {
        return "\(self)"
    }
    
    func round(precision: Int=0) -> Double {
        let increment = 1.0 / pow(10.0, precision.doubleValue)
        let remainder = self % increment
        return remainder < increment / 2 ? self - remainder : self - remainder + increment
    }
}