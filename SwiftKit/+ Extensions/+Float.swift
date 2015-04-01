import UIKit

public extension Float {
    var intValue: Int {
        return self.asInt()
    }
    
    var stringValue: String {
        return self.asString()
    }

    func asInt() -> Int {
        return Int(self)
    }
    
    func asString() -> String {
        return "\(self)"
    }
    
    func round(precision: Int=0) -> Float {
        let increment = 1.0 / pow(10.0, precision.floatValue)
        let remainder = self % increment
        return remainder < increment / 2 ? self - remainder : self - remainder + increment
    }
}