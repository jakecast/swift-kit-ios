import Foundation

public extension NSObject {
    private struct Extension {
        static let backgroundQueue = NSOperationQueue(serial: false, label: "com.swift-kit.background-queue")
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

    func isClass(#classType: AnyClass!) -> Bool {
        return self.isMemberOfClass(classType)
    }

    func isKind(#classKind: AnyClass!) -> Bool {
        return self.isKindOfClass(classKind)
    }

    func synced(dispatchBlock: (Void) -> (Void)) {
        objc_sync_enter(self)
        dispatchBlock()
        objc_sync_exit(self)
    }
}
