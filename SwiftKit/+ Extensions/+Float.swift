import UIKit

public extension Float {
    var int: Int {
        return self.asInt()
    }
    
    var string: String {
        return self.asString()
    }

    func asInt() -> Int {
        return Int(self)
    }
    
    func asString() -> String {
        return "\(self)"
    }
}