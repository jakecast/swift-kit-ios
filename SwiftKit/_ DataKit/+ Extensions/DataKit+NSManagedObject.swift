import CoreData

public extension NSManagedObject {
    class var entityQueue: NSOperationQueue {
        return DKDataStore.entityQueue
    }

    class var entityContext: NSManagedObjectContext {
        return DKDataStore.sharedInstance!.entityContext
    }

    var entityQueue: NSOperationQueue {
        return DKDataStore.entityQueue
    }

    var entityContext: NSManagedObjectContext {
        return NSManagedObject.entityContext
    }
}