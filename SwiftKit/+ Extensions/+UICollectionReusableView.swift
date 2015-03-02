import UIKit


public extension UICollectionReusableView {
    var collectionView: UICollectionView? {
        return (self.superview is UICollectionView) ? (self.superview as! UICollectionView) : nil
    }

    var collectionViewLayout: UICollectionViewLayout? {
        return self.collectionView?.collectionViewLayout
    }

    var collectionViewFlowLayout: UICollectionViewFlowLayout? {
        return self.collectionViewLayout as? UICollectionViewFlowLayout
    }
}