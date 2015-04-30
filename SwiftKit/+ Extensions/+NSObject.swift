import Foundation

public extension NSObject {
    private struct Extension {
        static let backgroundQueue = NSOperationQueue(serial: false, label: "com.swift-kit.background-queue")
        static var notificationObserversKey = "notificationObservers"
        static var messageObserversKey = "messageObservers"
    }
    
    static var mainQueue: NSOperationQueue {
        return NSOperationQueue.mainQueue()
    }
    
    static var backgroundQueue: NSOperationQueue {
        return Extension.backgroundQueue
    }

    var mainQueue: NSOperationQueue {
        return NSOperationQueue.mainQueue()
    }

    var backgroundQueue: NSOperationQueue {
        return Extension.backgroundQueue
    }
    
    var messageObservers: NSMapTable {
        get {
            if self.getAssociatedObject(key: &Extension.messageObserversKey) is NSMapTable == false {
                self.messageObservers = NSMapTable.strongToStrongObjectsMapTable()
            }
            return self.getAssociatedObject(key: &Extension.messageObserversKey) as! NSMapTable
        }
        set(newValue) {
            self.setAssociatedObject(key: &Extension.messageObserversKey, object: newValue)
        }
    }
    
    var notificationObservers: NSMapTable {
        get {
            if self.getAssociatedObject(key: &Extension.notificationObserversKey) is NSMapTable == false {
                self.notificationObservers = NSMapTable.strongToStrongObjectsMapTable()
            }
            return self.getAssociatedObject(key: &Extension.notificationObserversKey) as! NSMapTable
        }
        set(newValue) {
            self.setAssociatedObject(key: &Extension.notificationObserversKey, object: newValue)
        }
    }
    
    func enterSync() {
        objc_sync_enter(self)
    }
    
    func exitSync() {
        objc_sync_exit(self)
    }

    func getAssociatedObject(#key: UnsafePointer<Void>) -> AnyObject? {
        return objc_getAssociatedObject(self, key)
    }

    func isClass(#classType: AnyClass) -> Bool {
        return self.isMemberOfClass(classType)
    }

    func isKind(#classKind: AnyClass) -> Bool {
        return self.isKindOfClass(classKind)
    }
    
    func setAssociatedObject(#key: UnsafePointer<Void>, object: AnyObject, associationPolicy: AssociationPolicy=AssociationPolicy.RetainNonAtomic) {
        objc_setAssociatedObject(self, key, object, associationPolicy.uintValue)
    }

    func synced(dispatchBlock: (Void)->(Void)) {
        self.enterSync()
        dispatchBlock()
        self.exitSync()
    }
    
    func watchMessage(#name: String, block: (Void)->(Void)) {
        self.messageObservers[name] = MessageObserver(notification: name, block: block)
    }
    
    func watchNotification(#name: String, object: AnyObject?=nil, queue: NSOperationQueue?=nil, block: (NSNotification!)->(Void)) {
        self.notificationObservers[name] = NotificationObserver(notification: name, object: object, queue: queue, block: block)
    }
}
