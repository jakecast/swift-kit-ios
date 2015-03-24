import CoreData
import UIKit

public class CollectionFetchedResults: NSFetchedResultsController, NSFetchedResultsControllerDelegate {
    var contextObserver: NotificationObserver?
    var focusedObjectID: NSManagedObjectID?
    var focusedObjectPosition: UICollectionViewScrollPosition?

    weak var collectionView: UICollectionView?

    lazy var insertedItems: [NSIndexPath] = []
    lazy var deletedItems: [NSIndexPath] = []
    lazy var updatedItems: [NSIndexPath] = []
    lazy var movedItems: [(NSIndexPath, NSIndexPath)] = []

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
        self.mainQueue.dispatch {
            self.collectionView?.perform(
                batchChanges: {
                    self.collectionView?.insertItemsAtIndexPaths(self.insertedItems)
                    self.collectionView?.reloadItemsAtIndexPaths(self.updatedItems)
                    self.collectionView?.deleteItemsAtIndexPaths(self.deletedItems)
                    
                    for (oldIndexPath, newIndexPath) in self.movedItems {
                        self.collectionView?.moveItemAtIndexPath(oldIndexPath, toIndexPath: newIndexPath)
                    }
                },
                completionHandler: {(_) in
                    self.scrollToFocusedObject(animated: true)
                }
            )
            self.resetChanges()
        }
    }

    public func controllerDidInvalidateContent(notification: NSNotification!) {
        if let invalidatedObjects = notification[NSInvalidatedAllObjectsKey] as? [NSManagedObjectID] {
            self.mainQueue.dispatch {
                if let invalidIndexPaths = self.indexPathsForObjects(objectIdentifiers: invalidatedObjects) {
                    self.collectionView?.perform(batchChanges: { self.collectionView?.reloadItemsAtIndexPaths(invalidIndexPaths) })
                }
            }
        }
    }
    
    public func setFocusedObjectID(
        #objectID: NSManagedObjectID,
        scrollPosition: UICollectionViewScrollPosition,
        animated: Bool
    ) {
        self.focusedObjectID = objectID
        self.focusedObjectPosition = scrollPosition
        self.scrollToFocusedObject(animated: animated)
    }
    
    func scrollToFocusedObject(#animated: Bool) {
        if let focusedIndexPath = self[self.managedObjectContext[self.focusedObjectID]] as? NSIndexPath, let scrollPosition = self.focusedObjectPosition {
            self.focusedObjectID = nil
            self.focusedObjectPosition = nil
            self.collectionView?.scroll(indexPath: focusedIndexPath, scrollPosition: scrollPosition, animated: animated)
        }
    }

    func resetChanges() {
        self.insertedItems.removeAll(keepCapacity: false)
        self.deletedItems.removeAll(keepCapacity: false)
        self.updatedItems.removeAll(keepCapacity: false)
        self.movedItems.removeAll(keepCapacity: false)
    }
}
