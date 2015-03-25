import Foundation

public class BatchOperation: BaseOperation {
    private var asyncOperations: Bool
    private var operations: [NSOperation]

    public required init(asyncOperations: Bool=true, operations: [NSOperation]) {
        self.asyncOperations = asyncOperations
        self.operations = operations
    }

    public override func start() {
        self.updateExecutingStatus()
            .startAllOperations()
            .startNextOperation()
    }

    public override func cancel() {
        super.cancel()

        for operation in self.operations {
            operation.cancel()
        }
        self.operations.removeAll(keepCapacity: false)
    }

    public func set(#asyncOperations: Bool) -> Self {
        self.asyncOperations = asyncOperations
        return self
    }

    public func set(#operations: [NSOperation]) -> Self {
        self.operations = operations
        return self
    }

    private func updateExecutingStatus() -> Self {
        self.synced {
            self.set(executing: self.operations.isEmpty == false)
        }
        return self
    }

    private func startAllOperations() -> Self {
        if self.asyncOperations == true {
            for operation in self.operations {
                self.startOperation(operation: operation)
            }
        }
        return self
    }

    private func startNextOperation() -> Self {
        if self.asyncOperations == false {
            if let operation = self.operations.first {
                self.startOperation(operation: operation)
            }
        }
        return self
    }

    private func startOperation(#operation: NSOperation) {
        if self.cancelled == false && operation.cancelled == false {
            if let operationCompletionBlock = operation.completionBlock {
                operation.completionBlock = { self.operationDidComplete(operation, operationCompletionHandler: operationCompletionBlock) }
            }
            else {
                operation.completionBlock = { self.operationDidComplete(operation) }
            }
            operation.start()
        }
    }

    private func operationDidComplete(operation: NSOperation, operationCompletionHandler: ((Void)->(Void))?=nil) {
        operationCompletionHandler?()
        self.operations.removeItem(operation)

        self.startNextOperation()
            .updateExecutingStatus()
    }
}
