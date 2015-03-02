import UIKit

public class NKNetworkSessionDelegate: NSObject {
    lazy var delegateQueue = NSOperationQueue(serial: false)
    lazy var requestDictionary: [Int:NKNetworkRequestDelegate] = [:]

    subscript(task: NSURLSessionTask) -> NKNetworkRequestDelegate? {
        get {
            var requestDelegate: NKNetworkRequestDelegate? = nil
            self.delegateQueue.sync {
                requestDelegate = self.requestDictionary[task.taskIdentifier]
            }
            return requestDelegate
        }
        set(newValue) {
            self.delegateQueue.barrierAsync {
                self.requestDictionary[task.taskIdentifier] = newValue
            }
        }
    }
}