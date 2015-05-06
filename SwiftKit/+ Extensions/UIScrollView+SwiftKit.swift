import UIKit

public extension UIScrollView {
    var contentOffsetMinY: CGFloat {
        return -self.contentInset.top
    }

    var contentOffsetMaxY: CGFloat {
        return max(self.contentSize.height, self.bounds.height) - self.bounds.height + self.contentInset.bottom
    }
    
    var decelerationSpeed: DecelerationSpeed {
        get {
            return DecelerationSpeed(rawValue: self.decelerationRate) ?? DecelerationSpeed.Normal
        }
        set(newValue) {
            self.decelerationRate = newValue.rawValue
        }
    }

    var scrollableContentWidth: CGFloat {
        return max((self.bounds.width - self.contentInset.left), self.contentSize.width + self.contentInset.bottom)
    }

    var scrollableContentHeight: CGFloat {
        return max((self.bounds.height - self.contentInset.top), self.contentSize.height + self.contentInset.bottom)
    }

    var overscroll: CGPoint {
        return CGPoint(
            x: (self.contentOffset.x + self.bounds.width) - self.scrollableContentWidth,
            y: (self.contentOffset.y + self.bounds.height) - self.scrollableContentHeight
        )
    }
}
