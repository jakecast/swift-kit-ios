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
}