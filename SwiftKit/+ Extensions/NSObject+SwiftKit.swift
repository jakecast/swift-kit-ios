import Foundation

public extension NSObject {
    public static var mainOperationQueue: NSOperationQueue {
        return NSOperationQueue.mainQueue()
    }
    
    public static var mainQueue: Queue {
        return Queue.Main
    }

    public var mainOperationQueue: NSOperationQueue {
        return NSOperationQueue.mainQueue()
    }

    public var mainQueue: Queue {
        return Queue.Main
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
}
