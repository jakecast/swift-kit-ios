import CoreData
import UIKit

public extension ManagedObjectContext {
    private struct Shared {
        static var mainContext: ManagedObjectContext? = nil
        static var backgroundContext: ManagedObjectContext? = nil
    }

    class var mainInstance: ManagedObjectContext {
        return self.mainContext()
    }

    class var backgroundInstance: ManagedObjectContext {
        return self.backgroundContext()
    }

    class var currentInstance: ManagedObjectContext {
        return self.currentContext()
    }

    class func mainContext() -> ManagedObjectContext {
        return ManagedObjectContext.Shared.mainContext!
    }

    class func backgroundContext() -> ManagedObjectContext {
        if ManagedObjectContext.Shared.backgroundContext == nil {
            ManagedObjectContext.Shared.backgroundContext = NSManagedObjectContext(
                concurrencyType: ManagedObjectContextConcurrencyType.PrivateQueueConcurrencyType,
                parentContext: self.mainInstance)
        }

        return ManagedObjectContext.Shared.backgroundContext!
    }

    class func currentContext() -> ManagedObjectContext {
        return (OperationQueue.isMainQueue == true) ? self.mainInstance : self.backgroundInstance
    }

    convenience init(
        concurrencyType: ManagedObjectContextConcurrencyType,
        persistentStoreCoordinator: PersistentStoreCoordinator
    ) {
        self.init(concurrencyType: concurrencyType)
        self.performBlockAndWait({
            self.persistentStoreCoordinator = persistentStoreCoordinator
            self.undoManager = nil
        })
        self.becomeMainContext()
    }

    convenience init(
        concurrencyType: ManagedObjectContextConcurrencyType,
        parentContext: ManagedObjectContext
    ) {
        self.init(concurrencyType: concurrencyType)
        self.performBlockAndWait({
            self.parentContext = parentContext
            self.undoManager = nil
        })
    }

    func obtainPermanentIdentifiers() {
        if self.insertedObjects.count != 0 {
            self.obtainPermanentIDsForObjects(self.insertedObjects.allObjects, error: nil)
        }
    }

    func saveContext() {
        if self.hasChanges == true {
            self.performBlockAndWait({
                self.processPendingChanges()
                self.obtainPermanentIdentifiers()
                self.save(nil)
            })
        }
    }

    func savePersistentStore(completion: ((Void) -> (Void))?=nil) {
        self.saveContext()

        if let parentContext = self.parentContext {
            parentContext.savePersistentStore(completion: completion)
        }
        else if let completionBlock = completion {
            completionBlock()
        }
    }

    private func becomeMainContext() {
        ManagedObjectContext.Shared.mainContext = self
    }
}