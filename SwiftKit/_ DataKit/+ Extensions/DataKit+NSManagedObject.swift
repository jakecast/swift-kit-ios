import CoreData

public extension NSManagedObject {
    class var entityQueue: NSOperationQueue {
        return DataStore.entityQueue
    }

    class var entityContext: NSManagedObjectContext {
        return DataStore.sharedInstance!.entityContext
    }

    var entityQueue: NSOperationQueue {
        return DataStore.entityQueue
    }

    var entityContext: NSManagedObjectContext {
        return NSManagedObject.entityContext
    }
}