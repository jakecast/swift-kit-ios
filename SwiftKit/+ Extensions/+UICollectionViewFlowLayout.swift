import UIKit

public extension UICollectionViewFlowLayout {
    var contentBounds: CGRect {
        let contentBounds: CGRect
        if let collectionView = self.collectionView {
            switch self.scrollDirection {
            case UICollectionViewScrollDirection.Vertical:
                contentBounds = (collectionView.contentSize.height < collectionView.bounds.height) ? CGRect(size: collectionView.contentSize) : collectionView.bounds
            case UICollectionViewScrollDirection.Horizontal:
                contentBounds = (collectionView.contentSize.width < collectionView.bounds.width) ? CGRect(size: collectionView.contentSize) : collectionView.bounds
            }
        }
        else {
            contentBounds = CGRectZero
        }
        return contentBounds
    }
}
