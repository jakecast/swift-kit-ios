import UIKit

public extension UICollectionViewFlowLayout {
    var canScrollCollectionView: Bool {
        var canScrollCollectionView: Bool?
        if self.scrollDirection == UICollectionViewScrollDirection.Vertical {
            canScrollCollectionView = self.collectionView?.contentSize.height > self.collectionView?.bounds.height
        }
        else if self.scrollDirection == UICollectionViewScrollDirection.Vertical {
            canScrollCollectionView = self.collectionView?.contentSize.width > self.collectionView?.bounds.width
        }
        return canScrollCollectionView ?? false
    }
    
    func scrollPositionForElement(#kind: String, indexPath: NSIndexPath, scrollPosition: UICollectionViewScrollPosition) -> CGPoint? {
        var scrollContentOffset: CGPoint?
        if self.canScrollCollectionView == true {
            if let elementAttributes = self.layoutAttributesForSupplementaryViewOfKind(kind, atIndexPath: indexPath) {
                scrollContentOffset = self.scrollPositionForAttributes(attrs: elementAttributes, scrollPosition: scrollPosition)
            }
        }
        return scrollContentOffset
    }

    func scrollPositionForItem(#indexPath: NSIndexPath, scrollPosition: UICollectionViewScrollPosition) -> CGPoint? {
        var scrollContentOffset: CGPoint?
        if self.canScrollCollectionView == true {
            if let cellAttributes = self.layoutAttributes(indexPath: indexPath) {
                scrollContentOffset = self.scrollPositionForAttributes(attrs: cellAttributes, scrollPosition: scrollPosition)
            }
        }
        return scrollContentOffset
    }
    
    func scrollPositionForAttributes(#attrs: UICollectionViewLayoutAttributes, scrollPosition: UICollectionViewScrollPosition) -> CGPoint {
        let scrollContentOffset: CGPoint
        if let collectionView = self.collectionView {
            let proposedContentOffset: CGPoint
            switch scrollPosition {
            case UICollectionViewScrollPosition.Top where collectionView.contentSize.height > collectionView.bounds.height:
                proposedContentOffset = CGPoint(
                    x: attrs.minX - (self.minimumInteritemSpacing / 2) - self.contentInset.left,
                    y: attrs.minY - (self.minimumLineSpacing / 2) - self.contentInset.top
                )
            case UICollectionViewScrollPosition.Bottom where collectionView.contentSize.height > collectionView.bounds.height:
                proposedContentOffset = CGPoint(
                    x: attrs.minX - (self.minimumInteritemSpacing / 2) - self.contentInset.left,
                    y: attrs.minY - collectionView.bounds.height + attrs.height - (self.minimumLineSpacing / 2) - self.contentInset.bottom
                )
            default:
                proposedContentOffset = collectionView.contentOffset
            }
            scrollContentOffset = CGPoint(
                x: max(collectionView.minContentOffsetX, min(collectionView.maxContentOffsetX, proposedContentOffset.x)),
                y: max(collectionView.minContentOffsetY, min(collectionView.maxContentOffsetY, proposedContentOffset.y))
            )
        }
        else {
            scrollContentOffset = CGPointZero
        }
        return scrollContentOffset
    }
}
