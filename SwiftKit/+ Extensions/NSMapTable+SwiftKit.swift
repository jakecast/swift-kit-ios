import Foundation

public extension NSMapTable {
    subscript(key: AnyObject) -> AnyObject? {
        get {
            return self.objectForKey(key)
        }
        set(newValue) {
            if let value: AnyObject = newValue {
                self.setObject(value, forKey: key)
            }
            else {
                self.removeObjectForKey(key)
            }
        }
    }
}
