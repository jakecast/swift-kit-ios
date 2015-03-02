import CoreData

public class DKDataStore {
    struct Class {
        static var sharedInstance: DKDataStore? = nil
    }

    public class var sharedInstance: DKDataStore? {
        return Class.sharedInstance
    }
    
    public class var mainQueueContext: NSManagedObjectContext {
        return Class.sharedInstance!.mainQueueContext
    }
    
    public class var privateQueueContext: NSManagedObjectContext {
        return Class.sharedInstance!.privateQueueContext
    }
    
    public class var eventCenter: EventCenter {
        return Class.sharedInstance!.eventCenter
    }
    
    public class func newBackgroundContext() -> NSManagedObjectContext {
        let backgroundContext = NSManagedObjectContext(
            concurrencyType: NSManagedObjectContextConcurrencyType.PrivateQueueConcurrencyType,
            persistentStoreCoordinator: self.sharedInstance!.persistentStoreCoordinator
        )
        self.eventCenter.watchNotification(
            name: NSManagedObjectContextDidSaveNotification,
            object: backgroundContext,
            block: methodPointer(self.mainQueueContext, NSManagedObjectContext.mergeChangesFromNotification)
        )
        self.eventCenter.watchNotification(
            name: NSManagedObjectContextDidSaveNotification,
            object: backgroundContext,
            block: methodPointer(self.privateQueueContext, NSManagedObjectContext.mergeChangesFromNotification)
        )
        return backgroundContext
    }
    
    public var managedObjectModel: NSManagedObjectModel
    public var persistentStoreCoordinator: NSPersistentStoreCoordinator
    public var mainQueueContext: NSManagedObjectContext
    public var privateQueueContext: NSManagedObjectContext
    
    lazy var eventCenter = EventCenter()

    public var hasChanges: Bool {
        return (self.mainQueueContext.hasChanges || self.privateQueueContext.hasChanges)
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
        self.mainQueueContext = NSManagedObjectContext(
            concurrencyType: NSManagedObjectContextConcurrencyType.MainQueueConcurrencyType,
            persistentStoreCoordinator: self.persistentStoreCoordinator
        )
        self.privateQueueContext = NSManagedObjectContext(
            concurrencyType: NSManagedObjectContextConcurrencyType.PrivateQueueConcurrencyType,
            persistentStoreCoordinator: self.persistentStoreCoordinator
        )
        self.setupNotifications()
        
        Class.sharedInstance = self
    }
    
    public func resetCache() {
        NSFetchedResultsController.deleteCacheWithName(nil)
    }
    
    public func resetStore() {
        self.privateQueueContext.reset()
        self.mainQueueContext.reset()
    }

    public func saveStore() {
        self.privateQueueContext.savePersistentStore()
        self.mainQueueContext.savePersistentStore()
    }

    func setupNotifications() {
        self.eventCenter.watchNotification(
            name: NSManagedObjectContextDidSaveNotification,
            object: self.privateQueueContext,
            block: methodPointer(self.mainQueueContext, NSManagedObjectContext.mergeChangesFromNotification)
        )
        self.eventCenter.watchNotification(
            name: NSManagedObjectContextDidSaveNotification,
            object: self.mainQueueContext,
            block: methodPointer(self.privateQueueContext, NSManagedObjectContext.mergeChangesFromNotification)
        )
    }
}