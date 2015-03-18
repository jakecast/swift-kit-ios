import UIKit

public extension UIPanGestureRecognizer {
    var translation: CGPoint {
        return (self.view != nil) ? self.translationInView(self.view!) : CGPointZero
    }

    var velocity: CGPoint {
        return self.velocityInView(self.view)
    }

    func isPanningHorizontally(ratio: CGFloat=2) -> Bool {
        return abs(self.velocity.x) > abs(self.velocity.y * ratio)
    }

    func isPanningLeft(ratio: CGFloat=2) -> Bool {
        return (-1 * self.velocity.x) > abs(self.velocity.y * ratio)
    }

    func isPanningRight(ratio: CGFloat=2) -> Bool {
        return (self.velocity.x) > abs(self.velocity.y * ratio)
    }
}