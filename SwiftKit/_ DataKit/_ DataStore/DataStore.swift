import CoreData

public class DataStore {
    public let persistentStoreCoordinator: NSPersistentStoreCoordinator
    public let managedObjectModel: NSManagedObjectModel
    public let rootContext: NSManagedObjectContext
    public let resultsContext: NSManagedObjectContext
    public let entityContext: NSManagedObjectContext
    public let dataStorePath: String
    
    private lazy var messageLock = NSLock()
    private lazy var messageObservers = NSMapTable.strongToStrongObjectsMapTable()
    private lazy var notificationObservers = NSMapTable.strongToStrongObjectsMapTable()
    
    private struct Class {
        static var sharedInstance: DataStore?
    }

    public static var sharedInstance: DataStore? {
        return Class.sharedInstance
    }
    
    public var mainQueue: NSOperationQueue {
        return NSOperationQueue.mainQueue()
    }

    public required init(
        managedObjectModel: NSManagedObjectModel,
        persistentStoreCoordinator: NSPersistentStoreCoordinator,
        persistentStoreOptions: [NSObject:AnyObject]=NSPersistentStoreCoordinator.defaultStoreOptions,
        containerURL: NSURL
    ) {
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

        self.setupNotifications()
    }
    
    public func savePersistentStore() {
        self.synced {
            if self.rootContext.hasChanges {
                self.rootContext.saveContext()
                self.sendStoresChangedNotification()
            }
        }
    }
    
    public func watchMessage(#name: String, block: (Void)->(Void)) {
        self.messageObservers[name] = MessageObserver(notification: name, block: block)
    }
    
    public func watchNotification(#name: String, object: AnyObject?=nil, queue: NSOperationQueue?=nil, block: (NSNotification!)->(Void)) {
        self.notificationObservers[name] = NotificationObserver(notification: name, object: object, queue: queue, block: block)
    }
    
    internal func resetContexts() {
        self.synced {
            self.rootContext.resetContext()
            self.resultsContext.resetContext()
            self.entityContext.resetContext()
        }
    }
    
    internal func sendStoresChangedNotification() {
        self.messageLock.tryLock()
        CFNotificationCenter
            .darwinNotificationCenter()
            .post(notification: NSPersistentStoreCoordinatorStoresDidChangeNotification)
    }
    
    internal func storesDidChange() {
        if self.messageLock.isLocked == false {
            self.resetContexts()
        }
        self.messageLock.tryUnlock()
    }
    
    internal func synced(dispatchBlock: (Void)->(Void)) {
        objc_sync_enter(self)
        dispatchBlock()
        objc_sync_exit(self)
    }

    private func setupNotifications() {
        self.watchMessage(
            name: NSPersistentStoreCoordinatorStoresDidChangeNotification,
            block: methodPointer(self, DataStore.storesDidChange)
        )
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
