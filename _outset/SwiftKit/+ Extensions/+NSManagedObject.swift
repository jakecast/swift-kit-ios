import CoreData

public extension NSManagedObject {
    class var entityName: String {
        var entityName = self
            .description()
            .componentsSeparatedByString(".")
            .lastItem()?
            .componentsSeparatedByString("_")
            .firstItem()
        return entityName ?? self.description()
    }
    
    class func deleteObject(#context: NSManagedObjectContext, object: NSManagedObject?) {
        if let deleteObject = object {
            context.deleteObject(deleteObject)
        }
    }
    
    class func entityProperties(#context: NSManagedObjectContext) -> [NSPropertyDescription] {
        return self.entityDescription(context: context).properties as? [NSPropertyDescription] ?? []
    }
    
    class func entityDescription(#context: NSManagedObjectContext) -> NSEntityDescription {
        return NSEntityDescription.entityForName(self.entityName, inManagedObjectContext: context)!
    }
    
    class func createEntity(#context: NSManagedObjectContext, objectAttributes: [String:AnyObject]?=nil) -> Self {
        let newManagedObject = self(entity: self.entityDescription(context: context), insertIntoManagedObjectContext: context)
        if let attributes = objectAttributes {
            newManagedObject.update(attributes: attributes)
        }
        return newManagedObject
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

    func faultObject() {
        self.willAccessValueForKey(nil)
    }

    func obtainPermanentIdentifier() {
        if self.hasTemporaryID == true {
            NSError.performOperation {(error) -> (Void) in
                self.managedObjectContext?.obtainPermanentIDsForObjects([self, ], error: error)
            }
        }
    }
    
    func update(#attributes: [String:AnyObject]) {
        self.setValuesForKeysWithDictionary(attributes)
    }
}