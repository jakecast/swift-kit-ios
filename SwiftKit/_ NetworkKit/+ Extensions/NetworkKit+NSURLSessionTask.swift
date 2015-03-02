import UIKit

extension NSURLSessionTask {
    struct Class {
        static var onceToken: dispatch_once_t = 0
    }

    class func swizzleSessionTasks() {
        NSOperationQueue.once(&Class.onceToken) {
            method_exchangeImplementations(
                class_getInstanceMethod(self.classForCoder(), Selector("resume")),
                class_getInstanceMethod(self.classForCoder(), Selector("taskWillResume"))
            )
            method_exchangeImplementations(
                class_getInstanceMethod(self.classForCoder(), Selector("suspend")),
                class_getInstanceMethod(self.classForCoder(), Selector("taskWillSuspend"))
            )
        }
    }

    public func taskWillResume() {
        let oldState = self.state
        self.taskWillResume()

        if oldState != NSURLSessionTaskState.Running {
            NKNetworkActivity
                .sharedActivity()?
                .requestDidBegin()
        }
    }

    public func taskWillSuspend() {
        let oldState = self.state
        self.taskWillSuspend()

        if oldState != NSURLSessionTaskState.Suspended {
            NKNetworkActivity
                .sharedActivity()?
                .requestDidEnd()
        }
    }
}