import Foundation

public extension Int64 {
    var intValue: Int {
        return self.asInt()
    }

    func asInt() -> Int {
        return Int(self)
    }
}