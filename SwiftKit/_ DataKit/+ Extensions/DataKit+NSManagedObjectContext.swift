import CoreData

public extension NSManagedObjectContext {
    convenience init(
        concurrencyType: NSManagedObjectContextConcurrencyType,
        mergePolicy: AnyObject=NSErrorMergePolicy,
        persistentStoreCoordinator: NSPersistentStoreCoordinator
    ) {
        self.init(concurrencyType: concurrencyType)
        self.performBlockAndWait {
            self.mergePolicy = mergePolicy
            self.persistentStoreCoordinator = persistentStoreCoordinator
            self.undoManager = nil
        }
    }

    convenience init(
        concurrencyType: NSManagedObjectContextConcurrencyType,
        mergePolicy: AnyObject=NSErrorMergePolicy,
        parentContext: NSManagedObjectContext
    ) {
        self.init(concurrencyType: concurrencyType)
        self.performBlockAndWait {
            self.mergePolicy = mergePolicy
            self.parentContext = parentContext
            self.undoManager = nil
        }
    }

    func mergeChanges(notification: NSNotification!) {
        if notification.object is NSManagedObjectContext && notification.object as? NSManagedObjectContext != self {
            self.performBlockAndWait {
                self.mergeChangesFromContextDidSaveNotification(notification)
            }
        }
    }
    
    func obtainPermanentIdentifiers() {
        if self.insertedObjects.count != 0 {
            self.debugOperation {(error: NSErrorPointer) -> (Void) in
                self.obtainPermanentIDsForObjects(self.insertedObjects.arrayValue, error: error)
            }
        }
    }

    func resetContext() {
        self.performBlockAndWait {
            self.reset()
        }
    }

    func saveContext(completionHandler: ((Void)->(Void))?=nil) {
        if self.hasChanges == true {
            self.performBlockAndWait {
                self.obtainPermanentIdentifiers()
                self.debugOperation {(error: NSErrorPointer) -> (Void) in
                    self.save(error)
                }
            }
        }
        completionHandler?()
    }

    func savePersistentStore(completionHandler: ((Void)->(Void))?=nil) {
        self.saveContext()

        if let parentContext = self.parentContext {
            parentContext.savePersistentStore(completionHandler: completionHandler)
        }
        else {
            completionHandler?()
        }
    }
}
