import UIKit

public extension UIView {
    class func animate(
        #duration: NSTimeInterval,
        delay: NSTimeInterval=0,
        options: UIViewAnimationOptions=UIViewAnimationOptions.allZeros,
        setupBlock: ((Void)->(Void))?=nil,
        animationBlock: ((Void)->(Void)),
        completionBlock: ((Bool)->(Void))?=nil
    ) {
        setupBlock?()
        self.animateWithDuration(duration, delay: delay, options: options, animations: animationBlock, completion: completionBlock)
    }
    
    class func animateKeyframes(
        #duration: NSTimeInterval,
        delay: NSTimeInterval=0,
        options: UIViewKeyframeAnimationOptions=UIViewKeyframeAnimationOptions.allZeros,
        setupBlock: ((Void)->(Void))?=nil,
        animationsBlock: ((Void)->(Void)),
        completionBlock: ((Bool)->(Void))?=nil
    ) {
        setupBlock?()
        self.animateKeyframesWithDuration(duration, delay: delay, options: options, animations: animationsBlock, completion: completionBlock)
    }
    
    class func addKeyframe(#relativeStartTime: Double, relativeDuration: Double, keyframeBlock: ((Void)->(Void))) {
        self.addKeyframeWithRelativeStartTime(relativeStartTime, relativeDuration: relativeDuration, animations: keyframeBlock)
    }

    var isAnimating: Bool {
        return (self.animationKeys != nil) ? self.animationKeys?.count != 0 : false
    }

    var isDisplayed: Bool {
        return (self.window != nil)
    }
    
    var shouldRasterize: Bool {
        get {
            return self.layer.shouldRasterize
        }
        set(newValue) {
            self.layer.shouldRasterize = newValue
        }
    }
    
    var rasterizationScale: CGFloat {
        get {
            return self.layer.rasterizationScale
        }
        set(newValue) {
            self.layer.rasterizationScale = newValue
        }
    }

    var minX: CGFloat {
        get {
            return self.frame.minX
        }
        set(newValue) {
            self.frame.origin = CGPoint(x: newValue, y: self.minY)
        }
    }

    var minY: CGFloat {
        get {
            return self.frame.minY
        }
        set(newValue) {
            self.frame.origin = CGPoint(x: self.minX, y: newValue)
        }
    }

    var maxX: CGFloat {
        get {
            return self.frame.maxX
        }
        set(newValue) {
            self.frame.origin = CGPoint(x: newValue - self.width, y: self.minY)
        }
    }

    var maxY: CGFloat {
        get {
            return self.frame.maxY
        }
        set(newValue) {
            self.frame.origin = CGPoint(x: self.minX, y: newValue - self.height)
        }
    }

    var origin: CGPoint {
        return self.frame.origin
    }

    var size: CGSize {
        return self.frame.size
    }

    var height: CGFloat {
        get {
            return self.frame.height
        }
        set(newValue) {
            self.frame.size = CGSize(width: self.width, height: newValue)
        }
    }

    var width: CGFloat {
        get {
            return self.frame.width
        }
        set(newValue) {
            self.frame.size = CGSize(width: newValue, height: self.height)
        }
    }
    
    var animationKeys: [AnyObject]? {
        return self.layer.animationKeys()
    }

    func add(#subview: UIView) {
        self.addSubview(subview)
    }

    func add(#superview: UIView) {
        superview.add(subview: self)
    }

    func insert(#superview: UIView, belowView: UIView?) {
        if let below = belowView {
            superview.insertSubview(self, belowSubview: below)
        }
        else {
            superview.add(subview: self)
        }
    }

    func insert(#superview: UIView, aboveView: UIView?) {
        if let above = aboveView {
            superview.insertSubview(self, aboveSubview: above)
        }
        else {
            superview.add(subview: self)
        }
    }

    func convert(#point: CGPoint, fromView: UIView?) -> CGPoint {
        return self.convertPoint(point, fromView: fromView)
    }

    func convert(#rect: CGRect, fromView: UIView?) -> CGRect {
        return self.convertRect(rect, fromView: fromView)
    }
    
    func removeAllAnimations() {
        self.layer.removeAllAnimations()
    }
    
    func snapshotView(#rect: CGRect, afterUpdates: Bool=false) -> UIView {
        return self.resizableSnapshotViewFromRect(rect, afterScreenUpdates: afterUpdates, withCapInsets: UIEdgeInsetsZero)
    }
}
