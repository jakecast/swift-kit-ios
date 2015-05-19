import UIKit

public extension NSNotificationCenter {
    static var defaultInstance: NSNotificationCenter {
        return self.defaultCenter()
    }
    
    func post(#notificationName: StringRepresentable, object: AnyObject?=nil, userInfo: [NSObject:AnyObject]?=nil) {
        self.postNotification(NSNotification(name: notificationName.stringValue, object: object, userInfo: userInfo))
    }
    
    func post(#notification: NSNotification) {
        self.postNotification(notification)
    }
    
    func add(#observer: AnyObject, selector: Selector, notificationName: String?, object: AnyObject?) -> Self {
        self.addObserver(observer, selector: selector, name: notificationName, object: object)
        return self
    }
    
    func remove(#observer: AnyObject) -> Self {
        self.removeObserver(observer)
        return self
    }
}
