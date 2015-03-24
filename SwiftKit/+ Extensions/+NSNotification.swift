import Foundation

public extension NSNotification {
    subscript(userInfoKey: NSObject) -> AnyObject? {
        return self.userInfo?[userInfoKey]
    }
}