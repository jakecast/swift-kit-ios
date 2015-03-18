import CoreData

public extension NSPersistentStoreRequest {
    func performRequest(#context: NSManagedObjectContext) -> NSPersistentStoreResult {
        var fetchResults: NSPersistentStoreResult?
        self.debugOperation {(error: NSErrorPointer) -> (Void) in
            fetchResults = context.executeRequest(self, error: error)
        }
        return fetchResults ?? NSPersistentStoreResult()
    }
}