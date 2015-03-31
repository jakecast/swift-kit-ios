import CoreData

public extension NSObject {
    class var resultsContext: NSManagedObjectContext {
        return DataStore.sharedInstance!.resultsContext
    }

    var resultsContext: NSManagedObjectContext {
        return DataStore.sharedInstance!.resultsContext
    }
}
