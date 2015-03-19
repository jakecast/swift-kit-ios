import CoreData

public extension NSBatchUpdateResult {
    func resultCount() -> Int {
        return self.result as? Int ?? 0
    }
    
    func resultIdentifiers() -> Array<NSManagedObjectID> {
        return self.result as? [NSManagedObjectID] ?? []
    }
}