import UIKit

public class AnimatedTransition: NSObject, UIViewControllerAnimatedTransitioning {
    public let transitionStyle: TransitionStyle

    public weak var transitionContext: UIViewControllerContextTransitioning?

    public static var transitionDuration: NSTimeInterval {
        return 0.35
    }

    public var duration: NSTimeInterval {
        let duration: NSTimeInterval
        if let context = self.transitionContext {
            duration = self.transitionDuration(context)
        }
        else {
            duration = AnimatedTransition.transitionDuration
        }
        return duration
    }

    public var isPresenting: Bool {
        return (self.transitionStyle == TransitionStyle.Presenting)
    }

    public var isDismissing: Bool {
        return (self.transitionStyle == TransitionStyle.Dismissing)
    }

    public var fromViewController: UIViewController? {
        return self.transitionContext?.viewControllerForKey(UITransitionContextFromViewControllerKey)
    }

    public var toViewController: UIViewController? {
        return self.transitionContext?.viewControllerForKey(UITransitionContextToViewControllerKey)
    }

    public var fromView: UIView? {
        return self.transitionContext?.viewForKey(UITransitionContextFromViewKey)
    }

    public var toView: UIView? {
        return self.transitionContext?.viewForKey(UITransitionContextToViewKey)
    }

    public var transitionView: UIView? {
        return self.transitionContext?.containerView()
    }

    public required init(transitionStyle: TransitionStyle) {
        self.transitionStyle = transitionStyle
    }

    public func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        self.transitionContext = transitionContext
        switch (self.isPresenting, self.isDismissing) {
        case (true, false):
            self.animatePresentation(transitionContext, transitionView: transitionContext.containerView())
        case (false, true):
            self.animateDismissal(transitionContext, transitionView: transitionContext.containerView())
        default:
            break
        }
    }

    public func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
        return AnimatedTransition.transitionDuration
    }

    public func animatePresentation(transitionContext: UIViewControllerContextTransitioning, transitionView: UIView) {}
    public func animateDismissal(transitionContext: UIViewControllerContextTransitioning, transitionView: UIView) {}
    public func animationEnded(transitionCompleted: Bool) {}
}
