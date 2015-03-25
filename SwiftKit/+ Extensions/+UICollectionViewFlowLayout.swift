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

    func scrollPositionForItem(#indexPath: NSIndexPath, scrollPosition: UICollectionViewScrollPosition) -> CGPoint? {
        var scrollContentOffset: CGPoint?
        if self.canScrollCollectionView == true {
            if let cellAttributes = self.layoutAttributes(indexPath: indexPath), let collectionView = self.collectionView {
                switch scrollPosition {
                case UICollectionViewScrollPosition.Top where indexPath == NSIndexPath(forItem: 0, inSection: 0):
                    scrollContentOffset = CGPoint(
                        x: 0 - self.contentInset.left,
                        y: 0 - self.contentInset.top
                    )
                case UICollectionViewScrollPosition.Top where collectionView.contentSize.height > collectionView.bounds.height:
                    scrollContentOffset = CGPoint(
                        x: cellAttributes.minX - (self.minimumInteritemSpacing / 2) - self.contentInset.left,
                        y: cellAttributes.minY - (self.minimumLineSpacing / 2) - self.contentInset.top
                    )
                case UICollectionViewScrollPosition.Bottom where collectionView.contentSize.height > collectionView.bounds.height:
                    scrollContentOffset = CGPoint(
                        x: cellAttributes.minX - (self.minimumInteritemSpacing / 2) - self.contentInset.left,
                        y: cellAttributes.minY - collectionView.bounds.height + cellAttributes.height - (self.minimumLineSpacing / 2) - self.contentInset.bottom
                    )
                default:
                    scrollContentOffset = collectionView.contentOffset
                }
            }
            if let contentOffset = scrollContentOffset, let collectionView = self.collectionView {
                scrollContentOffset = CGPoint(
                    x: max(collectionView.minContentOffsetX, min(collectionView.maxContentOffsetX, contentOffset.x)),
                    y: max(collectionView.minContentOffsetY, min(collectionView.maxContentOffsetY, contentOffset.y))
                )
            }
        }
        return scrollContentOffset
    }
}
