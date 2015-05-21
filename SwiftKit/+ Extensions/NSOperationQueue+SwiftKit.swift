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
        serial: Bool=false,
        qualityOfService: NSQualityOfService=NSQualityOfService.Default
    ) {
        self.init()
        self.maxConcurrentOperationCount = serial == true ? 1 : NSOperationQueueDefaultMaxConcurrentOperationCount
        self.name = name
        self.qualityOfService = qualityOfService
        self.underlyingQueue = dispatch_underlying_queue_create(name, serial, qualityOfService)
    }

    public func add(#operations: [NSOperation], waitUntilDone: Bool=false) {
        self.addOperations(operations, waitUntilFinished: waitUntilDone)
    }

    public func add(#operation: NSOperation, waitUntilDone: Bool=false) {
        self.addOperations([operation, ], waitUntilFinished: waitUntilDone)
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

    public func dispatchLock(inout lock: Bool, dispatchBlock: ((Void)->(Void))) {
        self.dispatch {
            if lock == false {
                lock = true
                dispatchBlock()
                lock = false
            }
        }
    }

    public func resume() -> Self {
        dispatch_resume(self.underlyingQueue)
        return self
    }

    public func set(#maxConcurrentOperationCount: Int) -> Self {
        self.maxConcurrentOperationCount = maxConcurrentOperationCount
        return self
    }

    public func set(#qualityOfService: NSQualityOfService) -> Self {
        self.qualityOfService = qualityOfService
        return self
    }

    public func set(#suspended: Bool) -> Self {
        if suspended == true {
            self.suspend()
        }
        if suspended == false {
            self.resume()
        }
        return self
    }

    public func suspend() -> Self {
        dispatch_suspend(self.underlyingQueue)
        return self
    }
}
