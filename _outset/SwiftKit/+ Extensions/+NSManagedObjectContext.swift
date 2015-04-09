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
    
    var persistentStoreContext: NSManagedObjectContext {
        let persistentStoreContext: NSManagedObjectContext
        if let parentContext = self.parentContext {
            persistentStoreContext = parentContext.persistentStoreContext
        }
        else {
            persistentStoreContext = self
        }
        return persistentStoreContext
    }

    var storeCoordinator: NSPersistentStoreCoordinator? {
        return self.persistentStoreContext.persistentStoreCoordinator
    }
    
    func delete(#object: NSManagedObject, save: Bool=true) {
        self.deleteObject(object)
        if save == true {
            self.saveContext()
        }
    }
    
    func faultObjects(#objectIdentifiers: [NSManagedObjectID]) {
        for objectID in objectIdentifiers {
            self.faultObject(objectID: objectID)
        }
    }
    
    func faultObject(#objectID: NSManagedObjectID) {
        self.getObject(objectID: objectID)?
            .faultObject()
    }

    func getObjects(#objectIdentifiers: [NSManagedObjectID]) -> [NSManagedObject] {
        let objectSet = objectIdentifiers
            .map { return self.getObject(objectID: $0) }
            .filter { $0 != nil }
            .map { $0! }
        return objectSet
    }
    
    func getObject(#objectID: NSManagedObjectID) -> NSManagedObject? {
        var managedObject: NSManagedObject?
        NSError.performOperation {(error) -> (Void) in
            self.performBlockAndWait {
                managedObject = self.existingObjectWithID(objectID, error: error)
            }
        }
        return managedObject
    }

    func getObject(#objectURI: NSURL) -> NSManagedObject? {
        var managedObject: NSManagedObject?
        if let objectID = self.storeCoordinator?[objectURI] {
            managedObject = self.getObject(objectID: objectID)
        }
        return managedObject
    }

    func mergeChanges(notification: NSNotification!) {
        if notification.object is NSManagedObjectContext && notification.object as? NSManagedObjectContext != self {
            self.performBlockAndWait {
                if let updatedObjects = notification[NSUpdatedObjectsKey] as? Set<NSManagedObject> {
                    updatedObjects.arrayValue.each { self.objectWithID($0.objectID).faultObject() }
                }
                self.mergeChangesFromContextDidSaveNotification(notification)
                self.processPendingChanges()
            }
        }
    }

    func obtainPermanentIdentifiers(notification: NSNotification!) {
        if let context = notification.object as? NSManagedObjectContext {
            if context.insertedObjects.isEmpty == false {
                NSError.performOperation {(error: NSErrorPointer) -> (Void) in
                    context.performBlockAndWait {
                        context.obtainPermanentIDsForObjects(context.insertedObjects.arrayValue, error: error)
                    }
                }
            }
        }
    }

    func performBlockSynced(block: ((Void)->(Void))) {
        self.performBlock { self.synced(block) }
    }

    func refresh(#object: NSManagedObject, mergeChanges: Bool) {
        self.performBlockAndWait {
            self.refreshObject(object, mergeChanges: mergeChanges)
        }
    }

    func resetContext() {
        self.performBlockAndWait {
            self.reset()
        }
    }
    
    func saveContext(completionHandler: ((Void)->(Void))?=nil) {
        self.performBlockAndWait {
            if self.hasChanges == true {
                NSError.performOperation {(error: NSErrorPointer) -> (Void) in
                    self.save(error)
                }
            }
        }
        completionHandler?()
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

    subscript(objectRef: NSObject?) -> NSManagedObject? {
        var object: NSManagedObject?
        switch objectRef {
        case let objectID as NSManagedObjectID:
            object = self.getObject(objectID: objectID)
        case let objectValue as NSManagedObject:
            object = (self == objectValue.managedObjectContext) ? objectValue : self.getObject(objectID: objectValue.objectID)
        case let objectURI as NSURL:
            object = self.getObject(objectURI: objectURI)
        default:
            object = nil
        }
        return object
    }
}