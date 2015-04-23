import CoreData

public extension NSObject {
    static var resultsContext: NSManagedObjectContext {
        return DataStore.sharedInstance!.resultsContext
    }

    var resultsContext: NSManagedObjectContext {
        return DataStore.sharedInstance!.resultsContext
    }
}
