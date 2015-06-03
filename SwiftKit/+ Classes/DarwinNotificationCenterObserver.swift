import Foundation

public class DarwinNotificationCenterObserver {
    let notificationName: String

    var callback: ((Void)->(Void))? = nil
    var callbackBlock: AnyObject? = nil
    var callbackImplementation: COpaquePointer? = nil
    var callbackPointer: CFNotificationCallback? = nil

    public init(notificationName: String, notificationBlock: (Void)->(Void)) {
        self.notificationName = notificationName

        self.removeNotification()
        self.setupObserving(notificationBlock: notificationBlock)
    }

    deinit {
        self.removeNotification()
    }

    private func setupObserving(#notificationBlock: (Void)->(Void)) {
        self.callback = notificationBlock

        if let callback = self.callback {
            self.callbackBlock = unsafeBitCast(callback as (Void)->(Void) as @objc_block (Void)->(Void), AnyObject.self)
        }
        if let callbackBlock: AnyObject = self.callbackBlock {
            self.callbackImplementation = imp_implementationWithBlock(callbackBlock)
        }
        if let callbackImplementation: COpaquePointer = self.callbackImplementation {
            self.callbackPointer = CFNotificationCallback(callbackImplementation)
        }
        if let callbackPointer: CFNotificationCallback = self.callbackPointer {
            CFNotificationCenter
                .darwinNotificationCenter()
                .add(observer: self, notification: self.notificationName, callbackBlock: callbackPointer)
        }
    }
    
    func removeNotification() {
        CFNotificationCenter
            .darwinNotificationCenter()
            .remove(observer: self, notification: self.notificationName)
        
        self.callbackPointer = nil
        self.callbackImplementation = nil
        self.callbackBlock = nil
        self.callback = nil
    }
}
