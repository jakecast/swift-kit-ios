import UIKit

public class NetworkActivity {
    private struct Extension {
        static var instance: NetworkActivity?
    }

    class var sharedInstance: NetworkActivity? {
        return self.sharedActivity()
    }

    class func sharedActivity() -> NetworkActivity? {
        return Extension.instance
    }

    let application: UIApplication

    var activityCount: Int
    
    var mainQueue: NSOperationQueue {
        return NSOperationQueue.mainQueue()
    }

    var isNetworkIndicatorVisible: Bool {
        return (self.activityCount != 0)
    }

    var setNetworkActivityIndicator: dispatch_block_t {
        return {
            self.application.networkActivityIndicatorVisible = self.isNetworkIndicatorVisible
        }
    }

    public required init(application: UIApplication) {
        self.application = application
        self.activityCount = 0

        Extension.instance = self
        NSURLSessionTask.swizzleSessionTasks()
    }

    func setActivityCount(#newCount: Int) {
        self.application.synced {
            self.activityCount = max(0, newCount)
        }
        self.mainQueue.dispatchAsync {
            self.updateNetworkActivityIndicator()
        }
    }

    func updateNetworkActivityIndicator() {
        if self.isNetworkIndicatorVisible == false {
            self.mainQueue.dispatchAfterDelay(0.17, self.setNetworkActivityIndicator)
        }
        else {
            self.mainQueue.dispatchAsync(self.setNetworkActivityIndicator)
        }
    }

    func requestDidBegin() {
        self.setActivityCount(newCount: self.activityCount + 1)
    }

    func requestDidEnd() {
        self.setActivityCount(newCount: self.activityCount - 1)
    }
}