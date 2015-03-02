import CoreData
import UIKit

public extension NSManagedObject {
    class var entityName: String? {
        return self
            .description()
            .componentsSeparatedByString(".")
            .lastItem()?
            .componentsSeparatedByString("_")
            .firstItem()
    }
    
    class func getEntityProperties(#context: NSManagedObjectContext) -> [NSPropertyDescription] {
        return self.getEntityDescription(context: context).properties as! [NSPropertyDescription]
    }
    
    class func getEntityDescription(#context: NSManagedObjectContext) -> NSEntityDescription {
        return NSEntityDescription.entityForName(self.entityName!, inManagedObjectContext: context)!
    }

    class func newFetchRequest(
        #context: NSManagedObjectContext,
        predicate: NSPredicate?=nil,
        sortDescriptors: [NSSortDescriptor]?=nil,
        fetchLimit: Int=0,
        batchSize: Int=0,
        relationshipKeyPaths: [AnyObject]?=nil
    ) -> NSFetchRequest {
        let request = NSFetchRequest(entity: self.getEntityDescription(context: context))
        request.predicate = predicate
        request.sortDescriptors = sortDescriptors
        request.fetchLimit = fetchLimit
        request.fetchBatchSize = batchSize
        request.relationshipKeyPathsForPrefetching = relationshipKeyPaths

        return request
    }

    class func newFetchRequest(
        #context: NSManagedObjectContext,
        attributes: [String:AnyObject]?,
        sortDescriptors: [NSSortDescriptor]?=nil,
        fetchLimit: Int=0,
        batchSize: Int=0,
        relationshipKeyPaths: [AnyObject]?=nil
    ) -> NSFetchRequest {
        return self.newFetchRequest(
            context: context,
            predicate: attributes != nil ? NSPredicate(attributes: attributes!) : nil,
            sortDescriptors: sortDescriptors,
            fetchLimit: fetchLimit,
            batchSize: batchSize,
            relationshipKeyPaths: relationshipKeyPaths
        )
    }

    class func newFetchedResultsController(
        #context: NSManagedObjectContext,
        predicate: NSPredicate?=nil,
        sortDescriptors: [NSSortDescriptor]?=nil,
        fetchLimit: Int=0,
        batchSize: Int=0,
        relationshipKeyPaths: [AnyObject]?=nil,
        sectionName: String?=nil,
        cacheName: String?=nil
    ) -> NSFetchedResultsController {
        let fetchRequest = self.newFetchRequest(
            context: context,
            predicate: predicate,
            sortDescriptors: sortDescriptors ?? [NSSortDescriptor(key: self.getEntityProperties(context: context).first!.name, ascending: true), ],
            fetchLimit: fetchLimit,
            batchSize: batchSize,
            relationshipKeyPaths: relationshipKeyPaths
        )
        let resultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: sectionName,
            cacheName: cacheName
        )
        
        return resultsController
    }

    class func exists(#context: NSManagedObjectContext, attributes: [String: AnyObject]?=nil) -> Bool {
        return (self.count(context: context, attributes: attributes) != 0)
    }
    
    class func create(#context: NSManagedObjectContext, attributes: [String:AnyObject]?=nil) -> Self {
        let newManagedObject = self(
            entity: self.getEntityDescription(context: context),
            insertIntoManagedObjectContext: context
        )
        if let attributesDictionary = attributes {
            newManagedObject.update(attributes: attributesDictionary)
        }
        return newManagedObject
    }

    class func first(#context: NSManagedObjectContext, attributes: [String: AnyObject]?=nil) -> AnyObject? {
        var firstObject: AnyObject? = self
            .newFetchRequest(context: context, attributes: attributes, fetchLimit: 1)
            .performFetch(context: context)?
            .firstItem()
        return firstObject
    }

    class func initialize(#context: NSManagedObjectContext, attributes: [String: AnyObject]?=nil) -> AnyObject {
        return self.first(context: context, attributes: attributes) ?? self.create(context: context, attributes: attributes)
    }

    class func all(#context: NSManagedObjectContext) -> [AnyObject]? {
        var allObjects: [AnyObject]? = self
            .newFetchRequest(context: context)
            .performFetch(context: context)
        return allObjects
    }

    class func count(#context: NSManagedObjectContext, attributes: [String: AnyObject]?=nil) -> Int {
        return self
            .newFetchRequest(context: context, attributes: attributes)
            .performCount(context: context)
    }

    func obtainPermanentIdentifier() {
        if self.objectID.temporaryID == true {
            self.managedObjectContext?.performBlockAndWait({
                self.managedObjectContext?.obtainPermanentIDsForObjects([self, ], error: nil)
            })
        }
    }

    func update(#attributes: [String:AnyObject]) {
        self.managedObjectContext?.performBlockAndWait {
            self.setValuesForKeysWithDictionary(attributes)
        }
    }
}