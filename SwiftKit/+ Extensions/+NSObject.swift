import UIKit

public extension NSObject {
    private struct Class {
        static let backgroundQueue = NSOperationQueue(serial: false, label: "com.swift-kit.background-queue")
    }
    
    class var mainQueue: NSOperationQueue {
        return NSOperationQueue.mainQueue()
    }
    
    class var backgroundQueue: NSOperationQueue {
        return Class.backgroundQueue
    }

    var mainQueue: NSOperationQueue {
        return NSOperationQueue.mainQueue()
    }

    var backgroundQueue: NSOperationQueue {
        return Class.backgroundQueue
    }

    class func debugOperation(operationBlock: (NSErrorPointer) -> (Void)) {
        var errorPointer: NSError?
        operationBlock(&errorPointer)

        if errorPointer != nil && UIDevice.isSimulator == true {
            if let domain = errorPointer?.domain, let code = errorPointer?.code {
                println("an error occured: \(domain) with code: \(code)")
            }
        }
    }

    func debugOperation(operationBlock: (NSErrorPointer) -> (Void)) {
        NSObject.debugOperation(operationBlock)
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
