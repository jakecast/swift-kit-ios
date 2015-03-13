import CoreData

public class DataStore {
    var resultsContextObserver: NotificationObserver?

    public let managedObjectModel: NSManagedObjectModel
    public let persistentStoreCoordinator: NSPersistentStoreCoordinator

    public let resultsContext: NSManagedObjectContext
    public let entityContext: NSManagedObjectContext
    
    struct Class {
        static let entityQueue = NSOperationQueue(serial: false, label: "com.data-kit.entity-queue")
        static var sharedInstance: DataStore?
    }
    
    public required init(
        managedObjectModel: NSManagedObjectModel,
        persistentStoreCoordinator: NSPersistentStoreCoordinator,
        storeURL: NSURL
    ) {
        self.managedObjectModel = managedObjectModel
        self.persistentStoreCoordinator = persistentStoreCoordinator
        self.persistentStoreCoordinator.setupStore(storeType: NSSQLiteStoreType, storeURL: storeURL)
        self.resultsContext = NSManagedObjectContext(
            concurrencyType: NSManagedObjectContextConcurrencyType.PrivateQueueConcurrencyType,
            mergePolicy: NSMergeByPropertyObjectTrumpMergePolicy,
            persistentStoreCoordinator: self.persistentStoreCoordinator
        )
        self.entityContext = NSManagedObjectContext(
            concurrencyType: NSManagedObjectContextConcurrencyType.PrivateQueueConcurrencyType,
            mergePolicy: NSMergeByPropertyObjectTrumpMergePolicy,
            persistentStoreCoordinator: self.persistentStoreCoordinator
        )
        self.setupNotifications()

        Class.sharedInstance = self
    }
    
    public class var sharedInstance: DataStore? {
        return Class.sharedInstance
    }
    
    public class var entityQueue: NSOperationQueue {
        return Class.entityQueue
    }
    
    public var backgroundQueue: NSOperationQueue {
        return NSObject.backgroundQueue
    }

    public var entityQueue: NSOperationQueue {
        return Class.entityQueue
    }

    public var hasChanges: Bool {
        return (self.resultsContext.hasChanges)
    }

    func setupNotifications() {
        self.resultsContextObserver = NotificationObserver(
            notification: NSManagedObjectContextDidSaveNotification,
            object: self.entityContext,
            block: methodPointer(self.resultsContext, NSManagedObjectContext.mergeChanges)
        )
    }
}
