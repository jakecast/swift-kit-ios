import Foundation

public class BatchOperation: BaseOperation {
    private let operations = NSHashTable(options: NSHashTableObjectPointerPersonality)
    private var asyncOperations: Bool = true

    private var isExecutingBatchOperation: Bool {
        return (self.operations.isEmpty == false)
    }
    
    private var operationsArray: [BaseOperation] {
        return self.operations.allObjects
            .map { return $0 as? BaseOperation }
            .filter { return $0 != nil }
            .map { return $0! }
            .sorted { return $0.operationPriority < $1.operationPriority }
    }
    
    public override func start() {
        super.start()
        
        self.startAllOperations()
            .startNextOperation()
            .updateExecutingStatus()
    }

    public override func cancel() {
        super.cancel()

        self.operations.each { ($0 as? BaseOperation)?.cancel() }
        self.operations.removeAll()
    }

    public func add(#operation: BaseOperation?) -> Self {
        if let op = operation {
            self.operations.add(object: op)
        }
        return self
    }

    public func add(#operations: [BaseOperation]) -> Self {
        self.operations.add(objects: operations)
        return self
    }

    public func set(#asyncOperations: Bool) -> Self {
        self.asyncOperations = asyncOperations
        return self
    }

    public func set(#operations: [BaseOperation]) -> Self {
        self.operations.removeAllObjects()
        self.operations.add(objects: operations)
        return self
    }
    
    private func removeOperation(#operation: BaseOperation) -> Self {
        self.operations.remove(object: operation)
        return self
    }

    private func updateExecutingStatus() {
        self.set(executing: self.isExecutingBatchOperation)
    }

    private func startAllOperations() -> Self {
        if self.asyncOperations == true {
            self.operationsArray.each { self.startOperation(operation: $0) }
        }
        return self
    }

    private func startNextOperation() -> Self {
        if self.asyncOperations == false {
            self.startOperation(operation: self.operationsArray.first)
        }
        return self
    }

    private func startOperation(#operation: BaseOperation?) {
        if let op = operation {
            if self.cancelled == false && op.cancelled == false {
                if let opCompletionHandler = op.completionHandler {
                    op.set(completionHandler: { self.operationDidComplete(op, opCompletionHandler) })
                }
                else {
                    op.set(completionHandler: { self.operationDidComplete(op) })
                }
                op.start()
            }
        }
    }

    private func operationDidComplete(operation: BaseOperation, _ operationCompletionHandler: ((Void)->(Void))?=nil) {
        operationCompletionHandler?()

        self.removeOperation(operation: operation)
            .startNextOperation()
            .updateExecutingStatus()
    }
}
