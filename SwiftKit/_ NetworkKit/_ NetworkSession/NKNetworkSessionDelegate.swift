import UIKit

public class NKNetworkSessionDelegate: NSObject {
    lazy var delegateQueue = NSOperationQueue(serial: false)
    lazy var requestDictionary: [Int:NKNetworkRequestDelegate] = [:]

    subscript(task: NSURLSessionTask) -> NKNetworkRequestDelegate? {
        get {
            var requestDelegate: NKNetworkRequestDelegate?
            self.delegateQueue.dispatchSync {
                requestDelegate = self.requestDictionary[task.taskIdentifier]
            }
            return requestDelegate
        }
        set(newValue) {
            self.delegateQueue.dispatchBarrierAsync {
                self.requestDictionary[task.taskIdentifier] = newValue
            }
        }
    }
}