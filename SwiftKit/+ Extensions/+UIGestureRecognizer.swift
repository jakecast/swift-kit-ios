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
    
    @IBOutlet
    var priorityGestureRecognizers: [UIGestureRecognizer]! {
        get {
            return []
        }
        set(newValue) {
            newValue.each { self.requireGestureRecognizerToFail($0) }
        }
    }

    func cancelGesture() {
        if self.enabled == true {
            self.enabled = false
            self.enabled = true
        }
    }

    func isWithin(#view: UIView?) -> Bool {
        let isWithinView: Bool
        if let subview = view {
            isWithinView = CGRectContainsPoint(subview.bounds, subview.convert(point: self.location, fromView: self.view))
        }
        else {
            isWithinView = false
        }
        return isWithinView
    }
    
    func isWithin(#views: [UIView?]) -> Bool {
        return views.reduce(false, combine: { (bool, view) -> Bool in return bool || self.isWithin(view: view) })
    }
}