import UIKit

public extension Int {
    static func random(_ min: Int!=0, _ max: Int!=10) -> Int! {
        let range = UInt32(1 + abs(max - min))
        let randomValue = Int(arc4random_uniform(range))
        return min + randomValue
    }
    
    var double: Double {
        return self.asDouble()
    }
    
    var float: Float {
        return self.asFloat()
    }
    
    var cgfloat: CGFloat {
        return self.asCGFloat()
    }

    var int64: Int64 {
        return self.asInt64()
    }
    
    var string: String {
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

    func asInt64() -> Int64 {
        return Int64(self)
    }
    
    func asString() -> String {
        return "\(self)"
    }
}
