import CoreData
import Foundation

public extension NSFetchRequest {    
    func performCount(#context: NSManagedObjectContext) -> Int {
        var fetchCount: Int?
        NSError.performOperation {(error: NSErrorPointer) -> (Void) in
            fetchCount = context.countForFetchRequest(self, error: error)
        }
        return fetchCount ?? 0
    }
    
    func performFetch(#context: NSManagedObjectContext) -> [AnyObject] {
        var fetchResults: [AnyObject]?
        NSError.performOperation {(error: NSErrorPointer) -> (Void) in
            fetchResults = context.executeFetchRequest(self, error: error)
        }
        return fetchResults ?? []
    }

    func add(#andPredicate: NSPredicate) -> Self {
        if let currentPredicate = self.predicate {
            self.predicate = NSCompoundPredicate(type: NSCompoundPredicateType.AndPredicateType, subpredicates: [currentPredicate, andPredicate, ])
        }
        else {
            self.predicate = NSCompoundPredicate(type: NSCompoundPredicateType.AndPredicateType, subpredicates: [andPredicate, ])
        }
        return self
    }

    func add(#orPredicate: NSPredicate) -> Self {
        if let currentPredicate = self.predicate {
            self.predicate = NSCompoundPredicate(type: NSCompoundPredicateType.OrPredicateType, subpredicates: [currentPredicate, orPredicate, ])
        }
        else {
            self.predicate = NSCompoundPredicate(type: NSCompoundPredicateType.OrPredicateType, subpredicates: [orPredicate, ])
        }
        return self
    }

    func add(#notPredicate: NSPredicate) -> Self {
        if let currentPredicate = self.predicate {
            self.predicate = NSCompoundPredicate(type: NSCompoundPredicateType.NotPredicateType, subpredicates: [currentPredicate, notPredicate, ])
        }
        else {
            self.predicate = NSCompoundPredicate(type: NSCompoundPredicateType.NotPredicateType, subpredicates: [notPredicate, ])
        }
        return self
    }

    func set(#fetchBatchSize: Int) -> Self {
        self.fetchBatchSize = fetchBatchSize
        return self
    }

    func set(#fetchLimit: Int) -> Self {
        self.fetchLimit = fetchLimit
        return self
    }

    func set(#includesPendingChanges: Bool) -> Self {
        self.includesPendingChanges = includesPendingChanges
        return self
    }

    func set(#predicate: NSPredicate) -> Self {
        self.predicate = predicate
        return self
    }

    func set(#propertiesToFetch: [AnyObject]) -> Self {
        self.propertiesToFetch = propertiesToFetch
        return self
    }

    func set(#relationshipKeyPaths: [AnyObject]) -> Self {
        self.relationshipKeyPathsForPrefetching = relationshipKeyPaths
        return self
    }

    func set(#resultType: NSFetchRequestResultType) -> Self {
        self.resultType = resultType
        return self
    }

    func set(#returnsObjectsAsFaults: Bool) -> Self {
        self.returnsObjectsAsFaults = returnsObjectsAsFaults
        return self
    }
    
    func set(#shouldRefreshRefetchedObjects: Bool) -> Self {
        self.shouldRefreshRefetchedObjects = shouldRefreshRefetchedObjects
        return self
    }

    func set(#sortDescriptors: [AnyObject]) -> Self {
        self.sortDescriptors = sortDescriptors
        return self
    }
}
