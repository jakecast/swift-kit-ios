import UIKit

public class NKNetworkActivity {
    private struct Class {
        static var instance: NKNetworkActivity? = nil
    }

    class var sharedInstance: NKNetworkActivity? {
        return self.sharedActivity()
    }

    class func sharedActivity() -> NKNetworkActivity? {
        return Class.instance
    }

    let application: UIApplication

    var activityCount: Int

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
        NSOperationQueue.synced(self) {
            self.activityCount = max(0, newCount)
        }
        NSOperationQueue.mainInstance.async {
            self.updateNetworkActivityIndicator()
        }
    }

    func updateNetworkActivityIndicator() {
        if self.isNetworkIndicatorVisible == false {
            NSOperationQueue.mainInstance.delay(0.17, self.setNetworkActivityIndicator)
        }
        else {
            NSOperationQueue.mainInstance.async(self.setNetworkActivityIndicator)
        }
    }

    func requestDidBegin() {
        self.setActivityCount(newCount: self.activityCount + 1)
    }

    func requestDidEnd() {
        self.setActivityCount(newCount: self.activityCount - 1)
    }
}