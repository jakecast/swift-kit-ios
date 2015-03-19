import UIKit

public extension UICollectionView {
    var minimumLineSpacing: CGFloat {
        return (self.collectionViewLayout as? UICollectionViewFlowLayout)?.minimumLineSpacing ?? 0
    }

    var minimumInteritemSpacing: CGFloat {
        return (self.collectionViewLayout as? UICollectionViewFlowLayout)?.minimumInteritemSpacing ?? 0
    }

    var visibleItemsIndexPaths: [NSIndexPath] {
        return self.indexPathsForVisibleItems()
            .map { return $0 as? NSIndexPath }
            .filter { return $0 != nil }
            .map { return $0! }
    }

    func deselectAll() {
        self.allowsSelection = false
        self.allowsSelection = true
    }

    func getCell(#point: CGPoint) -> UICollectionViewCell? {
        var cell: UICollectionViewCell?
        if let indexPath = self.indexPathForItemAtPoint(point) {
            cell = self.getCell(indexPath: indexPath)
        }
        else {
            cell = nil
        }
        return cell
    }

    func getCell(#indexPath: NSIndexPath) -> UICollectionViewCell? {
        return self.cellForItemAtIndexPath(indexPath)
    }

    func getIndexPath(#point: CGPoint) -> NSIndexPath? {
        return self.indexPathForItemAtPoint(point)
    }

    func dequeueCell(
        #reuseIdentifier: String,
        indexPath: NSIndexPath
    ) -> UICollectionViewCell {
        return self.dequeueReusableCellWithReuseIdentifier(
            reuseIdentifier,
            forIndexPath: indexPath
        ) as! UICollectionViewCell
    }

    func dequeueSupplementaryView(
        #elementKind: String,
        reuseIdentifier: String,
        indexPath: NSIndexPath
    ) -> UICollectionReusableView {
        return self.dequeueReusableSupplementaryViewOfKind(
            elementKind,
            withReuseIdentifier: reuseIdentifier,
            forIndexPath: indexPath
        ) as! UICollectionReusableView
    }

    func isDisplaying(#itemIndexPath: NSIndexPath) -> Bool {
        return contains(self.visibleItemsIndexPaths, itemIndexPath)
    }

    func perform(#batchChanges: (Void -> Void), completionHandler: (Bool -> Void)?=nil) {
        self.performBatchUpdates(batchChanges, completion: completionHandler)
    }
    
    func reloadAllSections() {
        self.reloadSections(range: NSRange(location: 0, length: self.numberOfSections()))
    }
    
    func reloadSections(#range: NSRange) {
        self.reloadSections(NSIndexSet(indexesInRange: range))
    }
}