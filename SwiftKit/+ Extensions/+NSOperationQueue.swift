import UIKit

public extension NSOperationQueue {
    private struct Class {
        static let backgroundQueue = NSOperationQueue(
            underlyingQueue: dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
        )
    }

    class var mainInstance: NSOperationQueue {
        return self.mainQueue()
    }

    class var currentInstance: NSOperationQueue? {
        return self.currentQueue()
    }

    class var backgroundInstance: NSOperationQueue {
        return Class.backgroundQueue
    }

    class var isMainQueue: Bool {
        return (self.mainQueue() == self.currentQueue())
    }
    
    class func dispatchMain(dispatchBlock: dispatch_block_t) {
        self.mainInstance.addOperationWithBlock(dispatchBlock)
    }
    
    class func dispatchBackground(dispatchBlock: dispatch_block_t) {
        self.backgroundInstance.addOperationWithBlock(dispatchBlock)
    }

    class func once(token: UnsafeMutablePointer<dispatch_once_t>, _ dispatchBlock: dispatch_block_t) {
        dispatch_once(token, dispatchBlock)
    }

    class func synced(lockObj: AnyObject, _ dispatchBlock: dispatch_block_t) {
        objc_sync_enter(lockObj)
        dispatchBlock()
        objc_sync_exit(lockObj)
    }

    class func dispatch(#queueInfo: (queue: NSOperationQueue, sync: Bool), dispatchBlock: dispatch_block_t) {
        if queueInfo.sync == true {
            queueInfo.queue.sync(dispatchBlock)
        }
        else {
            queueInfo.queue.async(dispatchBlock)
        }
    }

    class func dispatchQueueCreate(#serial: Bool, label: String?=nil) -> dispatch_queue_t {
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
        self.underlyingQueue = NSOperationQueue.dispatchQueueCreate(serial: serial, label: label)
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
