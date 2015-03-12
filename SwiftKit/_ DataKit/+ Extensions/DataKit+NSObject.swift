import CoreData

public extension NSObject {
    class var resultsContext: NSManagedObjectContext {
        return DKDataStore.sharedInstance!.resultsContext
    }

    var resultsContext: NSManagedObjectContext {
        return NSObject.resultsContext
    }
}