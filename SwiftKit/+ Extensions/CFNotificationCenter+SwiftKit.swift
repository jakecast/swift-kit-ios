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
        callback: ((notification: String)->(Void))
    ) {
        let center: CFNotificationCenterRef
        let notificationName: String
        center = self
        notificationName = notification.stringValue

        let callbackBlock: @objc_block (CFNotificationCenter!, UnsafeMutablePointer<Void>, CFString!, UnsafePointer<Void>, CFDictionary!) -> Void
        let callbackImplementation: COpaquePointer
        let callbackObserver: CFNotificationCallback
        callbackBlock = { _, _, _, _, _ in callback(notification: notificationName) }
        callbackImplementation = imp_implementationWithBlock(unsafeBitCast(callbackBlock, AnyObject.self))
        callbackObserver = unsafeBitCast(callbackImplementation, CFNotificationCallback.self)

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
