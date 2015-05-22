import Foundation

public class BaseOperation: NSOperation {
    public override var asynchronous: Bool {
        return true
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
        if self.cancelled == false {
            self.startOperation()
            self.main()
        }
        else {
            self.finishOperation()
        }
    }

    public func startOperation() {
        self.state = OperationState.Executing
    }

    public func finishOperation() {
        self.state = OperationState.Finished
    }
}
