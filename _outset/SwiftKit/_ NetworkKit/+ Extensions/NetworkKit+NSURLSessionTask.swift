import UIKit

extension NSURLSessionTask {
    private struct Extension {
        static var onceToken: dispatch_once_t = 0
    }

    class func swizzleSessionTasks() {
        NSOperationQueue.dispatchOnce(&Extension.onceToken) {
            method_exchangeImplementations(
                class_getInstanceMethod(self.classForCoder(), Selector("resume")),
                class_getInstanceMethod(self.classForCoder(), Selector("taskWillResume"))
            )
            method_exchangeImplementations(
                class_getInstanceMethod(self.classForCoder(), Selector("suspend")),
                class_getInstanceMethod(self.classForCoder(), Selector("taskWillSuspend"))
            )
            method_exchangeImplementations(
                class_getInstanceMethod(self.classForCoder(), Selector("cancel")),
                class_getInstanceMethod(self.classForCoder(), Selector("taskWillCancel"))
            )
        }
    }

    public func taskWillResume() {
        let oldState = self.state
        self.taskWillResume()

        if oldState != NSURLSessionTaskState.Running {
            NetworkActivity
                .sharedActivity()?
                .requestDidBegin()
        }
    }

    public func taskWillSuspend() {
        let oldState = self.state
        self.taskWillSuspend()

        if oldState != NSURLSessionTaskState.Suspended {
            NetworkActivity
                .sharedActivity()?
                .requestDidEnd()
        }
    }

    public func taskWillCancel() {
        let oldState = self.state
        self.taskWillCancel()

        if oldState == NSURLSessionTaskState.Running {
            NetworkActivity
                .sharedActivity()?
                .requestDidEnd()
        }
    }
}