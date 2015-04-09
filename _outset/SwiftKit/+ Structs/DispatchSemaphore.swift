import Foundation

public struct DispatchSemaphore {
    public var underlyingSemaphore: dispatch_semaphore_t?
    
    public init(initialValue: Int) {
        self.underlyingSemaphore = dispatch_semaphore_create(initialValue)
    }

    public func wait() {
        if let semaphore = self.underlyingSemaphore {
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)
        }
    }
    
    public func wait(timeout: NSTimeInterval) {
        if let semaphore = self.underlyingSemaphore {
            let result = dispatch_semaphore_wait(
                semaphore,
                dispatch_time(DISPATCH_TIME_NOW, Int64(timeout * NSTimeInterval(NSEC_PER_SEC)))
            )
        }
    }

    public func signal() {
        if let semaphore = self.underlyingSemaphore {
            dispatch_semaphore_signal(semaphore)
        }
    }
}
