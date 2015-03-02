import UIKit

public extension Object {
    class func className() -> String {
        return NSStringFromClass(self)
    }
}
