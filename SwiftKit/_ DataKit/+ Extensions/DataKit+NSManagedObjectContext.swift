import CoreData
import UIKit

public extension NSManagedObjectContext {
    convenience init(
        concurrencyType: NSManagedObjectContextConcurrencyType,
        persistentStoreCoordinator: NSPersistentStoreCoordinator
    ) {
        self.init(concurrencyType: concurrencyType)
        self.performBlockAndWait({[unowned self] in
            self.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            self.persistentStoreCoordinator = persistentStoreCoordinator
            self.undoManager = nil
        })
    }

    convenience init(
        concurrencyType: NSManagedObjectContextConcurrencyType,
        parentContext: NSManagedObjectContext
    ) {
        self.init(concurrencyType: concurrencyType)
        self.performBlockAndWait({[unowned self] in
            self.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            self.parentContext = parentContext
            self.undoManager = nil
        })
    }
    
    func mergeChangesFromNotification(notification: NSNotification!) {
        NSOperationQueue.synced(self.persistentStoreCoordinator!) {
            self.performBlock({[unowned self] in
                self.mergeChangesFromContextDidSaveNotification(notification)
            })
        }
    }
    
    func obtainPermanentIdentifiers() {
        if self.insertedObjects.count != 0 {
            self.debugOperation({(error: NSErrorPointer) -> (Void) in
                self.obtainPermanentIDsForObjects(self.insertedObjects.arrayValue, error: error)
            })
        }
    }
    
    func performBlock(contextBlock: (context: NSManagedObjectContext) -> (DataSave)) {
        let saveAction = contextBlock(context: self)
        switch saveAction {
        case .NoSave:
            break
        case .SaveContext:
            self.saveContext()
        case .SaveToPersistentStore:
            self.savePersistentStore()
        }
    }

    func saveContext(completion: ((Void)->(Void))?=nil) {
        if self.hasChanges == true {
            self.performBlockAndWait({[unowned self] in
                self.obtainPermanentIdentifiers()
                self.debugOperation({(error: NSErrorPointer) -> (Void) in
                    self.save(error)
                })
            })
        }
        if let completionBlock = completion {
            completionBlock()
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
}
