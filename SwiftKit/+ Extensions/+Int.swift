import UIKit


public extension Int {
    var int64: Int64 {
        return self.asInt64()
    }

    func asInt64() -> Int64 {
        return Int64(self)
    }
}