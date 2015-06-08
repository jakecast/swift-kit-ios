import CoreData

public extension NSManagedObjectContext {
    public convenience init(
        concurrencyType: NSManagedObjectContextConcurrencyType,
        persistentStoreCoordinator: NSPersistentStoreCoordinator,
        mergePolicy: AnyObject=NSErrorMergePolicy
    ) {
        self.init(concurrencyType: concurrencyType)
        self.mergePolicy = mergePolicy
        self.persistentStoreCoordinator = persistentStoreCoordinator
        self.undoManager = nil
    }
    
    public convenience init(
        concurrencyType: NSManagedObjectContextConcurrencyType,
        parentContext: NSManagedObjectContext,
        mergePolicy: AnyObject=NSErrorMergePolicy
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

    public var storeCoordinator: NSPersistentStoreCoordinator? {
        return self.persistentStoreContext.persistentStoreCoordinator
    }

    public func changedObjectsUserInfo(notification: NSNotification) -> [String:[NSURL]] {
        var changedObjects: [String:[NSURL]] = [:]
        if let insertedObjects = notification[NSInsertedObjectsKey] as? Set<NSManagedObject> {
            changedObjects[NSInsertedObjectsKey] = insertedObjects.arrayValue.map { return $0.objectID.URIRepresentation() }
        }
        if let updatedObjects = notification[NSUpdatedObjectsKey] as? Set<NSManagedObject> {
            changedObjects[NSUpdatedObjectsKey] = updatedObjects.arrayValue.map { return $0.objectID.URIRepresentation() }
        }
        if let deletedObjects = notification[NSDeletedObjectsKey] as? Set<NSManagedObject> {
            changedObjects[NSDeletedObjectsKey] = deletedObjects.arrayValue.map { return $0.objectID.URIRepresentation() }
        }
        return changedObjects
    }

    public func deleteObject(#objectID: NSManagedObjectID) {
        self.getObject(objectID: objectID)?
            .deleteObject(context: self)
    }

    public func deleteObject(#objectURI: NSURL) {
        self.getObject(objectURI: objectURI)?
            .deleteObject(context: self)
    }

    public func faultObject(#objectID: NSManagedObjectID) {
        self.getObject(objectID: objectID)?
            .faultObject()
    }

    public func getObjects(#objectIdentifiers: [NSManagedObjectID]) -> [NSManagedObject] {
        let objectSet = objectIdentifiers
            .map { return self.getObject(objectID: $0) }
            .filter { $0 != nil }
            .map { $0! }
        return objectSet
    }
    
    public func getObject(#objectID: NSManagedObjectID) -> NSManagedObject? {
        var managedObject: NSManagedObject?
        NSError.performOperation {(error) -> (Void) in
            managedObject = self.existingObjectWithID(objectID, error: error)
        }
        return managedObject
    }

    public func getObject(#objectURI: NSURL) -> NSManagedObject? {
        var managedObject: NSManagedObject?
        if let objectID = self.storeCoordinator?[objectURI] {
            managedObject = self.getObject(objectID: objectID)
        }
        return managedObject
    }
    
    public func insertObject(#objectID: NSManagedObjectID) {
        self.getObject(objectID: objectID)?
            .insertObject(context: self)
    }

    public func insertObject(#objectURI: NSURL) {
        self.getObject(objectURI: objectURI)?
            .insertObject(context: self)
    }

    public func mergeChangedObjects(notification: [String:[NSURL]]) {
        self.performBlockAndWait {
            if let insertedObjects = notification[NSInsertedObjectsKey] {
                insertedObjects.each { self.insertObject(objectURI: $0) }
            }
            if let updatedObjects = notification[NSUpdatedObjectsKey] {
                updatedObjects.each { self.updateObject(objectURI: $0, mergeChanges: false) }
            }
            if let deletedObjects = notification[NSDeletedObjectsKey] {
                deletedObjects.each { self.deleteObject(objectURI: $0) }
            }
        }
    }

    public func mergeSaveChanges(notification: NSNotification!) {
        if self != notification.object as? NSManagedObjectContext {
            self.performBlockAndWait {
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
    }
    
    public func obtainPermanentIdentifiers(notification: NSNotification!) {
        if let context = notification.object as? NSManagedObjectContext {
            self.performBlockAndWait {
                if context.insertedObjects.isEmpty == false {
                    NSError.performOperation {(error: NSErrorPointer) -> (Void) in
                        context.obtainPermanentIDsForObjects(context.insertedObjects.arrayValue, error: error)
                    }
                }
            }
        }
    }

    public func refresh(#object: NSManagedObject, mergeChanges: Bool) {
        self.refreshObject(object, mergeChanges: mergeChanges)
    }

    public func resetContext() {
        self.performBlockAndWait {
            self.reset()
        }
    }

    public func saveContext() {
        NSError.performOperation {(error: NSErrorPointer) -> (Void) in
            self.performBlockAndWait {
                if self.hasChanges == true {
                    self.save(error)
                }
            }
        }
    }

    public func savePersistentStore(completionHandler: ((Void)->(Void))?=nil) {
        self.saveContext()
        if let parentContext = self.parentContext {
            parentContext.savePersistentStore(completionHandler: completionHandler)
        }
        else {
            completionHandler?()
        }
    }
    
    public func updateObject(#objectID: NSManagedObjectID, mergeChanges: Bool) {
        self.getObject(objectID: objectID)?
            .faultObject()
            .refreshObject(context: self, mergeChanges: mergeChanges)
    }

    public func updateObject(#objectURI: NSURL, mergeChanges: Bool) {
        self.getObject(objectURI: objectURI)?
            .faultObject()
            .refreshObject(context: self, mergeChanges: mergeChanges)
    }

    public subscript(objectRef: NSObject?) -> NSManagedObject? {
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
