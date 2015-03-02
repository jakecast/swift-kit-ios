import CoreData
import UIKit

public extension NSFetchedResultsController {
    subscript(index: Int) -> AnyObject? {
        return self.objectAtIndexPath(NSIndexPath(forItem: index, inSection: 0))
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
}