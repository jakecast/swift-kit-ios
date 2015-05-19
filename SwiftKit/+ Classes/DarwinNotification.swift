import Foundation

public class DarwinNotification {
    let notificationName: String

    var isNotifying: Bool
    var notificationBlock: ((Void)->(Void))? = nil

    var callback: ((Void)->(Void))? = nil
    var callbackBlock: AnyObject? = nil
    var callbackImplementation: COpaquePointer? = nil
    var callbackPointer: CFNotificationCallback? = nil

    public init(notification: String, notificationBlock: ((Void)->(Void))?=nil) {
        self.notificationName = notification
        self.notificationBlock = notificationBlock
        self.isNotifying = false

        if self.notificationBlock != nil {
            self.setupObserving()
        }
    }
    
    deinit {
        self.removeNotification()
    }

    private func setupObserving() {
        self.callback = methodPointer(self, DarwinNotification.receiveNotification)
        
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

    func postNotification() {
        self.isNotifying = true
        CFNotificationCenter
            .darwinNotificationCenter()
            .post(notification: self.notificationName)
    }

    func receiveNotification() {
        if self.isNotifying == false {
            self.notificationBlock?()
        }
        self.isNotifying = false
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
