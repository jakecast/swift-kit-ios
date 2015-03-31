import UIKit

public extension UIView {
    class func animate(
        #duration: NSTimeInterval,
        delay: NSTimeInterval=0,
        options: UIViewAnimationOptions=UIViewAnimationOptions.allZeros,
        setupBlock: ((Void)->(Void))?=nil,
        animationBlock: ((Void)->(Void)),
        completionHandler: ((Bool)->(Void))?=nil
    ) {
        setupBlock?()
        self.animateWithDuration(duration, delay: delay, options: options, animations: animationBlock, completion: completionHandler)
    }
    
    class func animateKeyframes(
        #duration: NSTimeInterval,
        delay: NSTimeInterval=0,
        options: UIViewKeyframeAnimationOptions=UIViewKeyframeAnimationOptions.allZeros,
        animationsBlock: ((Void)->(Void)),
        completionHandler: ((Bool)->(Void))?=nil
    ) {
        self.animateKeyframesWithDuration(duration, delay: delay, options: options, animations: animationsBlock, completion: completionHandler)
    }
    
    class func addKeyframe(#relativeStartTime: Double, relativeDuration: Double, keyframeBlock: ((Void)->(Void))) {
        self.addKeyframeWithRelativeStartTime(relativeStartTime, relativeDuration: relativeDuration, animations: keyframeBlock)
    }

    var minX: CGFloat {
        get {
            return self.frame.minX
        }
        set(newValue) {
            self.frame.origin.x = newValue
        }
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

    var minY: CGFloat {
        return self.frame.minY
    }

    var maxX: CGFloat {
        return self.frame.maxX
    }

    var maxY: CGFloat {
        return self.frame.maxY
    }

    var height: CGFloat {
        return self.frame.height
    }

    var width: CGFloat {
        return self.frame.width
    }
    
    var animationKeys: [AnyObject]? {
        return self.layer.animationKeys()
    }

    func add(#subview: UIView) {
        self.addSubview(subview)
    }

    func convert(#point: CGPoint, fromView: UIView?) -> CGPoint {
        return self.convertPoint(point, fromView: fromView)
    }

    func convert(#rect: CGRect, fromView: UIView?) -> CGRect {
        return self.convertRect(rect, fromView: fromView)
    }
    
    func snapshotView(#rect: CGRect, afterUpdates: Bool=false) -> UIView {
        return self.resizableSnapshotViewFromRect(rect, afterScreenUpdates: afterUpdates, withCapInsets: UIEdgeInsetsZero)
    }
}
