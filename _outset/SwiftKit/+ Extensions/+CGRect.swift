import UIKit

public extension CGRect {
    init(size: CGSize) {
        self.init(origin: CGPointZero, size: size)
    }
    
    var center: CGPoint {
        return CGPoint(x: CGRectGetMidX(self), y: CGRectGetMidY(self))
    }
}