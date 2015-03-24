import CoreData
import UIKit

public extension NSFetchedResultsController {
    func indexPathsForObjects(#objectIdentifiers: [NSManagedObjectID]) -> [NSIndexPath]? {
        let indexPaths = self.managedObjectContext
            .getObjects(objectIdentifiers: objectIdentifiers)
            .map({ return self[$0] as? NSIndexPath })
            .filter({ return $0 != nil })
            .map({ $0! })
        return indexPaths.isEmpty ? nil : indexPaths
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

    subscript(objectRef: NSObject?) -> AnyObject? {
        var object: AnyObject?
        switch objectRef {
        case let indexPath as NSIndexPath:
            object = self.objectAtIndexPath(indexPath)
        case let managedObject as NSManagedObject:
            object = self.indexPathForObject(managedObject)
        case let managedObjectID as NSManagedObjectID:
            object = self.managedObjectContext[managedObjectID]
        default:
            object = nil
        }
        return object
    }

    subscript(index: (Int, Int)) -> AnyObject? {
        return self.objectAtIndexPath(NSIndexPath(forItem: index.0, inSection: index.1))
    }
}
