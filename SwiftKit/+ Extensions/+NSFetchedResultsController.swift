import CoreData
import UIKit

public extension NSFetchedResultsController {
    convenience init(
        fetchRequest: NSFetchRequest,
        managedObjectContext: NSManagedObjectContext,
        sectionKeyPath: String?=nil,
        cacheName: String?=nil
    ) {
        if let cache = cacheName {
            NSFetchedResultsController.deleteCacheWithName(cache)
        }
        self.init(
            fetchRequest: fetchRequest,
            managedObjectContext: managedObjectContext,
            sectionNameKeyPath: sectionKeyPath,
            cacheName: cacheName
        )
    }

    func numberOfObjects(#section: Int) -> Int {
        let numberOfObjects: Int
        if let sectionInfo = self.sections?[section] as? NSFetchedResultsSectionInfo {
            numberOfObjects = sectionInfo.numberOfObjects
        }
        else {
            numberOfObjects = 0
        }
        return numberOfObjects
    }
    
    subscript(index: Int) -> AnyObject? {
        return self.objectAtIndexPath(NSIndexPath(forItem: index, inSection: 0))
    }
}
