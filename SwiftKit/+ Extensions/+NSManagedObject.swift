import CoreData

public extension NSManagedObject {
    class var dataStore: DataStore {
        return DataStore.sharedInstance!
    }

    class var entityName: String {
        var entityName = self
            .description()
            .componentsSeparatedByString(".")
            .lastItem()?
            .componentsSeparatedByString("_")
            .firstItem()
        return entityName ?? self.description()
    }
    
    class func deleteObject(#context: NSManagedObjectContext, object: NSManagedObject) {
        context.deleteObject(object)
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

    var dataStore: DataStore {
        return NSManagedObject.dataStore
    }

    var hasTemporaryID: Bool {
        return self.objectID.temporaryID
    }

    func obtainPermanentIdentifier() {
        if self.hasTemporaryID == true {
            self.debugOperation {(error) -> (Void) in
                self.managedObjectContext?.obtainPermanentIDsForObjects([self, ], error: error)
            }
        }
    }
    
    func update(#attributes: [String:AnyObject]) {
        self.setValuesForKeysWithDictionary(attributes)
    }
}