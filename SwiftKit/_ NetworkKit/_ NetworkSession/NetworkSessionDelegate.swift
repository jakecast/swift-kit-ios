import UIKit

public class NetworkSessionDelegate: NSObject {
    private lazy var delegateQueue = dispatch_queue_create(nil, DISPATCH_QUEUE_CONCURRENT)
    private lazy var requestDictionary: [Int:NetworkRequestDelegate] = [:]

    subscript(task: NSURLSessionTask) -> NetworkRequestDelegate? {
        get {
            var requestDelegate: NetworkRequestDelegate?
            dispatch_sync(self.delegateQueue) {
                requestDelegate = self.requestDictionary[task.taskIdentifier]
            }
            return requestDelegate
        }
        set(newValue) {
            dispatch_barrier_async(self.delegateQueue) {
                self.requestDictionary[task.taskIdentifier] = newValue
            }
        }
    }
}