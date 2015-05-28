import Foundation

public extension NSOperationQueue {
    public static func backgroundQueue() -> NSOperationQueue {
        return Queue.backgroundOperationQueue
    }

    public static func defaultQueue() -> NSOperationQueue {
        return Queue.defaultOperationQueue
    }

    public static func utilityQueue() -> NSOperationQueue {
        return Queue.utilityOperationQueue
    }

    public static func synced(lockObj: AnyObject, _ dispatchBlock: ((Void)->(Void))) {
        objc_sync_enter(lockObj)
        dispatchBlock()
        objc_sync_exit(lockObj)
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

    public convenience init(dispatchQueue: dispatch_queue_t) {
        self.init()
        self.underlyingQueue = dispatchQueue
    }
    
    public func addBlock(wait: Bool=false, _ block: ((Void)->(Void))) {
        if wait == true {
            self.addOperations([NSBlockOperation(block: block)], waitUntilFinished: true)
        }
        else {
            self.addOperationWithBlock(block)
        }
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
