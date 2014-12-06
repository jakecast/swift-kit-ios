import UIKit


extension URLSessionTask {
    internal class func swizzleSessionTasks() {
        struct Dispatch {
            static var onceToken: DispatchOnceToken = 0
        }

        OperationQueue.once(&Dispatch.onceToken) {
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

        if oldState != URLSessionTaskState.Running {
            NetworkActivity.sharedInstance?.requestDidBegin()
        }
    }

    public func taskWillSuspend() {
        let oldState = self.state
        self.taskWillSuspend()

        if oldState != URLSessionTaskState.Suspended {
            NetworkActivity.sharedInstance?.requestDidEnd()
        }
    }
}