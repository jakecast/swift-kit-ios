import UIKit

public class InteractiveTransition: AnimatedTransition, UIViewControllerInteractiveTransitioning {
    public var isInteractive: Bool = false
    
    public convenience init(transitionStyle: TransitionStyle, isInteractive: Bool) {
        self.init(transitionStyle: transitionStyle)
        self.isInteractive = isInteractive
    }
    
    public func set(#isInteractive: Bool) -> Self {
        self.isInteractive = isInteractive
        return self
    }
    
    public override func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        if self.isInteractive == false {
            super.animateTransition(transitionContext)
        }
        else {
            self.startInteractiveTransition(transitionContext)
        }
    }
    
    public override func finishCancellation(#transitionContext: UIViewControllerContextTransitioning) {
        if self.wasCancelled == true {
            if self.isInteractive == true {
                transitionContext.cancelInteractiveTransition()
            }
            transitionContext.completeTransition(false)
        }
    }
    
    public override func finishTransition(#transitionContext: UIViewControllerContextTransitioning) {
        if self.wasCancelled == false {
            if self.isInteractive == true {
                transitionContext.finishInteractiveTransition()
            }
            transitionContext.completeTransition(true)
        }
    }
    
    public func startInteractiveTransition(transitionContext: UIViewControllerContextTransitioning) {
        self.transitionContext = transitionContext
        switch (self.isPresenting, self.isDismissing) {
        case (true, false):
            self.startInteractivePresentation(transitionContext, transitionView: transitionContext.containerView())
        case (false, true):
            self.startInteractiveDismissal(transitionContext, transitionView: transitionContext.containerView())
        default:
            break
        }
    }
    
    public func completionCurve() -> UIViewAnimationCurve {
        return UIViewAnimationCurve.Linear
    }
    
    public func completionSpeed() -> CGFloat {
        return 1.0
    }
    
    public func startInteractivePresentation(transitionContext: UIViewControllerContextTransitioning, transitionView: UIView) {}
    public func startInteractiveDismissal(transitionContext: UIViewControllerContextTransitioning, transitionView: UIView) {}
}