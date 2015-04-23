import CoreData

public extension NSManagedObject {
    static var entityContext: NSManagedObjectContext {
        return DataStore.sharedInstance!.entityContext
    }

    var entityContext: NSManagedObjectContext {
        return NSManagedObject.entityContext
    }
}
