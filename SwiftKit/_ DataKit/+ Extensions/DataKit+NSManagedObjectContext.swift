import CoreData
import UIKit

public extension NSManagedObjectContext {
    convenience init(
        concurrencyType: NSManagedObjectContextConcurrencyType,
        persistentStoreCoordinator: NSPersistentStoreCoordinator
    ) {
        self.init(concurrencyType: concurrencyType)
        self.performBlockAndWait({
            self.persistentStoreCoordinator = persistentStoreCoordinator
            self.undoManager = nil
        })
    }

    convenience init(
        concurrencyType: NSManagedObjectContextConcurrencyType,
        parentContext: NSManagedObjectContext
    ) {
        self.init(concurrencyType: concurrencyType)
        self.performBlockAndWait({
            self.persistentStoreCoordinator = parentContext.persistentStoreCoordinator!
            self.undoManager = nil
        })
    }

    func obtainPermanentIdentifiers() {
        if self.insertedObjects.count != 0 {
            self.obtainPermanentIDsForObjects(self.insertedObjects.arrayValue, error: nil)
        }
    }

    func saveContext() {
        if self.hasChanges == true {
            self.performBlockAndWait({
                self.obtainPermanentIdentifiers()
                self.debugOperation({(error: NSErrorPointer) -> (Void) in
                    self.save(error)
                })
            })
        }
    }

    func savePersistentStore(completion: ((Void)->(Void))?=nil) {
        self.saveContext()

        if let parentContext = self.parentContext {
            parentContext.savePersistentStore(completion: completion)
        }
        else if let completionBlock = completion {
            completionBlock()
        }
    }
    
    func mergeChangesFromNotification(notification: NSNotification!) {
        NSOperationQueue.synced(self.persistentStoreCoordinator!) {
            self.performBlock {
                self.mergeChangesFromContextDidSaveNotification(notification)
            }
        }
    }
}
