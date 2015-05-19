import UIKit

public class NetworkSessionDelegate: NSObject {
    lazy var delegateQueue = NSOperationQueue(name: "com.network-kit.session-delegate", serial: false)
    lazy var requestDictionary: [Int:NetworkRequestDelegate] = [:]

    subscript(task: NSURLSessionTask) -> NetworkRequestDelegate? {
        get {
            var requestDelegate: NetworkRequestDelegate?
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