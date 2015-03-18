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
    
    func getManagedObject(#objectID: NSManagedObjectID) -> NSManagedObject? {
        var managedObject: NSManagedObject?
        self.debugOperation {(error) -> (Void) in
            self.existingObjectWithID(objectID, error: error)
        }
        return managedObject
    }

    func obtainPermanentIdentifiers(notification: NSNotification!) {
        if let context = notification.object as? NSManagedObjectContext {
            if context.insertedObjects.count != 0 {
                context.debugOperation {(error: NSErrorPointer) -> (Void) in
                    context.obtainPermanentIDsForObjects(context.insertedObjects.arrayValue, error: error)
                }
            }
        }
    }

    func mergeChanges(notification: NSNotification!) {
        if notification.object is NSManagedObjectContext && notification.object as? NSManagedObjectContext != self {
            if let updatedObjects = notification.userInfo?[NSUpdatedObjectsKey] as? Set<NSManagedObject> {
                for managedObject in updatedObjects {
                    self.objectWithID(managedObject.objectID)
                        .willAccessValueForKey(nil)
                }
            }
            self.mergeChangesFromContextDidSaveNotification(notification)
            self.processPendingChanges()
        }
    }

    func resetContext() {
        self.performBlockAndWait {
            self.reset()
        }
    }

    func saveContext() {
        if self.hasChanges == true {
            self.performBlockAndWait {
                self.debugOperation {(error: NSErrorPointer) -> (Void) in
                    self.save(error)
                }
            }
        }
    }

    func saveStore(completionHandler: ((Void)->(Void))?=nil) {
        self.saveContext()
        if let parentContext = self.parentContext {
            parentContext.saveStore(completionHandler: completionHandler)
        }
        else {
            completionHandler?()
        }
    }
}
