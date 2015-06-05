import CoreData
import UIKit

public class CollectionViewFetchedResultsController: NSFetchedResultsController, NSFetchedResultsControllerDelegate {
    private var focusedObjectID: NSManagedObjectID? = nil
    private var focusedObjectPosition: UICollectionViewScrollPosition? = nil

    private weak var collectionView: UICollectionView? = nil

    private lazy var insertedItems: [NSIndexPath] = []
    private lazy var deletedItems: [NSIndexPath] = []
    private lazy var updatedItems: [NSIndexPath] = []
    private lazy var movedItems: [(NSIndexPath, NSIndexPath)] = []

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
        self.setupNotifications()
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
        let collectionViewChanges = self.resetChanges()

        self.mainQueue.async {
            self.collectionView?.perform(
                batchChanges: {
                    self.collectionView?.reloadItemsAtIndexPaths(collectionViewChanges.updated)
                    self.collectionView?.insertItemsAtIndexPaths(collectionViewChanges.inserted)
                    self.collectionView?.deleteItemsAtIndexPaths(collectionViewChanges.deleted)

                    for (oldIndexPath, newIndexPath) in collectionViewChanges.moved {
                        self.collectionView?.moveItemAtIndexPath(oldIndexPath, toIndexPath: newIndexPath)
                    }
                },
                completionHandler: {(_) in
                    self.scrollToFocusedObject(animated: true)
                }
            )
        }
    }

    public func controllerDidInvalidateContent(notification: NSNotification!) {
        if let invalidatedObjects = notification[NSInvalidatedAllObjectsKey] as? [NSManagedObjectID] {
            if let invalidIndexPaths = self.indexPathsForObjects(objectIdentifiers: invalidatedObjects) {
                self.collectionView?.reloadItemsAtIndexPaths(invalidIndexPaths)
            }
        }
    }

    public func deselectObject(#objectID: NSManagedObjectID, animated: Bool) -> Self {
        if let deselectIndexPath = self.indexPath(objectIdentifier: objectID) {
            self.collectionView?.deselectItemAtIndexPath(deselectIndexPath, animated: animated)
        }
        return self
    }

    public func selectObject(#objectID: NSManagedObjectID, animated: Bool) -> Self {
        if let selectIndexPath = self.indexPath(objectIdentifier: objectID) {
            self.collectionView?.selectItem(indexPath: selectIndexPath, animated: animated)
        }
        return self
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

    private func resetChanges() -> (
        updated: [NSIndexPath],
        inserted: [NSIndexPath],
        deleted: [NSIndexPath],
        moved: [(NSIndexPath, NSIndexPath)]
    ) {
        let updatedItems = self.updatedItems
        let insertedItems = self.insertedItems
        let deletedItems = self.deletedItems
        let movedItems = self.movedItems

        self.updatedItems.removeAll(keepCapacity: false)
        self.insertedItems.removeAll(keepCapacity: false)
        self.deletedItems.removeAll(keepCapacity: false)
        self.movedItems.removeAll(keepCapacity: false)

        return (updatedItems, insertedItems, deletedItems, movedItems)
    }

    private func scrollToFocusedObject(#animated: Bool) {
        if let focusedIndexPath = self.indexPath(objectIdentifier: self.focusedObjectID), let scrollPosition = self.focusedObjectPosition {
            self.focusedObjectID = nil
            self.focusedObjectPosition = nil
            self.collectionView?.scroll(indexPath: focusedIndexPath, scrollPosition: scrollPosition, animated: animated)
        }
    }

    private func setupNotifications() {
        NotificationManager.add(
            observer: self,
            notification: NSManagedObjectContextObjectsDidChangeNotification,
            object: self.managedObjectContext,
            queue: NSOperationQueue.mainQueue(),
            function: CollectionViewFetchedResultsController.controllerDidInvalidateContent
        )
    }
}
