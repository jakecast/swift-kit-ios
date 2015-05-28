import Foundation

public class NetworkSessionDelegate: NSObject {
    private lazy var sessionDelegateQueue = Queue.Custom(dispatch_queue_create(nil, DISPATCH_QUEUE_CONCURRENT))
    private lazy var requestDictionary: [Int:NetworkRequestDelegate] = [:]

    subscript(task: NSURLSessionTask) -> NetworkRequestDelegate? {
        get {
            var requestDelegate: NetworkRequestDelegate?
            self.sessionDelegateQueue.sync {
                requestDelegate = self.requestDictionary[task.taskIdentifier]
            }
            return requestDelegate
        }
        set(newValue) {
            self.sessionDelegateQueue.barrierAsync {
                self.requestDictionary[task.taskIdentifier] = newValue
            }
        }
    }
}