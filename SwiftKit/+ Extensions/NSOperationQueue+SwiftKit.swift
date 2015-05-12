import UIKit

public extension NSOperationQueue {
    public static var isMainQueue: Bool {
        return (self.mainQueue() == self.currentQueue())
    }
    
    public static var currentUnderlyingQueue: dispatch_queue_t? {
        return self.currentQueue()?.underlyingQueue
    }
    
    public static func dispatchOnce(token: UnsafeMutablePointer<dispatch_once_t>, _ dispatchBlock: (Void)->(Void)) {
        dispatch_once(token, dispatchBlock)
    }
    
    public static func synced(lockObj: AnyObject, _ dispatchBlock: (Void)->(Void)) {
        objc_sync_enter(lockObj)
        dispatchBlock()
        objc_sync_exit(lockObj)
    }
}

public extension NSOperationQueue {
    public var isActiveQueue: Bool {
        return (self == NSOperationQueue.currentQueue())
    }
    
    public var isMainQueue: Bool {
        return (self == NSOperationQueue.mainQueue())
    }
    
    public convenience init(serial: Bool, label: String?=nil) {
        self.init()
        self.name = label
        self.underlyingQueue = dispatch_queue_create(label ?? nil, serial ? DISPATCH_QUEUE_SERIAL : DISPATCH_QUEUE_CONCURRENT)
    }
    
    public func add(#operations: [NSOperation], wait: Bool=false) {
        self.addOperations(operations, waitUntilFinished: wait)
    }

    public func add(#operation: NSOperation, wait: Bool=false) {
        self.add(operations: [operation, ], wait: wait)
    }

    public func add(#block: ((Void)->(Void)), wait: Bool=false) {
        self.add(operation: NSBlockOperation(block: block), wait: wait)
    }

    public func dispatch(dispatchBlock: (Void)->(Void)) {
        self.addOperationWithBlock(dispatchBlock)
    }

    public func dispatchAfterDelay(delay: NSTimeInterval, _ dispatchBlock: (Void)->(Void)) {
        dispatch_after(
            dispatch_time(DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC))),
            self.underlyingQueue,
            dispatchBlock
        )
    }

    public func dispatchAsync(dispatchBlock: (Void)->(Void)) {
        dispatch_async(self.underlyingQueue, dispatchBlock)
    }

    public func dispatchBarrierAsync(dispatchBlock: (Void)->(Void)) {
        dispatch_barrier_async(self.underlyingQueue, dispatchBlock)
    }

    public func dispatchProtected(dispatchBlock: (Void)->(Void)) {
        if self.isActiveQueue == true {
            dispatchBlock()
        }
        else {
            self.addOperationWithBlock(dispatchBlock)
        }
    }

    public func dispatchSync(dispatchBlock: (Void)->(Void)) {
        if self.isActiveQueue == true {
            dispatchBlock()
        }
        else {
            dispatch_sync(self.underlyingQueue, dispatchBlock)
        }
    }

    public func suspendQueue() {
        dispatch_suspend(self.underlyingQueue)
    }

    public func resumeQueue() {
        dispatch_resume(self.underlyingQueue)
    }
}
