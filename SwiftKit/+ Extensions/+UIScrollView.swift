import UIKit

public extension UIScrollView {
    var contentOffsetMinY: CGFloat {
        return -self.contentInset.top
    }

    var contentOffsetMaxY: CGFloat {
        return max(self.contentSize.height, self.bounds.height) - self.bounds.height + self.contentInset.bottom
    }
}