import UIKit

public extension UICollectionViewFlowLayout {
    func scrollPositionForItem(#indexPath: NSIndexPath, scrollPosition: UICollectionViewScrollPosition) -> CGPoint? {
        var scrollPoint: CGPoint?
        if let cellAttributes = self.layoutAttributes(indexPath: indexPath), let collectionView = self.collectionView {
            switch scrollPosition {
            case UICollectionViewScrollPosition.Top where collectionView.contentSize.height > collectionView.bounds.height:
                scrollPoint = CGPoint(
                    x: cellAttributes.minX - (self.minimumInteritemSpacing / 2) - self.contentInset.left,
                    y: cellAttributes.minY - (self.minimumLineSpacing / 2) - self.contentInset.top
                )
            case UICollectionViewScrollPosition.Top where collectionView.contentSize.height <= collectionView.bounds.height:
                scrollPoint = collectionView.contentOffset
            case UICollectionViewScrollPosition.Bottom where collectionView.contentSize.height > collectionView.bounds.height:
                scrollPoint = CGPoint(
                    x: cellAttributes.minX - (self.minimumInteritemSpacing / 2) - self.contentInset.left,
                    y: cellAttributes.minY - collectionView.bounds.height + cellAttributes.height - (self.minimumLineSpacing / 2) - self.contentInset.bottom
                )
            case UICollectionViewScrollPosition.Bottom where collectionView.contentSize.height <= collectionView.bounds.height:
                scrollPoint = collectionView.contentOffset
            default:
                break
            }
        }
        else {
            scrollPoint = nil
        }
        return scrollPoint
    }
}
