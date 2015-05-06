import Foundation

public extension NSURLSessionTask {
    var isCancelled: Bool {
        return (self.state == NSURLSessionTaskState.Canceling)
    }
}