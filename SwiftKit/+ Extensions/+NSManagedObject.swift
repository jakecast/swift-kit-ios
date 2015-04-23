import CoreData

public extension NSManagedObject {
    static var entityName: String {
        var entityName = self
            .description()
            .componentsSeparatedByString(".")
            .lastItem()?
            .componentsSeparatedByString("_")
            .firstItem()
        return entityName ?? self.description()
    }
    
    static func deleteObject(#context: NSManagedObjectContext, object: NSManagedObject?) {
        if let deleteObject = object {
            context.deleteObject(deleteObject)
        }
    }
    
    static func entityProperties(#context: NSManagedObjectContext) -> [NSPropertyDescription] {
        return self.entityDescription(context: context).properties as? [NSPropertyDescription] ?? []
    }
    
    static func entityDescription(#context: NSManagedObjectContext) -> NSEntityDescription {
        return NSEntityDescription.entityForName(self.entityName, inManagedObjectContext: context)!
    }
    
    static func createEntity(#context: NSManagedObjectContext, objectAttributes: [String:AnyObject]?=nil) -> Self {
        let newManagedObject = self(entity: self.entityDescription(context: context), insertIntoManagedObjectContext: context)
        if let attributes = objectAttributes {
            newManagedObject.update(attributes: attributes)
        }
        return newManagedObject
    }
}

public extension NSManagedObject {
    var entityName: String {
        var entityName = self.classForCoder
            .description()
            .componentsSeparatedByString(".")
            .lastItem()?
            .componentsSeparatedByString("_")
            .firstItem()
        return entityName ?? self.classForCoder.description()
    }
    
    var hasTemporaryID: Bool {
        return self.objectID.temporaryID
    }

    var uriRepresentation: NSURL {
        return self.objectID.URIRepresentation()
    }

    var uriHost: String? {
        return self.uriRepresentation.host
    }

    var uriPath: String? {
        return self.uriRepresentation.path
    }
    
    func deleteObject(#context: NSManagedObjectContext) -> Self {
        context.deleteObject(self)
        return self
    }
    
    func entityDescription(#context: NSManagedObjectContext) -> NSEntityDescription? {
        return NSEntityDescription.entityForName(self.entityName, inManagedObjectContext: context)
    }

    func faultObject() -> Self {
        self.willAccessValueForKey(nil)
        return self
    }
    
    func insertObject(#context: NSManagedObjectContext) -> Self {
        context.insertObject(self)
        return self
    }

    func obtainPermanentIdentifier() {
        if self.hasTemporaryID == true {
            NSError.performOperation {(error) -> (Void) in
                self.managedObjectContext?.obtainPermanentIDsForObjects([self, ], error: error)
            }
        }
    }
    
    func refreshObject(#context: NSManagedObjectContext, mergeChanges: Bool) -> Self {
        context.refreshObject(self, mergeChanges: mergeChanges)
        return self
    }
    
    func update(#attributes: [String:AnyObject]) {
        self.setValuesForKeysWithDictionary(attributes)
    }
}