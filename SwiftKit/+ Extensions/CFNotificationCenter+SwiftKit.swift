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
        notification: StringRepresentable,
        suspensionBehavior: CFNotificationSuspensionBehavior=CFNotificationSuspensionBehavior.DeliverImmediately,
        handler: ((notification: String)->(Void))
    ) {
        let center: CFNotificationCenterRef
        let notificationName: String
        center = self
        notificationName = notification.stringValue


        let callback: (Void)->(Void)
        let callbackBlock: AnyObject
        let callbackImplementation: COpaquePointer
        let callbackObserver: CFNotificationCallback
        callback = { handler(notification: notificationName) }
        callbackBlock = unsafeBitCast(callback as (Void)->(Void) as @objc_block (Void)->(Void), AnyObject.self)
        callbackImplementation = imp_implementationWithBlock(callbackBlock)
        callbackObserver = CFNotificationCallback(callbackImplementation)

        CFNotificationCenterAddObserver(
            center,
            unsafeAddressOf(observer),
            callbackObserver,
            notificationName,
            nil,
            suspensionBehavior
        )
    }

    func post(#notification: String) {
        let center: CFNotificationCenterRef
        let notificationName: String
        center = self
        notificationName = notification.stringValue

        CFNotificationCenterPostNotification(
            center,
            notificationName,
            nil,
            nil,
            true.booleanValue
        )
    }
    
    func remove(#observer: AnyObject, notification: String) {
        let center: CFNotificationCenterRef
        let notificationName: String
        center = self
        notificationName = notification.stringValue

        CFNotificationCenterRemoveObserver(
            center,
            unsafeAddressOf(observer),
            notificationName,
            nil
        )
    }

    func remove(#observer: AnyObject) {
        let center: CFNotificationCenterRef
        center = self

        CFNotificationCenterRemoveEveryObserver(
            center,
            unsafeAddressOf(observer)
        )
    }
}
