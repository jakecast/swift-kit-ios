import Foundation

public class BatchOperation: BaseOperation {
    private let operations = NSHashTable(options: NSHashTableObjectPointerPersonality)
    private var asyncOperations: Bool

    var operationsNotEmpty: Bool {
        var operationsNotEmpty: Bool?
        self.synced {
            operationsNotEmpty = (self.operations.allObjects.isEmpty == false)
        }
        return operationsNotEmpty ?? false
    }

    public required init(asyncOperations: Bool=true) {
        self.asyncOperations = asyncOperations
    }

    public override func start() {
        self.set(executing: true)
        self.startAllOperations()
            .startNextOperation()
            .updateExecutingStatus()
    }

    public override func cancel() {
        super.cancel()

        self.operations.allObjects.each { ($0 as? NSOperation)?.cancel() }
        self.synced {
            self.operations.removeAllObjects()
        }
    }

    public func add(#operation: NSOperation?) -> Self {
        if let op = operation {
            self.synced {
                self.operations.addObject(op)
            }
        }
        return self
    }

    public func add(#operations: [NSOperation]) -> Self {
        self.synced {
            operations.each { self.operations.addObject($0) }
        }
        return self
    }

    public func set(#asyncOperations: Bool) -> Self {
        self.asyncOperations = asyncOperations
        return self
    }

    public func set(#operations: [NSOperation]) -> Self {
        self.synced {
            self.operations.removeAllObjects()
            self.add(operations: operations)
        }
        return self
    }
    
    private func removeOperation(#operation: NSOperation) -> Self {
        self.synced {
            self.operations.removeObject(operation)
        }
        return self
    }

    private func updateExecutingStatus() {
        if self.executing == true {
            self.set(executing: self.operationsNotEmpty)
        }
    }

    private func startAllOperations() -> Self {
        if self.asyncOperations == true {
            self.operations.allObjects.each { self.startOperation(operation: ($0 as? NSOperation)) }
        }
        return self
    }

    private func startNextOperation() -> Self {
        if self.asyncOperations == false {
            self.startOperation(operation: self.operations.allObjects.first as? NSOperation)
        }
        return self
    }

    private func startOperation(#operation: NSOperation?) {
        if let op = operation {
            if self.cancelled == false && op.cancelled == false {
                if let operationCompletionBlock = op.completionBlock {
                    op.completionBlock = { self.operationDidComplete(op, operationCompletionHandler: operationCompletionBlock) }
                }
                else {
                    op.completionBlock = { self.operationDidComplete(op) }
                }
                op.start()
            }
        }
    }

    private func operationDidComplete(operation: NSOperation, operationCompletionHandler: ((Void)->(Void))?=nil) {
        operationCompletionHandler?()
        operation.completionBlock = nil

        self.removeOperation(operation: operation)
            .startNextOperation()
            .updateExecutingStatus()
    }
}
