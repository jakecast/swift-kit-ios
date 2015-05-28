import CoreData
import UIKit

public class DataStore {
    public static var sharedInstance: DataStore?
    
    public let mainContext: NSManagedObjectContext
    public let privateContext: NSManagedObjectContext

    private let appContext: AppContext
    private let dataStorePath: String
    private let managedObjectModel: NSManagedObjectModel
    private let persistentStoreCoordinator: NSPersistentStoreCoordinator
    private let storeContext: NSManagedObjectContext

    private var storeChangedNotification: DarwinNotification?
    private var storeChangedNotificationName: String?

    private lazy var notificationObservers = NSMapTable(keyValueOptions: PointerOptions.StrongMemory)

    public required init(
        appContext: AppContext,
        managedObjectModel: NSManagedObjectModel,
        persistentStoreCoordinator: NSPersistentStoreCoordinator,
        persistentStoreOptions: [NSObject:AnyObject]=NSPersistentStoreCoordinator.defaultStoreOptions,
        containerURL: NSURL,
        storeChangedNotificationName: String?=nil
    ) {
        self.appContext = appContext
        self.dataStorePath = containerURL.path!
        self.managedObjectModel = managedObjectModel
        self.persistentStoreCoordinator = persistentStoreCoordinator
        self.storeChangedNotificationName = storeChangedNotificationName
        self.persistentStoreCoordinator.setupStore(
            storeType: NSSQLiteStoreType,
            storeURL: NSURL(fileURLWithPath: self.dataStorePath.stringByAppendingPathComponent("datastore.db")),
            storeOptions: persistentStoreOptions
        )
        self.storeContext = NSManagedObjectContext(
            concurrencyType: NSManagedObjectContextConcurrencyType.PrivateQueueConcurrencyType,
            mergePolicy: NSMergeByPropertyObjectTrumpMergePolicy,
            persistentStoreCoordinator: self.persistentStoreCoordinator
        )
        self.mainContext = NSManagedObjectContext(
            concurrencyType: NSManagedObjectContextConcurrencyType.PrivateQueueConcurrencyType,
            mergePolicy: NSMergeByPropertyObjectTrumpMergePolicy,
            parentContext: self.storeContext
        )
        self.privateContext = NSManagedObjectContext(
            concurrencyType: NSManagedObjectContextConcurrencyType.PrivateQueueConcurrencyType,
            mergePolicy: NSMergeByPropertyObjectTrumpMergePolicy,
            parentContext: self.storeContext
        )
        DataStore.sharedInstance = self

        if self.appContext.isMainApp {
            self.startDarwinObserving()
        }
        if self.appContext.isExtension {
            self.resetDataStore()
        }
        self.setupNotifications()
    }

    public func resetDataStore() {
        self.storeContext.resetContext()
        self.mainContext.resetContext()
        self.privateContext.resetContext()
    }

    public func savePersistentStore() {
        if self.storeContext.hasChanges {
            self.storeContext.saveContext()
            if self.appContext.isExtension {
                self.storeWillChange()
            }
        }
    }
    
    public func startDarwinObserving() {
        if let storeChangedNotificationName = self.storeChangedNotificationName {
            self.storeChangedNotification = DarwinNotification(
                notificationName: storeChangedNotificationName,
                notificationBlock: methodPointer(self, DataStore.storeDidChange)
            )
        }
    }

    public func stopDarwinObserving() {
        if self.storeChangedNotification != nil {
            self.storeChangedNotification = nil
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
    
    private func setupNotifications() {
        self.watchNotification(
            name: NSManagedObjectContextWillSaveNotification,
            object: self.privateContext,
            block: methodPointer(self.privateContext, NSManagedObjectContext.obtainPermanentIdentifiers)
        )
        self.watchNotification(
            name: NSManagedObjectContextDidSaveNotification,
            object: self.privateContext,
            block: methodPointer(self.mainContext, NSManagedObjectContext.mergeSaveChanges)
        )
    }

    private func storeWillChange() {
        if let storeChangedNotificationName = self.storeChangedNotificationName {
            CFNotificationCenter
                .darwinNotificationCenter()
                .post(notification: storeChangedNotificationName)
        }
    }

    private func storeDidChange() {
        self.resetDataStore()
    }
}
