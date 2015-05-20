import Foundation

public extension NSOperation {
    public func startOperation() -> Self {
        self.start()
        return self
    }
}
