import CoreData

public extension NSManagedObject {
    static var entityName: String {
        return self
            .description()
            .componentsSeparatedByString(".")
            .lastItem()?
            .componentsSeparatedByString("_")
            .firstItem() ?? self.description()
    }
    
    static func entityDescription(#context: NSManagedObjectContext) -> NSEntityDescription {
        return NSEntityDescription.entityDescription(name: self.entityName, context: context)
    }
    
    static func deleteObject(#context: NSManagedObjectContext, object: NSManagedObject?) {
        if let deleteObject = object {
            context.deleteObject(deleteObject)
        }
    }
}

public extension NSManagedObject {
    public var entityName: String {
        return self.classForCoder.entityName
    }
    
    public var hasTemporaryID: Bool {
        return self.objectID.temporaryID
    }

    public var uriRepresentation: NSURL {
        return self.objectID.URIRepresentation()
    }

    public var uriHost: String? {
        return self.uriRepresentation.host
    }

    public var uriPath: String? {
        return self.uriRepresentation.path
    }
    
//    public convenience init(context: NSManagedObjectContext, entityName: String) {
//        self.init(
//            entity: NSEntityDescription.entityDescription(name: entityName, context: context),
//            insertIntoManagedObjectContext: context
//        )
//    }

    public func deleteObject(#context: NSManagedObjectContext) -> Self {
        context.deleteObject(self)
        return self
    }
    
    public func entityDescription(#context: NSManagedObjectContext) -> NSEntityDescription? {
        return NSEntityDescription.entityForName(self.entityName, inManagedObjectContext: context)
    }

    public func faultObject() -> Self {
        self.willAccessValueForKey(nil)
        return self
    }
    
    public func insertObject(#context: NSManagedObjectContext) -> Self {
        context.insertObject(self)
        return self
    }

    public func obtainPermanentIdentifier() {
        if self.hasTemporaryID == true {
            NSError.performOperation {(error) -> (Void) in
                self.managedObjectContext?.obtainPermanentIDsForObjects([self, ], error: error)
            }
        }
    }
    
    public func refreshObject(#context: NSManagedObjectContext, mergeChanges: Bool) -> Self {
        context.refreshObject(self, mergeChanges: mergeChanges)
        return self
    }
    
    public func update(#attributes: [String:AnyObject]) {
        self.setValuesForKeysWithDictionary(attributes)
    }
}