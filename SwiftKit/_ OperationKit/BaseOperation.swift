import Foundation

public class BaseOperation: NSOperation {
    private var executingOperation: Bool = false

    public override var asynchronous: Bool {
        return true
    }

    public override var concurrent: Bool {
        return self.asynchronous
    }

    public override var executing: Bool {
        return self.executingOperation
    }

    public override var finished: Bool {
        return self.executingOperation == false
    }

    public override func cancel() {
        super.cancel()
        self.set(executing: false)
    }
    
    public func startOperation() -> Self {
        self.start()
        return self
    }

    public func set(#completionHandler: (Void)->(Void)) -> Self {
        self.completionBlock = completionHandler
        return self
    }

    public func set(#executing: Bool) {
        self.synced {
            if executing != self.executingOperation {
                self.willChangeValueForKey("isExecuting")
                self.willChangeValueForKey("isFinished")
                self.executingOperation = executing
                self.didChangeValueForKey("isExecuting")
                self.didChangeValueForKey("isFinished")
            }
        }
    }
}
