import UIKit

public class NKNetworkRequestDelegate: NSObject, NSURLSessionTaskDelegate {
    let progress: NSProgress
    let queue: NSOperationQueue
    let task: NSURLSessionTask

    var credential: NSURLCredential? = nil
    var error: NSError? = nil

    var data: NSData? {
        return nil
    }

    public required init(task: NSURLSessionTask) {
        self.task = task
        self.progress = NSProgress(totalUnitCount: 0)
        self.queue = NSOperationQueue(
            serial: true,
            label: "com.network-kit.task-\(self.task.taskIdentifier)"
        )
        self.queue.suspend()
    }

    public func URLSession(
        session: NSURLSession,
        task: NSURLSessionTask,
        willPerformHTTPRedirection response: NSHTTPURLResponse,
        newRequest request: NSURLRequest,
        completionHandler: (NSURLRequest!) -> (Void)
    ) {
        completionHandler(request)
    }

    public func URLSession(
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

    public func URLSession(
        session: NSURLSession,
        task: NSURLSessionTask,
        needNewBodyStream completionHandler: (NSInputStream!) -> (Void)
    ) {
        completionHandler(nil)
    }

    public func URLSession(
        session: NSURLSession,
        task: NSURLSessionTask,
        didSendBodyData bytesSent: Int64,
        totalBytesSent: Int64,
        totalBytesExpectedToSend: Int64
    ) {
        self.progress.totalUnitCount = totalBytesExpectedToSend
        self.progress.completedUnitCount = totalBytesSent
    }

    public func URLSession(
        session: NSURLSession,
        task: NSURLSessionTask,
        didCompleteWithError error: NSError?
    ) {
        self.error = error
        self.queue.resume()
    }
}
