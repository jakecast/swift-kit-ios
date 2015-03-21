import UIKit

public extension UIGestureRecognizer {
    var isActive: Bool {
        let isActive: Bool
        switch self.state {
        case .Began, .Changed, .Ended:
            isActive = true
        case .Possible, .Cancelled, .Failed:
            isActive = false
        }
        return isActive
    }

    var location: CGPoint {
        return self.locationInView(self.view)
    }

    func cancelGesture() {
        if self.enabled == true {
            self.enabled = false
            self.enabled = true
        }
    }

    func isWithin(#view: UIView) -> Bool {
        let viewRect = self.view?.convertRect(view.frame, fromView: view) ?? CGRectZero
        return CGRectContainsPoint(viewRect, self.location)
    }
}