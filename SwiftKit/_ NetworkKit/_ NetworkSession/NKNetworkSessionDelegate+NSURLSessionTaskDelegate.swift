import UIKit

extension NKNetworkSessionDelegate {
    public func URLSession(
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

    public func URLSession(
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

    public func URLSession(
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

    public func URLSession(
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

    public func URLSession(
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
        NKNetworkActivity
            .sharedActivity()?
            .requestDidEnd()
    }
}