import CoreData
import UIKit

public class CollectionFetchedResults: NSFetchedResultsController, NSFetchedResultsControllerDelegate {
    var contextObserver: NotificationObserver?

    weak var collectionView: UICollectionView?

    lazy var insertedItems: [NSIndexPath] = []
    lazy var deletedItems: [NSIndexPath] = []
    lazy var updatedItems: [NSIndexPath] = []
    lazy var movedItems: [(NSIndexPath, NSIndexPath)] = []

    public func performFetch(#collectionView: UICollectionView) {
        self.collectionView = collectionView
        self.contextObserver = NotificationObserver(
            notification: NSManagedObjectContextObjectsDidChangeNotification,
            object: self.managedObjectContext,
            block: methodPointer(self, CollectionFetchedResults.controllerDidInvalidateContent)
        )
        self.delegate = self
        self.performFetch()
    }

    public func controller(
        controller: NSFetchedResultsController,
        didChangeObject anObject: AnyObject,
        atIndexPath indexPath: NSIndexPath?,
        forChangeType type: NSFetchedResultsChangeType,
        newIndexPath: NSIndexPath?
    ) {
        switch type {
        case .Insert:
            self.insertedItems += [newIndexPath!, ]
        case .Update:
            self.updatedItems += [indexPath!, ]
        case .Delete:
            self.deletedItems += [indexPath!, ]
        case .Move:
            self.movedItems += [(indexPath!, newIndexPath!), ]
        }
    }

    public func controllerDidChangeContent(controller: NSFetchedResultsController) {
        self.mainQueue.dispatchSync {
            self.collectionView?.perform(batchChanges: {
                self.collectionView?.insertItemsAtIndexPaths(self.insertedItems)
                self.collectionView?.reloadItemsAtIndexPaths(self.updatedItems)
                self.collectionView?.deleteItemsAtIndexPaths(self.deletedItems)

                for (oldIndexPath, newIndexPath) in self.movedItems {
                    self.collectionView?.moveItemAtIndexPath(oldIndexPath, toIndexPath: newIndexPath)
                }
            })
        }
        self.resetChanges()
    }

    public func controllerDidInvalidateContent(notification: NSNotification!) {
        if notification.userInfo is [String:AnyObject] && notification.userInfo![NSInvalidatedAllObjectsKey] != nil {
            self.mainQueue.dispatch {
                self.collectionView?.reloadAllSections()
            }
        }
    }

    func resetChanges() {
        self.insertedItems.removeAll(keepCapacity: false)
        self.deletedItems.removeAll(keepCapacity: false)
        self.updatedItems.removeAll(keepCapacity: false)
        self.movedItems.removeAll(keepCapacity: false)
    }
}
