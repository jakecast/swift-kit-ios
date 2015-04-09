import Foundation

public extension Int16 {
    var intValue: Int {
        return self.asInt()
    }

    func asInt() -> Int {
        return Int(self)
    }
}
