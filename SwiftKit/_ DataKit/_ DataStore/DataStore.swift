import CoreData

public class DataStore {
    public let managedObjectModel: NSManagedObjectModel
    public let persistentStoreCoordinator: NSPersistentStoreCoordinator
    public let resultsContext: NSManagedObjectContext
    public let entityContext: NSManagedObjectContext
    
    internal let dataStorePath: String
    internal let dataStoreType: DataStoreType
    internal let rootContext: NSManagedObjectContext
    internal let entityContextWillSaveObserver: NotificationObserver
    internal let entityContextDidSaveObserver: NotificationObserver
    
    internal var directoryMonitor: DirectoryMonitor?
    
    internal struct Class {
        static var sharedInstance: DataStore?
        static let entityQueue = NSOperationQueue(serial: false, label: "com.data-kit.entity-queue")
    }
    
    public required init(
        managedObjectModel: NSManagedObjectModel,
        persistentStoreCoordinator: NSPersistentStoreCoordinator,
        containerURL: NSURL,
        storeType: DataStoreType=DataStoreType.None
    ) {
        self.dataStorePath = containerURL.path!
        self.dataStoreType = storeType
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
        self.resultsContext = NSManagedObjectContext(
            concurrencyType: NSManagedObjectContextConcurrencyType.PrivateQueueConcurrencyType,
            mergePolicy: NSMergeByPropertyStoreTrumpMergePolicy,
            parentContext: self.rootContext
        )
        self.entityContext = NSManagedObjectContext(
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
    
    public class var sharedInstance: DataStore? {
        return Class.sharedInstance
    }
    
    public class var entityQueue: NSOperationQueue {
        return Class.entityQueue
    }
    
    public var mainQueue: NSOperationQueue {
        return NSOperationQueue.mainQueue()
    }
    
    public var backgroundQueue: NSOperationQueue {
        return NSOperationQueue.backgroundQueue
    }

    public var entityQueue: NSOperationQueue {
        return Class.entityQueue
    }
    
    internal var storeNotifyFolderURL: NSURL {
        return NSURL(string: self.dataStorePath.stringByAppendingPathComponent("notify"))!
    }
    
    internal var storeNotifyFileURL: NSURL {
        return NSURL(string: self.storeNotifyFolderURL.path!.stringByAppendingPathComponent(self.dataStoreType.notifyFilename))!
    }
    
    internal var fileManager: NSFileManager {
        return NSFileManager.defaultManager()
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
        self.resultsContext.resetContext()
        self.entityContext.resetContext()
    }
}
