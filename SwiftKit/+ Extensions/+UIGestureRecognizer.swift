import UIKit

public extension UIGestureRecognizer {
    var isActive: Bool {
        let isActive: Bool
        switch self.state {
        case .Began, .Changed:
            isActive = true
        case .Possible, .Cancelled, .Failed, .Ended:
            isActive = false
        }
        return isActive
    }

    var location: CGPoint {
        return self.locationInView(self.view)
    }
    
    @IBInspectable
    var isKeyWindowGesture: Bool {
        get {
            return (self.view != nil) && (self.view == UIWindow.applicationKeyInstance)
        }
        set(newValue) {
            if newValue == true && self.view == nil {
                UIWindow
                    .applicationKeyWindow()?
                    .add(gestureRecognizer: self)
            }
        }
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
    
    func add(#gestureView: UIView?) -> Self {
        if let view = gestureView {
            view.addGestureRecognizer(self)
        }
        return self
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
    
    func location(#subview: UIView) -> CGPoint {
        return subview.convert(point: self.location, fromView: self.view)
    }
    
    func removeGestureRecognizer() {
        self.view?.removeGestureRecognizer(self)
    }
    
    func set(#delegate: UIGestureRecognizerDelegate?) -> Self {
        self.delegate = delegate
        return self
    }
}