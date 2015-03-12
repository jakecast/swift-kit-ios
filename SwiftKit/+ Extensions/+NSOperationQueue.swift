import UIKit

public extension NSOperationQueue {
    convenience init(serial: Bool, label: String?=nil) {
        self.init()
        self.name = label
        self.underlyingQueue = dispatch_queue_create(
            label ?? nil,
            (serial == true) ? DISPATCH_QUEUE_SERIAL : DISPATCH_QUEUE_CONCURRENT
        )
    }

    class var isMainQueue: Bool {
        return (self.mainQueue() == self.currentQueue())
    }

    class func dispatchOnce(token: UnsafeMutablePointer<dispatch_once_t>, _ dispatchBlock: (Void) -> (Void)) {
        dispatch_once(token, dispatchBlock)
    }

    class func synced(lockObj: AnyObject, _ dispatchBlock: (Void) -> (Void)) {
        objc_sync_enter(lockObj)
        dispatchBlock()
        objc_sync_exit(lockObj)
    }
    
    func dispatch(dispatchBlock: (Void) -> (Void)) {
        self.addOperationWithBlock(dispatchBlock)
    }

    func dispatchSync(dispatchBlock: (Void) -> (Void)) {
        dispatch_sync(self.underlyingQueue, dispatchBlock)
    }

    func dispatchAsync(dispatchBlock: (Void) -> (Void)) {
        dispatch_async(self.underlyingQueue, dispatchBlock)
    }

    func dispatchBarrierAsync(dispatchBlock: (Void) -> (Void)) {
        dispatch_barrier_async(self.underlyingQueue, dispatchBlock)
    }

    func dispatchAfterDelay(delay: NSTimeInterval, _ dispatchBlock: (Void) -> (Void)) {
        dispatch_after(
            dispatch_time(DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC))),
            self.underlyingQueue,
            dispatchBlock
        )
    }

    func suspendQueue() {
        dispatch_suspend(self.underlyingQueue)
    }

    func resumeQueue() {
        dispatch_resume(self.underlyingQueue)
    }
}
