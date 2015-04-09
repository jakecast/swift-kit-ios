import UIKit

public extension Int {
    static func random(_ min: Int!=0, _ max: Int!=10) -> Int! {
        let range = UInt32(1 + abs(max - min))
        let randomValue = Int(arc4random_uniform(range))
        return min + randomValue
    }
    
    var doubleValue: Double {
        return self.asDouble()
    }
    
    var floatValue: Float {
        return self.asFloat()
    }
    
    var cgfloat: CGFloat {
        return self.asCGFloat()
    }

    var int16: Int16 {
        return self.asInt16()
    }

    var int64: Int64 {
        return self.asInt64()
    }
    
    var stringValue: String {
        return self.asString()
    }
    
    func asDouble() -> Double {
        return Double(self)
    }
    
    func asFloat() -> Float {
        return Float(self)
    }

    func asCGFloat() -> CGFloat {
        return CGFloat(self)
    }

    func asInt16() -> Int16 {
        return Int16(self)
    }

    func asInt64() -> Int64 {
        return Int64(self)
    }
    
    func asString() -> String {
        return "\(self)"
    }
}
