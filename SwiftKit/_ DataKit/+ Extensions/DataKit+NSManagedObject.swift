import CoreData

public extension NSManagedObject {
    class var entityContext: NSManagedObjectContext {
        return DataStore.sharedInstance!.entityContext
    }

    var entityContext: NSManagedObjectContext {
        return NSManagedObject.entityContext
    }
}
