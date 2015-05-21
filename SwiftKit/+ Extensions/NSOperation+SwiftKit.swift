import Foundation

public extension NSOperation {
    public func startOperation() -> Self {
        self.start()
        return self
    }

    public func waitOperation() -> Self {
        self.waitUntilFinished()
        return self
    }
}
