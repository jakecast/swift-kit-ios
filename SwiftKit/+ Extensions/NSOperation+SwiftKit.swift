import Foundation

public extension NSOperation {
    public func runOperation() -> Self {
        self.start()
        return self
    }

    public func completeOperation() -> Self {
        self.waitUntilFinished()
        return self
    }
}
