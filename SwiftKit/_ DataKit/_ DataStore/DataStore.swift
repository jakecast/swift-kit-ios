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

            self.storeWillChange()
        }
    }

    private func setupNotifications() {
        NotificationManager
            .sharedManager()
            .add(
                observer: self.privateContext,
                notification: NSManagedObjectContextWillSaveNotification,
                object: self.privateContext,
                function: NSManagedObjectContext.obtainPermanentIdentifiers
            )
        NotificationManager
            .sharedManager()
            .add(
                observer: self.mainContext,
                notification: NSManagedObjectContextDidSaveNotification,
                object: self.privateContext,
                function: NSManagedObjectContext.mergeSaveChanges
            )
        if let storeChangedNotificationName = self.storeChangedNotificationName {
            NotificationManager
                .sharedManager()
                .set(groupIdentifier: AppContext.appGroupIdentifier)
                .add(observer: self, notification: storeChangedNotificationName, isDarwinNotification: true, function: DataStore.storeDidChange)
        }
    }

    private func storeWillChange() {
        if let storeChangedNotificationName = self.storeChangedNotificationName {
            NotificationManager
                .sharedManager()
                .set(groupIdentifier: AppContext.appGroupIdentifier)
                .post(notificationName: storeChangedNotificationName, isDarwinNotification: true, userInfo: ["appcontext": self.appContext.rawValue, ])
        }
    }

    private func storeDidChange(notification: NSNotification!) {
        if let appContextRaw = notification["appcontext"] as? String {
            if AppContext(rawValue: appContextRaw) != self.appContext {
                self.resetDataStore()
            }
        }
    }
}
