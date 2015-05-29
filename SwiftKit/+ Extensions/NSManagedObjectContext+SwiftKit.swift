import CoreData

public extension NSManagedObjectContext {
    public convenience init(
        concurrencyType: NSManagedObjectContextConcurrencyType,
        mergePolicy: AnyObject=NSErrorMergePolicy,
        persistentStoreCoordinator: NSPersistentStoreCoordinator
    ) {
        self.init(concurrencyType: concurrencyType)
        self.mergePolicy = mergePolicy
        self.persistentStoreCoordinator = persistentStoreCoordinator
        self.undoManager = nil
    }
    
    public convenience init(
        concurrencyType: NSManagedObjectContextConcurrencyType,
        mergePolicy: AnyObject=NSErrorMergePolicy,
        parentContext: NSManagedObjectContext
    ) {
        self.init(concurrencyType: concurrencyType)
        self.mergePolicy = mergePolicy
        self.parentContext = parentContext
        self.undoManager = nil
    }

    public var persistentStoreContext: NSManagedObjectContext {
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
    
    func deleteObject(#objectID: NSManagedObjectID) {
        self.getObject(objectID: objectID)?
            .deleteObject(context: self)
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
            managedObject = self.existingObjectWithID(objectID, error: error)
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
    
    func insertObject(#objectID: NSManagedObjectID) {
        self.getObject(objectID: objectID)?
            .insertObject(context: self)
    }

    func mergeSaveChanges(notification: NSNotification!) {
        if self != notification.object as? NSManagedObjectContext {
            if let insertedObjects = notification[NSInsertedObjectsKey] as? Set<NSManagedObject> {
                insertedObjects.arrayValue.each { self.insertObject(objectID: $0.objectID) }
            }
            
            if let updatedObjects = notification[NSUpdatedObjectsKey] as? Set<NSManagedObject> {
                updatedObjects.arrayValue.each { self.updateObject(objectID: $0.objectID, mergeChanges: false) }
            }
            
            if let deletedObjects = notification[NSDeletedObjectsKey] as? Set<NSManagedObject> {
                deletedObjects.arrayValue.each { self.deleteObject(objectID: $0.objectID) }
            }
            self.processPendingChanges()
        }
    }

    func obtainPermanentIdentifiers(notification: NSNotification!) {
        if let context = notification.object as? NSManagedObjectContext {
            if context.insertedObjects.isEmpty == false {
                NSError.performOperation {(error: NSErrorPointer) -> (Void) in
                    context.obtainPermanentIDsForObjects(context.insertedObjects.arrayValue, error: error)
                }
            }
        }
    }

    func refresh(#object: NSManagedObject, mergeChanges: Bool) {
        self.refreshObject(object, mergeChanges: mergeChanges)
    }

    func resetContext() {
        self.reset()
    }

    func saveContext() {
        if self.hasChanges == true {
            NSError.performOperation {(error: NSErrorPointer) -> (Void) in
                self.save(error)
            }
        }
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
    
    func updateObject(#objectID: NSManagedObjectID, mergeChanges: Bool) {
        self.getObject(objectID: objectID)?
            .refreshObject(context: self, mergeChanges: mergeChanges)
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
