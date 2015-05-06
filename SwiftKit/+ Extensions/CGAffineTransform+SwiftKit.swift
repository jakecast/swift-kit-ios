import QuartzCore

public extension CGAffineTransform {
    init(transform: CGAffineTransform, rotation: CGFloat, scale: CGFloat) {
        self = CGAffineTransform()
        self.apply(rotation: rotation)
        self.apply(scale: scale)
    }
    
    init(rotation: CGFloat) {
        self = CGAffineTransformMakeRotation(rotation)
    }

    init(scale: CGFloat) {
        self = CGAffineTransformMakeScale(scale, scale)
    }
    
    mutating func apply(#rotation: CGFloat) {
        self = CGAffineTransformRotate(self, rotation)
    }
    
    mutating func apply(#scale: CGFloat) {
        self = CGAffineTransformScale(self, scale, scale)
    }
}
