import UIKit

extension NKNetworkSessionDelegate: NSURLSessionDataDelegate {
    public func URLSession(
        session: NSURLSession,
        dataTask: NSURLSessionDataTask,
        didReceiveResponse response: NSURLResponse,
        completionHandler: ((NSURLSessionResponseDisposition) -> (Void))
    ) {
        if let taskDelegate = self[dataTask] as? NKNetworkRequestDelegateDataTask {
            taskDelegate.URLSession(
                session,
                dataTask: dataTask,
                didReceiveResponse: response,
                completionHandler: completionHandler
            )
        }
        else {
            completionHandler(NSURLSessionResponseDisposition.Allow)
        }
    }

    public func URLSession(
        session: NSURLSession,
        dataTask: NSURLSessionDataTask,
        didBecomeDownloadTask downloadTask: NSURLSessionDownloadTask
    ) {
        if let taskDelegate = self[dataTask] as? NKNetworkRequestDelegateDataTask {
            taskDelegate.URLSession(
                session,
                dataTask: dataTask,
                didBecomeDownloadTask: downloadTask
            )
        }

        self[downloadTask] = NKNetworkRequestDelegateDownloadTask(task: downloadTask)
    }

    public func URLSession(
        session: NSURLSession,
        dataTask: NSURLSessionDataTask,
        didReceiveData data: NSData
    ) {
        if let taskDelegate = self[dataTask] as? NKNetworkRequestDelegateDataTask {
            taskDelegate.URLSession(
                session,
                dataTask: dataTask,
                didReceiveData: data
            )
        }
    }

    public func URLSession(
        session: NSURLSession,
        dataTask: NSURLSessionDataTask,
        willCacheResponse proposedResponse: NSCachedURLResponse,
        completionHandler: ((NSCachedURLResponse!) -> (Void))
    ) {
        if let taskDelegate = self[dataTask] as? NKNetworkRequestDelegateDataTask {
            taskDelegate.URLSession(
                session,
                dataTask: dataTask,
                willCacheResponse: proposedResponse,
                completionHandler: completionHandler
            )
        }
        else {
            completionHandler(proposedResponse)
        }
    }
}
