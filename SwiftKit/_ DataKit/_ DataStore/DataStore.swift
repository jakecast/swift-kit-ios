import CoreData

public class DataStore {
    public let managedObjectModel: NSManagedObjectModel
    public let persistentStoreCoordinator: NSPersistentStoreCoordinator
    public let resultsContext: NSManagedObjectContext
    public let entityContext: NSManagedObjectContext
    
    internal let appContext: AppContext
    internal let dataStorePath: String
    internal let rootContext: NSManagedObjectContext
    
    internal var directoryMonitor: DirectoryMonitor?
    
    private lazy var notificationObservers = NSMapTable.strongToStrongObjectsMapTable()
    
    private struct Class {
        static let dataStoreFileManager = NSFileManager()
        static let dataStoreQueue = NSOperationQueue(serial: false, label: "com.swiftkit.data-store")
        static var sharedInstance: DataStore?
    }

    public static var sharedInstance: DataStore? {
        return Class.sharedInstance
    }
    
    public var mainQueue: NSOperationQueue {
        return NSOperationQueue.mainQueue()
    }

    internal var dataStoreFileManager: NSFileManager {
        return Class.dataStoreFileManager
    }

    internal var dataStoreQueue: NSOperationQueue {
        return Class.dataStoreQueue
    }

    public required init(
        managedObjectModel: NSManagedObjectModel,
        persistentStoreCoordinator: NSPersistentStoreCoordinator,
        persistentStoreOptions: [NSObject:AnyObject]=NSPersistentStoreCoordinator.defaultStoreOptions,
        containerURL: NSURL,
        appContext: AppContext=AppContext.None
    ) {
        self.appContext = appContext
        self.dataStorePath = containerURL.path!
        self.managedObjectModel = managedObjectModel
        self.persistentStoreCoordinator = persistentStoreCoordinator
        self.persistentStoreCoordinator.setupStore(
            storeType: NSSQLiteStoreType,
            storeURL: NSURL(fileURLWithPath: self.dataStorePath.stringByAppendingPathComponent("datastore.db")),
            storeOptions: persistentStoreOptions
        )
        self.rootContext = NSManagedObjectContext(
            concurrencyType: NSManagedObjectContextConcurrencyType.PrivateQueueConcurrencyType,
            mergePolicy: NSMergeByPropertyObjectTrumpMergePolicy,
            persistentStoreCoordinator: self.persistentStoreCoordinator
        )
        self.entityContext = NSManagedObjectContext(
            concurrencyType: NSManagedObjectContextConcurrencyType.PrivateQueueConcurrencyType,
            mergePolicy: NSMergeByPropertyObjectTrumpMergePolicy,
            parentContext: self.rootContext
        )
        self.resultsContext = NSManagedObjectContext(
            concurrencyType: NSManagedObjectContextConcurrencyType.PrivateQueueConcurrencyType,
            mergePolicy: NSMergeByPropertyObjectTrumpMergePolicy,
            parentContext: self.rootContext
        )
        Class.sharedInstance = self

        self.setupNotifications(persistentStoreOptions: persistentStoreOptions)
        self.setupExtensionMonitor()
    }
    
    public func savePersistentStore() {
        self.synced {
            self.rootContext.saveContext()
            self.sendPersistentStoreSavedNotification()
        }
    }
    
    public func watchNotification(#name: String, object: AnyObject?=nil, queue: NSOperationQueue?=nil, block: (NSNotification!)->(Void)) {
        self.notificationObservers[name] = NotificationObserver(notification: name, object: object, queue: queue, block: block)
    }

    internal func resetContexts() {
        self.synced {
            self.entityContext.resetContext()
            self.resultsContext.resetContext()
        }
    }
    
    internal func synced(dispatchBlock: (Void)->(Void)) {
        objc_sync_enter(self)
        dispatchBlock()
        objc_sync_exit(self)
    }

    private func setupNotifications(#persistentStoreOptions: [NSObject:AnyObject]) {
        self.watchNotification(
            name: NSManagedObjectContextWillSaveNotification,
            object: self.entityContext,
            block: methodPointer(self.entityContext, NSManagedObjectContext.obtainPermanentIdentifiers)
        )
        self.watchNotification(
            name: NSManagedObjectContextDidSaveNotification,
            object: self.entityContext,
            block: methodPointer(self.resultsContext, NSManagedObjectContext.mergeSaveChanges)
        )
    }
}
