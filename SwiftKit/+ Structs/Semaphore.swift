import Foundation

public struct Semaphore {
    public var rawObject: dispatch_semaphore_t?
    
    public init(initialValue: Int) {
        self.rawObject = dispatch_semaphore_create(initialValue)
    }

    public mutating func set(#rawObject: dispatch_semaphore_t?) {
        self.rawObject = rawObject
    }

    public func wait() {
        if let semaphore = self.rawObject {
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)
        }
    }
    
    public func wait(timeout: NSTimeInterval) {
        if let semaphore = self.rawObject {
            let result = dispatch_semaphore_wait(
                semaphore,
                dispatch_time(DISPATCH_TIME_NOW, Int64(timeout * NSTimeInterval(NSEC_PER_SEC)))
            )
        }
    }

    public func signal() {
        if let semaphore = self.rawObject {
            dispatch_semaphore_signal(semaphore)
        }
    }
}
