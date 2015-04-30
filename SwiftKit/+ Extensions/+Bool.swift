import Foundation

public extension Bool {
    var booleanValue: Boolean {
        return self.asBoolean()
    }
    
    func asBoolean() -> Boolean {
        return Boolean(bool: self)
    }
}