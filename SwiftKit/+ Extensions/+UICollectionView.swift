import UIKit

public extension UICollectionView {
    var collectionViewFlowLayout: UICollectionViewFlowLayout? {
        return self.collectionViewLayout as? UICollectionViewFlowLayout
    }

    var lastSection: Int {
        return self.numberOfSections() - 1
    }

    var minContentOffsetX: CGFloat {
        return 0 - self.contentInset.left
    }

    var minContentOffsetY: CGFloat {
        return 0 - self.contentInset.top
    }

    var maxContentOffsetX: CGFloat {
        return self.contentSize.width - self.bounds.width + self.contentInset.right
    }
    
    var maxContentOffsetY: CGFloat {
        return self.contentSize.height - self.bounds.height + self.contentInset.bottom
    }
    
    var minimumLineSpacing: CGFloat {
        return self.collectionViewFlowLayout?.minimumLineSpacing ?? 0
    }

    var minimumInteritemSpacing: CGFloat {
        return self.collectionViewFlowLayout?.minimumInteritemSpacing ?? 0
    }

    var scrollDirection: UICollectionViewScrollDirection? {
        return self.collectionViewFlowLayout?.scrollDirection
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

    func getCell(#indexPath: NSIndexPath?) -> UICollectionViewCell? {
        var collectionCell: UICollectionViewCell?
        if let path = indexPath {
            collectionCell = self.cellForItemAtIndexPath(path)
        }
        else {
            collectionCell = nil
        }
        return collectionCell
    }

    func getIndexPath(#point: CGPoint) -> NSIndexPath? {
        return self.indexPathForItemAtPoint(point)
    }

    func isDisplaying(#itemIndexPath: NSIndexPath) -> Bool {
        return contains(self.visibleItemsIndexPaths, itemIndexPath)
    }

    func perform(#batchChanges: ((Void)->(Void)), completionHandler: ((Bool)->(Void))?=nil) {
        self.performBatchUpdates(batchChanges, completion: completionHandler)
    }
    
    func reloadAllSections() {
        self.reloadSections(range: NSRange(location: 0, length: self.numberOfSections()))
    }
    
    func reloadSections(#range: NSRange) {
        self.reloadSections(NSIndexSet(indexesInRange: range))
    }
    
    func scroll(
        #indexPath: NSIndexPath,
        scrollPosition: UICollectionViewScrollPosition,
        animated: Bool
    ) {
        if let scrollPosition = self.collectionViewFlowLayout?.scrollPositionForItem(indexPath: indexPath, scrollPosition: scrollPosition) {
            self.set(contentOffset: scrollPosition, animated: animated)
        }
        else {
            self.delegate?.scrollViewDidEndScrollingAnimation?(self)
        }
    }

    func selectItem(#indexPath: NSIndexPath, animated: Bool, scrollPosition: UICollectionViewScrollPosition=UICollectionViewScrollPosition.None) {
        self.selectItemAtIndexPath(indexPath, animated: animated, scrollPosition: scrollPosition)
    }

    func set(#contentOffset: CGPoint, animated: Bool) {
        self.setContentOffset(contentOffset, animated: animated)
    }
    
    subscript(index: NSObject?) -> UICollectionViewCell? {
        var collectionCell: UICollectionViewCell?
        switch index {
        case let indexPath as NSIndexPath:
            collectionCell = self.getCell(indexPath: indexPath)
        default:
            collectionCell = nil
        }
        return collectionCell
    }
}