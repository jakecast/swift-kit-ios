import UIKit

public extension NSObject {
    struct Class {
        static let backgroundQueue = NSOperationQueue(serial: false, label: "com.swift-kit.background-queue")
    }

    var mainQueue: NSOperationQueue {
        return NSOperationQueue.mainQueue()
    }

    var backgroundQueue: NSOperationQueue {
        return Class.backgroundQueue
    }
    
    func debugOperation(operationBlock: (NSErrorPointer) -> (Void)) {
        var errorPointer: NSError?
        operationBlock(&errorPointer)
        
        if errorPointer != nil && UIDevice.isSimulator == true {
            println("an error occured: \(errorPointer?.domain ?? String())")
        }
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
