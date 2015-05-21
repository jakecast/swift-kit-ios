import CoreData

public class DataStore {
    public static var sharedInstance: DataStore?
    
    public let mainContext: NSManagedObjectContext
    public let backgroundContext: NSManagedObjectContext

    private let dataStorePath: String
    private let managedObjectModel: NSManagedObjectModel
    private let persistentStoreCoordinator: NSPersistentStoreCoordinator
    private let rootContext: NSManagedObjectContext

    private var storeChangedNotification: DarwinNotification?
    private var storeChangedNotificationName: String?

    private lazy var notificationObservers = NSMapTable(keyValueOptions: PointerOptions.StrongMemory)

    public required init(
        managedObjectModel: NSManagedObjectModel,
        persistentStoreCoordinator: NSPersistentStoreCoordinator,
        persistentStoreOptions: [NSObject:AnyObject]=NSPersistentStoreCoordinator.defaultStoreOptions,
        containerURL: NSURL,
        storeChangedNotificationName: String?=nil
    ) {
        self.dataStorePath = containerURL.path!
        self.managedObjectModel = managedObjectModel
        self.persistentStoreCoordinator = persistentStoreCoordinator
        self.storeChangedNotificationName = storeChangedNotificationName
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
        self.mainContext = NSManagedObjectContext(
            concurrencyType: NSManagedObjectContextConcurrencyType.PrivateQueueConcurrencyType,
            mergePolicy: NSMergeByPropertyObjectTrumpMergePolicy,
            parentContext: self.rootContext
        )
        self.backgroundContext = NSManagedObjectContext(
            concurrencyType: NSManagedObjectContextConcurrencyType.PrivateQueueConcurrencyType,
            mergePolicy: NSMergeByPropertyObjectTrumpMergePolicy,
            parentContext: self.rootContext
        )
        DataStore.sharedInstance = self

        self.startDarwinObserving()
        self.setupNotifications()
    }

    public func savePersistentStore() {
        self.synced {
            if self.rootContext.hasChanges {
                self.rootContext.saveContext()
                self.storeWillChange()
            }
        }
    }
    
    public func startDarwinObserving() {
        if self.storeChangedNotification == nil {
            if let storeChangedNotificationName = self.storeChangedNotificationName {
                self.storeChangedNotification = DarwinNotification(
                    notification: storeChangedNotificationName,
                    notificationBlock: methodPointer(self, DataStore.storeDidChange)
                )
            }
        }
    }
    
    public func stopDarwinObserving() {
        self.storeChangedNotification = nil
    }
    
    public func synced(_ queue: NSOperationQueue?=nil, dispatchBlock: ((Void)->(Void))) {
        if let syncQueue = queue {
            syncQueue.dispatch {
                NSOperationQueue.synced(self, dispatchBlock)
            }
        }
        else {
            NSOperationQueue.synced(self, dispatchBlock)
        }
    }

    public func watchNotification(
        #name: StringRepresentable,
        object: AnyObject?=nil,
        queue: NSOperationQueue?=nil,
        block: (NSNotification!)->(Void)
    ) {
        self.notificationObservers[name.stringValue] = NotificationObserver(
            notification: name.stringValue,
            object: object,
            queue: queue,
            block: block
        )
    }
    
    internal func resetContexts() {
        NSOperationQueue.synced(self) {
            self.rootContext.resetContext()
            self.mainContext.resetContext()
            self.backgroundContext.resetContext()
        }
    }
    
    private func setupNotifications() {
        self.watchNotification(
            name: NSManagedObjectContextWillSaveNotification,
            object: self.backgroundContext,
            block: methodPointer(self.backgroundContext, NSManagedObjectContext.obtainPermanentIdentifiers)
        )
        self.watchNotification(
            name: NSManagedObjectContextDidSaveNotification,
            object: self.backgroundContext,
            block: methodPointer(self.mainContext, NSManagedObjectContext.mergeSaveChanges)
        )
    }
    
    private func storeWillChange() {
        self.storeChangedNotification?.postNotification()
    }
    
    private func storeDidChange() {
        self.resetContexts()
    }
}
