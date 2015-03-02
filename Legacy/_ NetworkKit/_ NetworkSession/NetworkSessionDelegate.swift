import UIKit


internal class NetworkSessionDelegate: NSObject {
    lazy var delegateQueue = OperationQueue(serial: false)
    lazy var subdelegateDictionary: [Int:NetworkRequestDelegate] = [:]

    subscript(task: NSURLSessionTask) -> NetworkRequestDelegate? {
        get {
            var subdelegate: NetworkRequestDelegate? = nil
            self.delegateQueue.sync {
                subdelegate = self.subdelegateDictionary[task.taskIdentifier]
            }

            return subdelegate
        }
        set (newValue) {
            self.delegateQueue.barrierAsync {
                self.subdelegateDictionary[task.taskIdentifier] = newValue
            }
        }
    }
}

extension NetworkSessionDelegate: NSURLSessionDelegate {
    internal func URLSession(
        session: NSURLSession,
        didBecomeInvalidWithError error: NSError?
    ) {}

    internal func URLSession(
        session: NSURLSession,
        didReceiveChallenge challenge: NSURLAuthenticationChallenge,
        completionHandler: (NSURLSessionAuthChallengeDisposition, NSURLCredential!) -> (Void)
    ) {
        completionHandler(.PerformDefaultHandling, nil)
    }

    internal func URLSessionDidFinishEventsForBackgroundURLSession(
        session: NSURLSession
    ) {}
}

extension NetworkSessionDelegate: NSURLSessionTaskDelegate {
    internal func URLSession(
        session: NSURLSession,
        task: NSURLSessionTask,
        willPerformHTTPRedirection response: NSHTTPURLResponse,
        newRequest request: NSURLRequest,
        completionHandler: (NSURLRequest!) -> (Void)
    ) {
        if let delegate = self[task] {
            delegate.URLSession(
                session,
                task: task,
                willPerformHTTPRedirection: response,
                newRequest: request,
                completionHandler: completionHandler
            )
        }
        else {
            completionHandler(request)
        }
    }

    internal func URLSession(
        session: NSURLSession,
        task: NSURLSessionTask,
        didReceiveChallenge challenge: NSURLAuthenticationChallenge,
        completionHandler: (NSURLSessionAuthChallengeDisposition, NSURLCredential!) -> (Void)
    ) {
        if let delegate = self[task] {
            delegate.URLSession(
                session,
                task: task,
                didReceiveChallenge: challenge,
                completionHandler: completionHandler)
        }
        else {
            session.taskRecievedChallenge(
                task: task,
                challenge: challenge,
                completionHandler: completionHandler
            )
        }
    }

    internal func URLSession(
        session: NSURLSession,
        task: NSURLSessionTask,
        needNewBodyStream completionHandler: (NSInputStream!) -> (Void)
    ) {
        if let delegate = self[task] {
            delegate.URLSession(
                session,
                task: task,
                needNewBodyStream: completionHandler
            )
        }
        else {
            completionHandler(nil)
        }
    }

    internal func URLSession(
        session: NSURLSession,
        task: NSURLSessionTask,
        didSendBodyData bytesSent: Int64,
        totalBytesSent: Int64,
        totalBytesExpectedToSend: Int64
    ) {
        if let delegate = self[task] {
            delegate.URLSession(
                session,
                task: task,
                didSendBodyData: bytesSent,
                totalBytesSent: totalBytesSent,
                totalBytesExpectedToSend: totalBytesExpectedToSend
            )
        }
    }

    internal func URLSession(
        session: NSURLSession,
        task: NSURLSessionTask,
        didCompleteWithError error: NSError?
    ) {
        if let delegate = self[task] {
            delegate.URLSession(
                session,
                task: task,
                didCompleteWithError: error
            )
        }

        self[task] = nil
        NetworkActivity.sharedInstance?.requestDidEnd()
    }
}

extension NetworkSessionDelegate: NSURLSessionDataDelegate {
    internal func URLSession(
        session: NSURLSession,
        dataTask: NSURLSessionDataTask,
        didReceiveResponse response: NSURLResponse,
        completionHandler: ((NSURLSessionResponseDisposition) -> (Void))
    ) {
        if let taskDelegate = self[dataTask] as? NetworkRequestDelegateDataTask {
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

    internal func URLSession(
        session: NSURLSession,
        dataTask: NSURLSessionDataTask,
        didBecomeDownloadTask downloadTask: NSURLSessionDownloadTask
    ) {
        if let taskDelegate = self[dataTask] as? NetworkRequestDelegateDataTask {
            taskDelegate.URLSession(
                session,
                dataTask: dataTask,
                didBecomeDownloadTask: downloadTask
            )
        }

        self[downloadTask] = NetworkRequestDelegateDownloadTask(task: downloadTask)
    }

    internal func URLSession(
        session: NSURLSession,
        dataTask: NSURLSessionDataTask,
        didReceiveData data: NSData
    ) {
        if let taskDelegate = self[dataTask] as? NetworkRequestDelegateDataTask {
            taskDelegate.URLSession(
                session,
                dataTask: dataTask,
                didReceiveData: data
            )
        }
    }

    internal func URLSession(
        session: NSURLSession,
        dataTask: NSURLSessionDataTask,
        willCacheResponse proposedResponse: NSCachedURLResponse,
        completionHandler: ((NSCachedURLResponse!) -> (Void))
    ) {
        if let taskDelegate = self[dataTask] as? NetworkRequestDelegateDataTask {
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

extension NetworkSessionDelegate: NSURLSessionDownloadDelegate {
    internal func URLSession(
        session: NSURLSession,
        downloadTask: NSURLSessionDownloadTask,
        didFinishDownloadingToURL location: NSURL
    ) {
        
    }
}
