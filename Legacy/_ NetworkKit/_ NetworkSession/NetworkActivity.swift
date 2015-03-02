import UIKit

public class NetworkActivity {
    private struct Shared {
        static var activityCount: Int = 0
        static var instance: NetworkActivity? = nil
    }

    internal class var sharedInstance: NetworkActivity? {
        return Shared.instance
    }

    internal class func sharedActivity() -> NetworkActivity? {
        return self.sharedInstance
    }

    private let application: UIApplication

    private var activityCount: Int

    private var isNetworkIndicatorVisible: Bool {
        return (self.activityCount != 0)
    }
    private var setNetworkActivityIndicator: dispatch_block_t {
        return {
            self.application.networkActivityIndicatorVisible = self.isNetworkIndicatorVisible
        }
    }

    public required init(application: UIApplication) {
        self.application = application
        self.activityCount = 0

        NetworkActivity.Shared.instance = self
        NSURLSessionTask.swizzleSessionTasks()
    }

    private func setActivityCount(#newCount: Int) {
        OperationQueue.synced(self) {
            self.activityCount = max(0, newCount)
        }
        OperationQueue.mainInstance.async {
            self.updateNetworkActivityIndicator()
        }
    }

    private func updateNetworkActivityIndicator() {
        if self.isNetworkIndicatorVisible == false {
            OperationQueue.mainInstance.delay(0.17, self.setNetworkActivityIndicator)
        }
        else {
            OperationQueue.mainInstance.async(self.setNetworkActivityIndicator)
        }
    }

    internal func requestDidBegin() {
        self.setActivityCount(newCount: self.activityCount + 1)
    }

    internal func requestDidEnd() {
        self.setActivityCount(newCount: self.activityCount - 1)
    }
}
