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

    public class var sharedInstance: DataStore? {
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
        self.watchNotification(
            name: NSManagedObjectContextWillSaveNotification,
            object: self.entityContext,
            block: methodPointer(self.entityContext, NSManagedObjectContext.obtainPermanentIdentifiers)
        )
        self.watchNotification(
            name: NSManagedObjectContextDidSaveNotification,
            object: self.entityContext,
            block: methodPointer(self.resultsContext, NSManagedObjectContext.mergeChanges)
        )
        Class.sharedInstance = self

        self.setupStoreMonitor()
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

    public func synced(dispatchBlock: (Void)->(Void)) {
        objc_sync_enter(self)
        dispatchBlock()
        objc_sync_exit(self)
    }
    
    public func watchNotification(#name: String, object: AnyObject?=nil, queue: NSOperationQueue?=nil, block: (NSNotification!)->(Void)) {
        self.notificationObservers[name] = NotificationObserver(notification: name, object: object, queue: queue, block: block)
    }

    internal func resetContexts() {
        self.rootContext.resetContext()
        self.entityContext.resetContext()
        self.resultsContext.resetContext()
    }
}
