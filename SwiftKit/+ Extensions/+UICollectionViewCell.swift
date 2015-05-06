import UIKit

public extension UICollectionViewCell {
    func updateContentViewSizeIfNeeded() {
        if self.contentView.size != self.size {
            self.contentView.size = self.size
        }
    }
}
