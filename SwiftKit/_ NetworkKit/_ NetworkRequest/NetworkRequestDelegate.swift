import UIKit

public class NetworkRequestDelegate: NSObject, NSURLSessionTaskDelegate {
    let progress: NSProgress
    let queue: NSOperationQueue
    let task: NSURLSessionTask

    var credential: NSURLCredential?
    var error: NSError?

    var data: NSData? {
        return nil
    }

    public required init(task: NSURLSessionTask) {
        self.task = task
        self.progress = NSProgress(totalUnitCount: 0)
        self.queue = NSOperationQueue(
            name: "com.network-kit.task-\(self.task.taskIdentifier)",
            maxConcurrentOperations: 1,
            qualityOfService: NSQualityOfService.Utility
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
