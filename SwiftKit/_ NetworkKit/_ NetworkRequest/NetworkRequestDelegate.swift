import UIKit

internal class NetworkRequestDelegate: NSObject, NSURLSessionTaskDelegate {
    internal let progress: NSProgress
    internal let task: NSURLSessionTask
    internal let queue: Queue

    internal var credential: NSURLCredential? = nil
    internal var error: NSError? = nil

    internal var data: NSData? {
        return nil
    }
    
    internal var state: NSURLSessionTaskState {
        return self.task.state
    }

    internal required init(task: NSURLSessionTask) {
        self.progress = NSProgress(totalUnitCount: 0)
        self.queue = Queue.Custom(dispatch_queue_create(nil, DISPATCH_QUEUE_SERIAL))
        self.task = task

        self.queue.suspend()
    }

    internal func URLSession(
        session: NSURLSession,
        task: NSURLSessionTask,
        willPerformHTTPRedirection response: NSHTTPURLResponse,
        newRequest request: NSURLRequest,
        completionHandler: (NSURLRequest!) -> (Void)
    ) {
        completionHandler(request)
    }

    internal func URLSession(
        session: NSURLSession,
        task: NSURLSessionTask,
        didReceiveChallenge challenge: NSURLAuthenticationChallenge,
        completionHandler: (NSURLSessionAuthChallengeDisposition, NSURLCredential!) -> (Void)
    ) {
        session.taskRecievedChallenge(
            task: task,
            challenge: challenge,
            completionHandler: completionHandler,
            credential: self.credential
        )
    }

    internal func URLSession(
        session: NSURLSession,
        task: NSURLSessionTask,
        needNewBodyStream completionHandler: (NSInputStream!) -> (Void)
    ) {
        completionHandler(nil)
    }

    internal func URLSession(
        session: NSURLSession,
        task: NSURLSessionTask,
        didSendBodyData bytesSent: Int64,
        totalBytesSent: Int64,
        totalBytesExpectedToSend: Int64
    ) {
        self.progress.totalUnitCount = totalBytesExpectedToSend
        self.progress.completedUnitCount = totalBytesSent
    }

    internal func URLSession(
        session: NSURLSession,
        task: NSURLSessionTask,
        didCompleteWithError error: NSError?
    ) {
        self.error = error
        self.queue.resume()
    }
}
