import Foundation

public class DarwinNotification {
    let notificationName: String

    var isNotifying: Bool
    var notificationBlock: ((Void)->(Void))?

    public init(notification: String, notificationBlock: ((Void)->(Void))?=nil) {
        self.notificationName = notification
        self.notificationBlock = notificationBlock
        self.isNotifying = false

        if self.notificationBlock != nil {
            self.setupObserving()
        }
    }
    
    deinit {
        CFNotificationCenter
            .darwinNotificationCenter()
            .remove(observer: self, notification: self.notificationName)
    }

    private func setupObserving() {
        let callback: @objc_block (Void)->(Void) = methodPointer(self, DarwinNotification.receiveNotification)
        let callbackBlock: AnyObject = unsafeBitCast(callback, AnyObject.self)
        let callbackImplementation: COpaquePointer = imp_implementationWithBlock(callbackBlock)
        let callbackPointer: CFNotificationCallback = CFNotificationCallback(callbackImplementation)

        CFNotificationCenter
            .darwinNotificationCenter()
            .add(observer: self, notification: self.notificationName, callbackBlock: callbackPointer)
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
}
