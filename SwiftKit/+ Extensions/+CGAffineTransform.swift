import QuartzCore

public extension CGAffineTransform {
    init(rotation: CGFloat) {
        self = CGAffineTransformMakeRotation(rotation)
    }

    init(scale: CGFloat) {
        self = CGAffineTransformMakeScale(scale, scale)
    }
}
