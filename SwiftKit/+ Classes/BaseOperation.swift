import Foundation

public class BaseOperation: NSOperation {
    private var executingOperation: Bool = false
    public var operationPriority: Int = 0
    public var startHandler: ((Void)->(Void))?=nil
    public var completionHandler: ((Void)->(Void))?=nil

    public override var asynchronous: Bool {
        return true
    }

    public override var concurrent: Bool {
        return self.asynchronous
    }

    public override var executing: Bool {
        get {
            return self.executingOperation
        }
        set(newValue) {
            self.synced {
                if newValue != self.executing {
                    if newValue == true { self.beginOperation() }
                    
                    self.willChangeValueForKey("isExecuting")
                    self.willChangeValueForKey("isFinished")
                    self.executingOperation = newValue
                    self.didChangeValueForKey("isExecuting")
                    self.didChangeValueForKey("isFinished")
                    
                    if newValue == false { self.endOperation() }
                }
            }
        }
    }

    public override var finished: Bool {
        return self.executingOperation == false
    }
    
    public override func start() {
        super.start()
        self.executing = true
    }
    
    public override func cancel() {
        super.cancel()
        self.executing = false
    }
    
    public func set(#startHandler: (Void)->(Void)) -> Self {
        self.startHandler = startHandler
        return self
    }

    public func set(#completionHandler: (Void)->(Void)) -> Self {
        self.completionHandler = completionHandler
        return self
    }
    
    public func set(#priority: Int) -> Self {
        self.operationPriority = priority
        return self
    }
    
    public func operationWillBegin() {}
    public func operationWillEnd() {}
    
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
}
