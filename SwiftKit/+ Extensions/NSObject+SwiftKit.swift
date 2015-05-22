import Foundation

public extension NSObject {
    private struct Extension {
        static var notificationObserversKey = "notificationObservers"
        static var messageObserversKey = "messageObservers"
    }
    
    public static var mainQueue: Queue {
        return Queue.Main
    }

    public var mainQueue: Queue {
        return Queue.Main
    }
    
    public var messageObservers: NSMapTable {
        get {
            if self.getAssociatedObject(key: &Extension.messageObserversKey) is NSMapTable == false {
                self.messageObservers = NSMapTable(keyValueOptions: PointerOptions.StrongMemory)
            }
            return self.getAssociatedObject(key: &Extension.messageObserversKey) as! NSMapTable
        }
        set(newValue) {
            self.setAssociatedObject(key: &Extension.messageObserversKey, object: newValue)
        }
    }
    
    public var notificationObservers: NSMapTable {
        get {
            if self.getAssociatedObject(key: &Extension.notificationObserversKey) is NSMapTable == false {
                self.notificationObservers = NSMapTable(keyValueOptions: PointerOptions.StrongMemory)
            }
            return self.getAssociatedObject(key: &Extension.notificationObserversKey) as! NSMapTable
        }
        set(newValue) {
            self.setAssociatedObject(key: &Extension.notificationObserversKey, object: newValue)
        }
    }

    public func getAssociatedObject(#key: UnsafePointer<Void>) -> AnyObject? {
        return objc_getAssociatedObject(self, key)
    }

    public func setAssociatedObject(
        #key: UnsafePointer<Void>,
        object: AnyObject,
        associationPolicy: AssociationPolicy=AssociationPolicy.RetainNonAtomic
    ) {
        objc_setAssociatedObject(self, key, object, associationPolicy.uintValue)
    }

    public func isClass(#classType: AnyClass) -> Bool {
        return self.isMemberOfClass(classType)
    }

    public func isKind(#classKind: AnyClass) -> Bool {
        return self.isKindOfClass(classKind)
    }

    public func synced(dispatchBlock: ((Void)->(Void))) {
        NSOperationQueue.synced(self, dispatchBlock)
    }
    
    public func watchNotification(
        #name: StringRepresentable,
        object: AnyObject?=nil,
        queue: NSOperationQueue?=nil,
        block: (NSNotification!)->(Void)
    ) {
        self.notificationObservers[name.stringValue] = NotificationObserver(
            notification: name.stringValue,
            object: object,
            queue: queue,
            block: block
        )
    }
}
