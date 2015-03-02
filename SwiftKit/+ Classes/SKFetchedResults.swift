import CoreData
import UIKit

public class SKFetchedResults {
    lazy var insertedItems: [NSIndexPath] = []
    lazy var deletedItems: [NSIndexPath] = []
    lazy var updatedItems: [NSIndexPath] = []
    lazy var movedItems: [(NSIndexPath, NSIndexPath)] = []

    public init() {}

    public func fetchedResultsChanged(
        #changeType: NSFetchedResultsChangeType,
        indexPath: NSIndexPath?,
        newIndexPath: NSIndexPath?
    ) {
        switch changeType {
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

    public func resetChanges() {
        self.insertedItems.removeAll(keepCapacity: false)
        self.deletedItems.removeAll(keepCapacity: false)
        self.updatedItems.removeAll(keepCapacity: false)
        self.movedItems.removeAll(keepCapacity: false)
    }

    public func update(#collectionView: UICollectionView) {
        collectionView.perform(batchChanges: {
            collectionView.insertItemsAtIndexPaths(self.insertedItems)
            collectionView.reloadItemsAtIndexPaths(self.updatedItems)
            collectionView.deleteItemsAtIndexPaths(self.deletedItems)

            for (oldIndexPath, newIndexPath) in self.movedItems {
                collectionView.moveItemAtIndexPath(oldIndexPath, toIndexPath: newIndexPath)
            }
        })
        self.resetChanges()
    }
}