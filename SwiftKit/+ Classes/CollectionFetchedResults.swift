import CoreData
import UIKit

public class CollectionFetchedResults: NSFetchedResultsController, NSFetchedResultsControllerDelegate {
    var contextObserver: NotificationObserver?

    weak var collectionView: UICollectionView?

    lazy var insertedItems: [NSIndexPath] = []
    lazy var deletedItems: [NSIndexPath] = []
    lazy var updatedItems: [NSIndexPath] = []
    lazy var movedItems: [(NSIndexPath, NSIndexPath)] = []

    lazy var isPerformingBatchChanges: Bool = false
    lazy var queuedBatchChanges: [((Void)->(Void))] = []

    public required convenience init(
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
        self.delegate = self
        self.contextObserver = NotificationObserver(
            notification: NSManagedObjectContextObjectsDidChangeNotification,
            object: self.managedObjectContext,
            block: methodPointer(self, CollectionFetchedResults.controllerDidInvalidateContent)
        )
    }

    public func performFetch(#collectionView: UICollectionView) {
        self.collectionView = collectionView
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
        self.perform(batchChanges: {
            self.collectionView?.insertItemsAtIndexPaths(self.insertedItems)
            self.collectionView?.reloadItemsAtIndexPaths(self.updatedItems)
            self.collectionView?.deleteItemsAtIndexPaths(self.deletedItems)

            for (oldIndexPath, newIndexPath) in self.movedItems {
                self.collectionView?.moveItemAtIndexPath(oldIndexPath, toIndexPath: newIndexPath)
            }
            self.resetChanges()
        })
    }

    public func controllerDidInvalidateContent(notification: NSNotification!) {
        if let invalidatedObjects = notification.userInfo?[NSInvalidatedAllObjectsKey] as? [NSManagedObjectID] {
            let invalidatedIndexPaths = self.indexPathsForObjects(objectIdentifiers: invalidatedObjects)
            self.perform(batchChanges: {
                self.collectionView?.reloadItemsAtIndexPaths(invalidatedIndexPaths)
            })
        }
    }

    func perform(#batchChanges: ((Void)->(Void))) {
        self.mainQueue.dispatch {
            if self.isPerformingBatchChanges == false {
                self.isPerformingBatchChanges = true
                self.collectionView?.perform(
                    batchChanges: batchChanges,
                    completionHandler: methodPointer(self, CollectionFetchedResults.batchChangesDidComplete)
                )
            }
            else {
                self.queuedBatchChanges += [batchChanges, ]
            }
        }
    }

    func batchChangesDidComplete(completed: Bool) {
        self.isPerformingBatchChanges = false
        if let batchChanges = popElement(&self.queuedBatchChanges) {
            self.perform(batchChanges: batchChanges)
        }
    }

    func resetChanges() {
        self.insertedItems.removeAll(keepCapacity: false)
        self.deletedItems.removeAll(keepCapacity: false)
        self.updatedItems.removeAll(keepCapacity: false)
        self.movedItems.removeAll(keepCapacity: false)
    }
}
