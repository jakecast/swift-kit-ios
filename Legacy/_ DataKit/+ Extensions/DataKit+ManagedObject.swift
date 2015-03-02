import UIKit

public extension ManagedObject {
    class var entityName: String? {
        return self
            .description()
            .componentsSeparatedByString(".")
            .lastItem()?
            .componentsSeparatedByString("_")
            .firstItem()
    }

    class var entityDescription: EntityDescription {
        let entityDescription = EntityDescription.entityForName(
            self.entityName!,
            inManagedObjectContext: ManagedObjectContext.currentInstance
        )

        return entityDescription!
    }

    class var properties: [PropertyDescription] {
        return self.entityDescription.properties as [PropertyDescription]
    }

    class func create(
        attributes: [String: AnyObject]?=nil,
        context: ManagedObjectContext=ManagedObjectContext.currentInstance
    ) -> Self {
        let newManagedObject = self(
            entity: self.entityDescription,
            insertIntoManagedObjectContext: context
        )
        newManagedObject.update(attributes: attributes)

        return newManagedObject
    }

    class func newFetchRequest(
        predicate: Predicate?=nil,
        sortDescriptors: [SortDescriptor]?=nil,
        fetchLimit: Int=0,
        batchSize: Int=0,
        shouldRefreshRefetchedObjects: Bool=true
    ) -> FetchRequest {
        let request = FetchRequest(entity: self.entityDescription)
        request.predicate = predicate
        request.sortDescriptors = sortDescriptors
        request.fetchLimit = fetchLimit
        request.fetchBatchSize = batchSize
        request.shouldRefreshRefetchedObjects = shouldRefreshRefetchedObjects

        return request
    }

    class func newFetchRequest(
        #attributes: [String:AnyObject]?,
        sortDescriptors: [SortDescriptor]?=nil,
        fetchLimit: Int=0,
        batchSize: Int=0,
        shouldRefreshRefetchedObjects: Bool=true
    ) -> FetchRequest {
        return self.newFetchRequest(
            predicate: (attributes != nil) ? Predicate(attributes: attributes!) : nil,
            sortDescriptors: sortDescriptors,
            fetchLimit: fetchLimit,
            batchSize: batchSize,
            shouldRefreshRefetchedObjects: shouldRefreshRefetchedObjects
        )
    }

    class func newResultsController(
        predicate: Predicate?=nil,
        sortDescriptors: [SortDescriptor]?=nil,
        fetchLimit: Int=0,
        batchSize: Int=0,
        shouldRefreshRefetchedObjects: Bool=true,
        context: ManagedObjectContext=ManagedObjectContext.currentInstance,
        sectionName: String?=nil,
        cacheName: String?=nil
    ) -> ResultsController {
        let fetchRequest = self.newFetchRequest(
            predicate: predicate,
            sortDescriptors: sortDescriptors ?? [NSSortDescriptor(key: self.properties.first!.name, ascending: true), ],
            fetchLimit: fetchLimit,
            batchSize: batchSize,
            shouldRefreshRefetchedObjects: shouldRefreshRefetchedObjects
        )
        let resultsController = ResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: sectionName,
            cacheName: cacheName
        )

        return resultsController
    }

    class func first(attributes: [String: AnyObject]?=nil) -> ManagedObject? {
        return self
            .newFetchRequest(attributes: attributes, fetchLimit: 1)
            .performFetch()
            .firstItem()
    }

    class func firstOrCreate(attributes: [String: AnyObject]?=nil) -> ManagedObject {
        return self.first(attributes: attributes) ?? self.create(attributes: attributes)
    }

    class func all() -> [ManagedObject] {
        return self
            .newFetchRequest()
            .performFetch()
    }

    class func count() -> Int {
        return self
            .newFetchRequest()
            .performCount()
    }

    func resultsController() -> ResultsController {
        return self.dynamicType.newResultsController(
            predicate: Predicate(format: "(self = %@)", argumentArray: [self, ]),
            fetchLimit: 1
        )
    }

    func update(#attributes: [String: AnyObject]?) {
        if let attributesDictionary = attributes {
            self.setValuesForKeysWithDictionary(attributesDictionary)
        }
    }
}