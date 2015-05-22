import Foundation

public extension NSOperationQueue {
    public static var isMainQueue: Bool {
        return (self.mainQueue() == self.currentQueue())
    }
    
    public static var currentUnderlyingQueue: dispatch_queue_t? {
        return self.currentQueue()?.underlyingQueue
    }
    
    public static func dispatchOnce(token: UnsafeMutablePointer<dispatch_once_t>, _ dispatchBlock: ((Void)->(Void))) {
        dispatch_once(token, dispatchBlock)
    }
    
    public static func synced(lockObj: AnyObject, _ dispatchBlock: ((Void)->(Void))) {
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

    public convenience init(
        name: String,
        maxConcurrentOperations: Int=NSOperationQueueDefaultMaxConcurrentOperationCount,
        qualityOfService: NSQualityOfService=NSQualityOfService.Default
    ) {
        self.init()
        self.name = name
        self.maxConcurrentOperationCount = maxConcurrentOperations
        self.qualityOfService = qualityOfService
    }

    public func add(#operation: NSOperation, waitUntilDone: Bool=false) {
        self.addOperations([operation, ], waitUntilFinished: waitUntilDone)
    }

    public func add(#operations: [NSOperation], operation: NSOperation?=nil, waitUntilDone: Bool=false) {
        var queueOperations: [NSOperation] = []
        if let singleOperation = operation {
            queueOperations.append(singleOperation)
            queueOperations = queueOperations + operations
        }
        else {
            queueOperations = queueOperations + operations
        }
        self.addOperations(queueOperations, waitUntilFinished: waitUntilDone)
    }

    public func cancelOperations() -> Self {
        self.cancelAllOperations()
        return self
    }

    public func dispatch(dispatchBlock: ((Void)->(Void))) {
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

    public func dispatchSync(dispatchBlock: (Void)->(Void)) {
        if self.isActiveQueue == true {
            dispatchBlock()
        }
        else {
            dispatch_sync(self.underlyingQueue, dispatchBlock)
        }
    }

    public func dispatchLock(lock: AnyObject, dispatchBlock: ((Void)->(Void))) {
        self.dispatch { NSOperationQueue.synced(lock, dispatchBlock) }
    }

    public func resume() -> Self {
        self.suspended = false
        return self
    }

    public func set(#maxConcurrentOperationCount: Int) -> Self {
        self.maxConcurrentOperationCount = maxConcurrentOperationCount
        return self
    }

    public func set(#name: String) -> Self {
        self.name = name
        return self
    }

    public func set(#qualityOfService: NSQualityOfService) -> Self {
        self.qualityOfService = qualityOfService
        return self
    }

    public func suspend() -> Self {
        self.suspended = true
        return self
    }
}
