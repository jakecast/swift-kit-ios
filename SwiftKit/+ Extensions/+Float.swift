import UIKit

public extension Float {
    var intValue: Int {
        return self.asInt()
    }

    func asInt() -> Int {
        return Int(self)
    }
}