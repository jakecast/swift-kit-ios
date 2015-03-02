import CoreData
import UIKit

public extension NSFetchRequest {
    convenience init(entity: NSEntityDescription) {
        self.init()
        self.entity = entity
    }

    func performCount(#context: NSManagedObjectContext) -> Int {
        var fetchCount: Int?
        self.debugOperation({(error: NSErrorPointer) -> (Void) in
            fetchCount = context.countForFetchRequest(self, error: error)
        })
        return fetchCount!
    }

    func performFetch(#context: NSManagedObjectContext) -> [AnyObject]? {
        var fetchResults: [AnyObject]?
        self.debugOperation({(error: NSErrorPointer) -> (Void) in
            fetchResults = context.executeFetchRequest(self, error: error)
        })
        return fetchResults
    }
}