import CoreData

public class DataStore {
    public let resultsContext: NSManagedObjectContext
    public let entityContext: NSManagedObjectContext

    private let dataStorePath: String
    private let managedObjectModel: NSManagedObjectModel
    private let persistentStoreCoordinator: NSPersistentStoreCoordinator
    private let rootContext: NSManagedObjectContext

    private var storeChangedNotification: DarwinNotification?

    private lazy var notificationObservers = NSMapTable.strongToStrongObjectsMapTable()
    
    private struct Class {
        static let storeChangedNotification: String = "StoreChangedNotification"
        static var sharedInstance: DataStore?
    }

    public static var sharedInstance: DataStore? {
        return Class.sharedInstance
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
        NSOperationQueue.synced(self) {
            if self.rootContext.hasChanges {
                self.rootContext.saveContext()
                self.storeWillChange()
            }
        }
    }

    public func watchNotification(#name: String, object: AnyObject?=nil, queue: NSOperationQueue?=nil, block: (NSNotification!)->(Void)) {
        self.notificationObservers[name] = NotificationObserver(notification: name, object: object, queue: queue, block: block)
    }
    
    internal func resetContexts() {
        NSOperationQueue.synced(self) {
            self.rootContext.resetContext()
            self.resultsContext.resetContext()
            self.entityContext.resetContext()
        }
    }
    
    private func storeWillChange() {
        self.storeChangedNotification?.postNotification()
    }
    
    private func storeDidChange() {
        self.resetContexts()
    }

    private func setupNotifications() {
        self.storeChangedNotification = DarwinNotification(
            notification: Class.storeChangedNotification,
            notificationBlock: methodPointer(self, DataStore.storeDidChange)
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
