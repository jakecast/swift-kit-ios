import Foundation

public class MessageObserver {
    let callback: @objc_block (Void)->(Void)
    let callbackBlock: AnyObject
    let callbackImplementation: COpaquePointer
    let callbackPointer: CFNotificationCallback

    let notificationName: String
    
    public init(notification: String, block: (Void)->(Void)) {
        self.callback = block
        self.callbackBlock = unsafeBitCast(self.callback, AnyObject.self)
        self.callbackImplementation = imp_implementationWithBlock(self.callbackBlock)
        self.callbackPointer = CFunctionPointer<((CFNotificationCenter!, UnsafeMutablePointer<Void>, CFString!, UnsafePointer<Void>, CFDictionary!) -> Void)>(self.callbackImplementation)

        self.notificationName = notification
        
        CFNotificationCenter
            .darwinNotificationCenter()
            .add(observer: self, notification: self.notificationName, callbackBlock: self.callbackPointer)
    }
    
    deinit {
        CFNotificationCenter
            .darwinNotificationCenter()
            .remove(observer: self, notification: self.notificationName)
    }
}
