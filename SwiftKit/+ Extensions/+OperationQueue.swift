import UIKit


public extension OperationQueue {
    private struct Shared {
        static let backgroundQueue = OperationQueue(
            underlyingQueue: dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
        )
    }

    class var mainInstance: OperationQueue {
        return self.mainQueue()
    }

    class var currentInstance: OperationQueue? {
        return self.currentQueue()
    }

    class var backgroundInstance: OperationQueue {
        return OperationQueue.Shared.backgroundQueue
    }

    class var isMainQueue: Bool {
        return (self.currentInstance != nil && self.currentInstance == self.mainInstance)
    }

    class func once(token: UnsafeMutablePointer<dispatch_once_t>, _ dispatchBlock: dispatch_block_t) {
        dispatch_once(token, dispatchBlock)
    }

    class func synced(lockObj: AnyObject, _ dispatchBlock: dispatch_block_t) {
        objc_sync_enter(lockObj)
        dispatchBlock()
        objc_sync_exit(lockObj)
    }

    class func dispatch(#queueInfo: (queue: OperationQueue, sync: Bool), dispatchBlock: dispatch_block_t) {
        if queueInfo.sync == true {
            queueInfo.queue.sync(dispatchBlock)
        }
        else {
            queueInfo.queue.async(dispatchBlock)
        }
    }

    private class func dispatchQueueCreate(#serial: Bool, label: String?=nil) -> dispatch_queue_t {
        if let dispatchLabel = label {
            return dispatch_queue_create(
                dispatchLabel,
                (serial == true) ? DISPATCH_QUEUE_SERIAL : DISPATCH_QUEUE_CONCURRENT
            )
        }
        else {
            return dispatch_queue_create(
                nil,
                (serial == true) ? DISPATCH_QUEUE_SERIAL : DISPATCH_QUEUE_CONCURRENT
            )
        }
    }

    convenience init(serial: Bool, label: String?=nil) {
        self.init()
        self.name = label
        self.underlyingQueue = OperationQueue.dispatchQueueCreate(serial: serial, label: label)
    }

    convenience init(underlyingQueue: dispatch_queue_t) {
        self.init()
        self.underlyingQueue = underlyingQueue
    }

    func sync(dispatchBlock: dispatch_block_t) {
        dispatch_sync(self.underlyingQueue, dispatchBlock)
    }

    func async(dispatchBlock: dispatch_block_t) {
        dispatch_async(self.underlyingQueue, dispatchBlock)
    }

    func barrierAsync(dispatchBlock: dispatch_block_t) {
        dispatch_barrier_async(self.underlyingQueue, dispatchBlock)
    }

    func delay(delay: NSTimeInterval, _ dispatchBlock: dispatch_block_t) {
        dispatch_after(
            dispatch_time(DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC))),
            self.underlyingQueue,
            dispatchBlock)
    }

    func suspend() {
        dispatch_suspend(self.underlyingQueue)
    }

    func resume() {
        dispatch_resume(self.underlyingQueue)
    }
}
