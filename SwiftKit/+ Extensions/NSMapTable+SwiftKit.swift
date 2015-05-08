import Foundation

public extension NSMapTable {
    public convenience init(keyValueOptions: PointerOptions) {
        self.init(keyOptions: keyValueOptions, valueOptions: keyValueOptions)
    }

    public convenience init(keyOptions: PointerOptions, valueOptions: PointerOptions) {
        self.init(keyOptions: keyOptions.rawValue, valueOptions: valueOptions.rawValue, capacity: 0)
    }

    public subscript(key: AnyObject) -> AnyObject? {
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
