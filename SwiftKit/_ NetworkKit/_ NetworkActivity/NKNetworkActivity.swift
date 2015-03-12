import UIKit

public class NKNetworkActivity {
    private struct Class {
        static var instance: NKNetworkActivity?
    }

    class var sharedInstance: NKNetworkActivity? {
        return self.sharedActivity()
    }

    class func sharedActivity() -> NKNetworkActivity? {
        return Class.instance
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

        Class.instance = self
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