import CoreData
import UIKit

public extension NSFetchedResultsController {    
    func performFetch(#delegate: NSFetchedResultsControllerDelegate) -> Self {
        self.delegate = delegate
        self.performFetch(nil)
        return self
    }

    func performFetch() -> Self {
        self.performFetch(nil)
        return self
    }
}
