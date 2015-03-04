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
    
    class func entityProperties(#context: NSManagedObjectContext) -> [NSPropertyDescription] {
        return self.entityDescription(context: context).properties as? [NSPropertyDescription] ?? []
    }
    
    class func entityDescription(#context: NSManagedObjectContext) -> NSEntityDescription {
        return NSEntityDescription.entityForName(self.entityName, inManagedObjectContext: context)!
    }
    
    class func fetchRequest(properties: [String:AnyObject]?=nil, predicateAttributes: [String:AnyObject]?=nil) -> NSFetchRequest {
        return NSFetchRequest(entityName: self.entityName, properties: properties, predicateAttributes: predicateAttributes)
    }
    
    class func createEntity(#context: NSManagedObjectContext, objectAttributes: [String:AnyObject]?=nil) -> Self {
        let newManagedObject = self(entity: self.entityDescription(context: context), insertIntoManagedObjectContext: context)
        newManagedObject.obtainPermanentIdentifier()
        if let attributes = objectAttributes {
            newManagedObject.update(attributes: attributes)
        }
        return newManagedObject
    }
    
    class func all(#context: NSManagedObjectContext) -> [AnyObject] {
        let allObjects = self.fetchRequest().performFetch(context: context) ?? []
        return allObjects
    }
    
    class func first(#context: NSManagedObjectContext, predicateAttributes: [String: AnyObject]?=nil) -> AnyObject? {
        var firstObject: AnyObject? = self
            .fetchRequest(properties: ["fetchLimit": 1, ], predicateAttributes: predicateAttributes)
            .performFetch(context: context)
            .firstItem()
        return firstObject
    }
    
    class func count(#context: NSManagedObjectContext, predicateAttributes: [String: AnyObject]?=nil) -> Int {
        let count = self
            .fetchRequest(predicateAttributes: predicateAttributes)
            .performCount(context: context)
        return count
    }
    
    class func exists(#context: NSManagedObjectContext, predicateAttributes: [String:AnyObject]?=nil) -> Bool {
        return self.count(context: context, predicateAttributes: predicateAttributes) != 0
    }

    func obtainPermanentIdentifier() {
        if self.objectID.temporaryID == true {
            self.managedObjectContext?.performBlockAndWait({
                self.managedObjectContext?.obtainPermanentIDsForObjects([self, ], error: nil)
            })
        }
    }
    
    func update(#attributes: [String:AnyObject]) {
        self.managedObjectContext?.performBlockAndWait({
            self.setValuesForKeysWithDictionary(attributes)
        })
    }
}