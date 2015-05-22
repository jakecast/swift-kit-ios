import UIKit

public class NetworkActivity {
    static var sharedInstance: NetworkActivity?

    static func sharedActivity() -> NetworkActivity? {
        return NetworkActivity.sharedInstance
    }

    let application: UIApplication

    var activityCount: Int
    
    var mainQueue: Queue {
        return Queue.Main
    }

    var isNetworkIndicatorVisible: Bool {
        return (self.activityCount != 0)
    }

    var setNetworkActivityIndicator: ((Void)->(Void)) {
        return {
            self.application.networkActivityIndicatorVisible = self.isNetworkIndicatorVisible
        }
    }

    public required init(application: UIApplication) {
        self.application = application
        self.activityCount = 0

        NetworkActivity.sharedInstance = self
        NSURLSessionTask.swizzleSessionTasks()
    }

    func requestDidBegin() {
        self.setActivityCount(newCount: self.activityCount + 1)
    }

    func requestDidEnd() {
        self.setActivityCount(newCount: self.activityCount - 1)
    }

    func setActivityCount(#newCount: Int) {
        NSOperationQueue.synced(self) {
            self.activityCount = max(0, newCount)
        }
        self.mainQueue.async {
            if self.isNetworkIndicatorVisible == false {
                self.mainQueue.afterDelay(0.17) {self.setNetworkActivityIndicator() }
            }
            else {
                self.mainQueue.async { self.setNetworkActivityIndicator() }
            }
        }
    }
}
