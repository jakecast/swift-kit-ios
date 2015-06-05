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

    private var storeChangedNotification: DarwinNotificationCenterObserver?
    private var storeChangedNotificationName: String?

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
        self.setupNotifications()
    }

    public func resetDataStore() {
        self.storeContext.resetContext()
        self.mainContext.resetContext()
        self.privateContext.resetContext()
    }

    public func savePersistentStore() {
        if self.storeContext.hasChanges {
            self.storeContext.performBlockAndWait {
                self.storeContext.saveContext()
            }

            if self.appContext.isExtension {
                self.storeWillChange()
            }
        }
    }
    
    public func startDarwinObserving() {
        if let storeChangedNotificationName = self.storeChangedNotificationName {
            self.storeChangedNotification = DarwinNotificationCenterObserver(
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

    private func setupNotifications() {
        NotificationManager.add(
            observer: self.privateContext,
            notification: NSManagedObjectContextWillSaveNotification,
            object: self.privateContext,
            function: NSManagedObjectContext.obtainPermanentIdentifiers
        )
        NotificationManager.add(
            observer: self.mainContext,
            notification: NSManagedObjectContextDidSaveNotification,
            object: self.privateContext,
            function: NSManagedObjectContext.mergeSaveChanges
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
