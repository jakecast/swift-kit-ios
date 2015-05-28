import Foundation

public enum Queue {
    case Main
    case UserInteractive
    case UserInitiated
    case Default
    case Utility
    case Background
    case Custom(dispatch_queue_t)

    public static var backgroundOperationQueue = Queue.Background.operationQueue
    public static var defaultOperationQueue = Queue.Default.operationQueue
    public static var utilityOperationQueue = Queue.Utility.operationQueue

    public static func once(token: UnsafeMutablePointer<dispatch_once_t>, _ dispatchBlock: (Void)->(Void)) {
        dispatch_once(token, dispatchBlock)
    }
    
    public var dispatchQueue: dispatch_queue_t {
        let dispatchQueue: dispatch_queue_t
        switch self {
        case .Main:
            dispatchQueue = dispatch_get_main_queue()
        case .UserInteractive:
            dispatchQueue = dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0)
        case .UserInitiated:
            dispatchQueue = dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)
        case .Default:
            dispatchQueue = dispatch_get_global_queue(QOS_CLASS_DEFAULT, 0)
        case .Utility:
            dispatchQueue = dispatch_get_global_queue(QOS_CLASS_UTILITY, 0)
        case .Background:
            dispatchQueue = dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)
        case .Custom(let rawObject):
            dispatchQueue = rawObject
        }
        return dispatchQueue
    }

    private var operationQueue: NSOperationQueue {
        return NSOperationQueue(dispatchQueue: self.dispatchQueue)
    }
    
    public func afterDelay(delay: NSTimeInterval, _ dispatchBlock: (Void)->(Void)) {
        dispatch_after(
            dispatch_time(DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC))),
            self.dispatchQueue,
            dispatchBlock
        )
    }
    
    public func async(dispatchBlock: (Void)->(Void)) {
        dispatch_async(self.dispatchQueue, dispatchBlock)
    }
    
    public func barrierAsync(dispatchBlock: (Void)->(Void)) {
        dispatch_barrier_async(self.dispatchQueue, dispatchBlock)
    }
    
    public func resume() {
        dispatch_resume(self.dispatchQueue)
    }
    
    public func suspend() {
        dispatch_suspend(self.dispatchQueue)
    }
    
    public func sync(dispatchBlock: (Void)->(Void)) {
        dispatch_sync(self.dispatchQueue, dispatchBlock)
    }
}
