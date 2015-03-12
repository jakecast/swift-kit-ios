import CoreData
import UIKit

public extension NSFetchedResultsController {    
    func performFetch(#delegate: NSFetchedResultsControllerDelegate) -> Self {
        self.delegate = delegate
        self.performFetch()
        return self
    }

    func performFetch() -> Self {
        self.debugOperation {(error: NSErrorPointer) -> (Void) in
            self.performFetch(error)
        }
        return self
    }
}
