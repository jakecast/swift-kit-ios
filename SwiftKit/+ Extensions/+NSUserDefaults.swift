import UIKit

public extension NSUserDefaults {
    func set(#bool: Bool, key: String) -> Self {
        self.setBool(bool, forKey: key)
        return self
    }
}