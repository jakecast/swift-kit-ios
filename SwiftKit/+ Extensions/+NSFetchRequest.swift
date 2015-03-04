import CoreData
import Foundation

public extension NSFetchRequest {
    convenience init(entityName: String, properties: [NSObject:AnyObject]?, predicateAttributes: [String:AnyObject]?) {
        self.init(entityName: entityName)
        if let objectProperties = properties {
            self.setValuesForKeysWithDictionary(objectProperties)
        }
        if let attributes = predicateAttributes {
            self.predicate = NSPredicate(attributes: attributes)
        }
    }
    
    func performCount(#context: NSManagedObjectContext) -> Int {
        var fetchCount: Int?
        self.debugOperation({(error: NSErrorPointer) -> (Void) in
            fetchCount = context.countForFetchRequest(self, error: error)
        })
        return fetchCount!
    }
    
    func performFetch(#context: NSManagedObjectContext) -> [AnyObject] {
        var fetchResults: [AnyObject]?
        self.debugOperation({(error: NSErrorPointer) -> (Void) in
            fetchResults = context.executeFetchRequest(self, error: error)
        })
        return fetchResults ?? []
    }
}
