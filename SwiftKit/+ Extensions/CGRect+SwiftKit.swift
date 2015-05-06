import UIKit

public extension CGRect {
    static let null: CGRect = CGRectZero
    
    init(size: CGSize) {
        self.init(origin: CGPoint.null, size: size)
    }
    
    var center: CGPoint {
        return CGPoint(x: CGRectGetMidX(self), y: CGRectGetMidY(self))
    }
}