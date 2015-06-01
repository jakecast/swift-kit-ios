import Foundation

public class BaseOperation: NSOperation {
    public var startHandler: ((Void)->(Void))? = nil
    public var completionHandler: ((Void)->(Void))? = nil

    public override var asynchronous: Bool {
        return true
    }

    public override var concurrent: Bool {
        return self.asynchronous
    }

    public override var ready: Bool {
        return self.state == OperationState.Ready
    }

    public override var executing: Bool {
        return self.state == OperationState.Executing
    }

    public override var finished: Bool {
        return self.state == OperationState.Finished
    }

    private var state: OperationState = OperationState.Ready {
        willSet {
            self.willChangeValueForKey(newValue.keyPath)
            self.willChangeValueForKey(state.keyPath)
        }
        didSet {
            self.didChangeValueForKey(oldValue.keyPath)
            self.didChangeValueForKey(state.keyPath)
        }
    }

    public override func start() {
        self.setup()
        
        if self.cancelled == true {
            self.startHandler = nil
            self.completionHandler = nil
            self.state = OperationState.Executing
            self.state = OperationState.Finished
        }
        else {
            if self.state == OperationState.Ready {
                self.startOperation()
            }
            
            if self.cancelled == false {
                self.main()
            }
            
            if self.state == OperationState.Finished {
                self.finishOperation()
            }
        }
    }

    public func set(#completionHandler: ((Void)->(Void))) -> Self {
        self.completionHandler = completionHandler
        return self
    }

    public func set(#startHandler: ((Void)->(Void))) -> Self {
        self.startHandler = startHandler
        return self
    }

    public func startOperation() {
        if let startHandler = self.startHandler {
            self.startHandler = nil

            if self.cancelled == false {
                startHandler()
            }
        }

        self.state = OperationState.Executing
    }

    public func finishOperation() {
        if let completionHandler = self.completionHandler {
            self.completionHandler = nil

            if self.cancelled == false {
                completionHandler()
            }
        }
        
        self.state = OperationState.Finished
    }
    
    public func setup() {}
}
