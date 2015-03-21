import QuartzCore

public extension CADisplayLink {
    var running: Bool {
        return (self.paused == false)
    }
}