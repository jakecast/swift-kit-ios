import UIKit

public extension CollectionView {
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
}