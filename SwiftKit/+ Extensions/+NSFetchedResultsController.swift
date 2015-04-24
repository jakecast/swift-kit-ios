import CoreData
import UIKit

public extension NSFetchedResultsController {
    func indexPath(#objectIdentifier: NSManagedObjectID?) -> NSIndexPath? {
        return self[self.managedObjectContext[objectIdentifier]] as? NSIndexPath
    }

    func indexPathsForObjects(#objectIdentifiers: [NSManagedObjectID]) -> [NSIndexPath]? {
        let indexPaths = self.managedObjectContext
            .getObjects(objectIdentifiers: objectIdentifiers)
            .map({ return self[$0] as? NSIndexPath })
            .filter({ return $0 != nil })
            .map({ $0! })
        return indexPaths.isEmpty ? nil : indexPaths
    }
    
    func numberOfObjects() -> Int {
        let numberOfObjects: Int
        if let sections = self.sections {
            numberOfObjects = sections.reduce(0, combine: { return $0 + self.numberOfObjects(sectionInfo: $1 as? NSFetchedResultsSectionInfo) })
        }
        else {
            numberOfObjects = 0
        }
        return numberOfObjects
    }

    func numberOfObjects(#section: Int) -> Int {
        return self.numberOfObjects(sectionInfo: get(self.sections, section) as? NSFetchedResultsSectionInfo)
    }
    
    func numberOfObjects(#sectionInfo: NSFetchedResultsSectionInfo?) -> Int {
        return sectionInfo?.numberOfObjects ?? 0
    }

    func performFetch(#delegate: NSFetchedResultsControllerDelegate) -> Self {
        self.delegate = delegate
        self.performFetch()
        return self
    }

    func performFetch() -> Self {
        NSError.performOperation {(error: NSErrorPointer) -> (Void) in
            self.performFetch(error)
        }
        return self
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
