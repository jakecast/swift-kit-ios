import Foundation

public class BaseOperation: NSOperation {
    public var asynchronousOperation: Bool = false
    public var completionHandler: ((Void)->(Void))? = nil
    public var startHandler: ((Void)->(Void))? = nil
    public weak var parentQueue: NSOperationQueue? = nil

    private var cancelledOperation: Bool = false
    private var executingOperation: Bool = false
    private var finishedOperation: Bool = false

    public override var asynchronous: Bool {
        return self.asynchronousOperation
    }

    public override var concurrent: Bool {
        return self.asynchronousOperation
    }

    public override var executing: Bool {
        return self.executingOperation
    }

    public override var finished: Bool {
        return self.finishedOperation
    }

    public override var cancelled: Bool {
        return self.cancelledOperation
    }
    
    public override init() {
        super.init()
    }
    
    public override func start() {
        self.set(executing: true)
    }
    
    public override func cancel() {
        self.set(cancelled: true)
            .set(executing: false)
    }

    public func set(#asynchronousOperation: Bool) {
        self.asynchronousOperation = asynchronousOperation
    }

    public func set(#startHandler: ((Void)->(Void))) -> Self {
        self.startHandler = startHandler
        return self
    }

    public func set(#completionHandler: ((Void)->(Void))) -> Self {
        self.completionHandler = completionHandler
        return self
    }

    public func set(#cancelled: Bool) -> Self {
        if cancelled != self.cancelled {
            self.startHandler = nil
            self.completionHandler = nil
            
            self.willChangeValueForKey("isCancelled")
            self.cancelledOperation = cancelled
            self.didChangeValueForKey("isCancelled")
        }
        return self
    }
    
    public func set(#executing: Bool) -> Self {
        if executing != self.executing {
            if executing == true {
                self.beginOperation()
            }
            if executing == false {
                self.endOperation()
            }
            
            self.willChangeValueForKey("isExecuting")
            self.willChangeValueForKey("isFinished")
            self.executingOperation = executing
            self.finishedOperation = (executing == false)
            self.didChangeValueForKey("isExecuting")
            self.didChangeValueForKey("isFinished")
        }
        return self
    }

    public func set(#parentQueue: NSOperationQueue?) -> Self {
        self.parentQueue = parentQueue
        return self
    }

    private func beginOperation() {
        self.operationWillBegin()
        self.startHandler?()
        self.startHandler = nil
    }
    
    private func endOperation() {
        self.operationWillEnd()
        self.completionHandler?()
        self.completionHandler = nil
    }

    public func operationWillBegin() {}
    public func operationWillEnd() {}
}
