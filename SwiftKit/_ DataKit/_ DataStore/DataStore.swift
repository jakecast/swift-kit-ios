import CoreData

public class DataStore {
    public let managedObjectModel: NSManagedObjectModel
    public let persistentStoreCoordinator: NSPersistentStoreCoordinator
    public let resultsContext: NSManagedObjectContext
    public let entityContext: NSManagedObjectContext
    
    internal let appContext: AppContext
    internal let dataStorePath: String
    internal let rootContext: NSManagedObjectContext
    internal let entityContextWillSaveObserver: NotificationObserver
    internal let entityContextDidSaveObserver: NotificationObserver
    
    internal var directoryMonitor: DirectoryMonitor?
    
    internal struct Class {
        static let dataStoreFileManager = NSFileManager()
        static let dataStoreQueue = NSOperationQueue(serial: false, label: "com.swiftkit.data-store")
        static var sharedInstance: DataStore?
    }

    public class var sharedInstance: DataStore? {
        return Class.sharedInstance
    }
    
    public required init(
        managedObjectModel: NSManagedObjectModel,
        persistentStoreCoordinator: NSPersistentStoreCoordinator,
        containerURL: NSURL,
        appContext: AppContext=AppContext.None
    ) {
        self.appContext = appContext
        self.dataStorePath = containerURL.path!
        self.managedObjectModel = managedObjectModel
        self.persistentStoreCoordinator = persistentStoreCoordinator
        self.persistentStoreCoordinator.setupStore(
            storeType: NSSQLiteStoreType,
            storeURL: NSURL(fileURLWithPath: self.dataStorePath.stringByAppendingPathComponent("datastore.db"))!,
            storeOptions: NSPersistentStoreCoordinator.defaultStoreOptions
        )
        self.rootContext = NSManagedObjectContext(
            concurrencyType: NSManagedObjectContextConcurrencyType.PrivateQueueConcurrencyType,
            mergePolicy: NSMergeByPropertyStoreTrumpMergePolicy,
            persistentStoreCoordinator: self.persistentStoreCoordinator
        )
        self.entityContext = NSManagedObjectContext(
            concurrencyType: NSManagedObjectContextConcurrencyType.PrivateQueueConcurrencyType,
            mergePolicy: NSMergeByPropertyStoreTrumpMergePolicy,
            parentContext: self.rootContext
        )
        self.resultsContext = NSManagedObjectContext(
            concurrencyType: NSManagedObjectContextConcurrencyType.PrivateQueueConcurrencyType,
            mergePolicy: NSMergeByPropertyStoreTrumpMergePolicy,
            parentContext: self.rootContext
        )
        self.entityContextWillSaveObserver = NotificationObserver(
            notification: NSManagedObjectContextWillSaveNotification,
            object: self.entityContext,
            block: methodPointer(self.entityContext, NSManagedObjectContext.obtainPermanentIdentifiers)
        )
        self.entityContextDidSaveObserver = NotificationObserver(
            notification: NSManagedObjectContextDidSaveNotification,
            object: self.entityContext,
            block: methodPointer(self.resultsContext, NSManagedObjectContext.mergeChanges)
        )
        Class.sharedInstance = self

        self.setupStoreMonitor()
    }
    
    public var mainQueue: NSOperationQueue {
        return NSOperationQueue.mainQueue()
    }
    
    public func refreshObjects(#objectIdentifiers: [NSManagedObjectID]) {
        self.rootContext
            .refreshObjects(objectIdentifiers: objectIdentifiers, mergeChanges: false)
            .processPendingChanges()
        self.entityContext
            .refreshObjects(objectIdentifiers: objectIdentifiers, mergeChanges: false)
            .processPendingChanges()
        self.resultsContext
            .refreshObjects(objectIdentifiers: objectIdentifiers, mergeChanges: false)
            .processPendingChanges()
    }

    public func savePersistentStore(completionHandler: ((hasChanges: Bool)->(Void))?=nil) {
        let hasChanges: Bool = self.rootContext.hasChanges
        if hasChanges == true {
            self.rootContext.saveContext()
            self.sendPersistentStoreSavedNotification()
        }
        if let completion = completionHandler {
            completionHandler?(hasChanges: hasChanges)
        }
    }

    internal func resetContexts() {
        self.rootContext.resetContext()
        self.entityContext.resetContext()
        self.resultsContext.resetContext()
    }
}
