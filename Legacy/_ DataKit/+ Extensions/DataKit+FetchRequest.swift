import UIKit

public extension FetchRequest {
    convenience init(entity: EntityDescription) {
        self.init()
        self.entity = entity
    }

    func performCount(context: ManagedObjectContext=ManagedObjectContext.currentInstance) -> Int {
        let fetchCount = context.countForFetchRequest(self, error: nil)

        return fetchCount
    }

    func performFetch(context: ManagedObjectContext=ManagedObjectContext.currentInstance) -> [ManagedObject] {
        let fetchResults = context.executeFetchRequest(self, error: nil)

        return fetchResults as! [ManagedObject]
    }
}