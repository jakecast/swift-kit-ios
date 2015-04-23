import Foundation

public extension NSNotification {
    var keys: [NSObject] {
        return self.userInfo?.keys.array ?? []
    }
    
    subscript(userInfoKey: NSObject) -> AnyObject? {
        return self.userInfo?[userInfoKey]
    }
}