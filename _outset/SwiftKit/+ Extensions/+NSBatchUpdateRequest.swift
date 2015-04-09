import CoreData

public extension NSBatchUpdateRequest {
    func performRequest(#context: NSManagedObjectContext) -> NSBatchUpdateResult {
        var fetchResults: NSBatchUpdateResult?
        NSError.performOperation {(error: NSErrorPointer) -> (Void) in
            fetchResults = context.persistentStoreContext.executeRequest(self, error: error) as? NSBatchUpdateResult
        }
        return fetchResults ?? NSBatchUpdateResult()
    }
    
    func set(#includesSubentities: Bool) -> Self {
        self.includesSubentities = includesSubentities
        return self
    }
    
    func set(#predicate: NSPredicate) -> Self {
        self.predicate = predicate
        return self
    }
    
    func set(#propertiesToUpdate: [NSObject:AnyObject]) -> Self {
        self.propertiesToUpdate = propertiesToUpdate
        return self
    }
    
    func set(#resultType: NSBatchUpdateRequestResultType) -> Self {
        self.resultType = resultType
        return self
    }
}
