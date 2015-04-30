import Foundation

public extension CFNotificationCenter {
    static var darwinNotifyInstance: CFNotificationCenter {
        return self.darwinNotificationCenter()
    }
    
    static func darwinNotificationCenter() -> CFNotificationCenter {
        return CFNotificationCenterGetDarwinNotifyCenter()
    }
    
    func add(
        #observer: AnyObject,
        notification: String,
        suspensionBehavior: CFNotificationSuspensionBehavior=CFNotificationSuspensionBehavior.DeliverImmediately,
        callbackBlock: CFNotificationCallback
    ) {
        weak var weakObserver: AnyObject? = observer
        
        CFNotificationCenterAddObserver(self, unsafePointer(weakObserver) ?? nil, callbackBlock, notification, nil, suspensionBehavior)
    }
    
    func post(#notification: String) {
        CFNotificationCenterPostNotification(self, notification, nil, nil, true.booleanValue)
    }
    
    func remove(#observer: AnyObject, notification: String) {
        CFNotificationCenterRemoveObserver(self, unsafePointer(observer) ?? nil, notification, nil)
    }
}
