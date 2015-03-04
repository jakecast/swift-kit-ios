import CoreData

public class DKDataStore {
    public var managedObjectModel: NSManagedObjectModel
    public var persistentStoreCoordinator: NSPersistentStoreCoordinator
    public var rootContext: NSManagedObjectContext
    public var mainContext: NSManagedObjectContext
    public var backgroundContext: NSManagedObjectContext

    public var hasChanges: Bool {
        return (self.rootContext.hasChanges || self.mainContext.hasChanges || self.backgroundContext.hasChanges)
    }
    
    struct Class {
        static var sharedInstance: DKDataStore? = nil
    }
    
    public class var sharedInstance: DKDataStore? {
        return Class.sharedInstance
    }
    
    public class var mainContext: NSManagedObjectContext {
        return Class.sharedInstance!.mainContext
    }
    
    public class var backgroundContext: NSManagedObjectContext {
        return Class.sharedInstance!.backgroundContext
    }
    
    public class func onBackgroundContext(backgroundContextBlock: (context: NSManagedObjectContext) -> (DataSave)) {
        NSOperationQueue.dispatchBackground({
            self.backgroundContext.performBlock(backgroundContextBlock)
        })
    }

    public required init(
        managedObjectModel: NSManagedObjectModel,
        persistentStoreCoordinator: NSPersistentStoreCoordinator,
        storeURL: NSURL
    ) {
        self.managedObjectModel = managedObjectModel
        self.persistentStoreCoordinator = persistentStoreCoordinator
        self.persistentStoreCoordinator.addPersistentStoreWithType(
            NSSQLiteStoreType,
            configuration: nil,
            URL: storeURL,
            options: nil,
            error: nil
        )
        self.rootContext = NSManagedObjectContext(
            concurrencyType: NSManagedObjectContextConcurrencyType.PrivateQueueConcurrencyType,
            persistentStoreCoordinator: self.persistentStoreCoordinator
        )
        self.mainContext = NSManagedObjectContext(
            concurrencyType: NSManagedObjectContextConcurrencyType.MainQueueConcurrencyType,
            parentContext: self.rootContext
        )
        self.backgroundContext = NSManagedObjectContext(
            concurrencyType: NSManagedObjectContextConcurrencyType.PrivateQueueConcurrencyType,
            parentContext: self.mainContext
        )
        
        Class.sharedInstance = self
    }
    
    public func resetCache() {
        NSFetchedResultsController.deleteCacheWithName(nil)
    }
    
    public func resetStore() {
        self.rootContext.reset()
        self.mainContext.reset()
        self.backgroundContext.reset()
    }

    public func saveStore() {
        self.mainContext.savePersistentStore()
    }
}