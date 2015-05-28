import UIKit

extension NetworkSessionDelegate: NSURLSessionDelegate {
    public func URLSession(
        session: NSURLSession,
        didBecomeInvalidWithError error: NSError?
    ) {
    }

    public func URLSession(
        session: NSURLSession,
        didReceiveChallenge challenge: NSURLAuthenticationChallenge,
        completionHandler: (NSURLSessionAuthChallengeDisposition, NSURLCredential!) -> (Void)
    ) {
        completionHandler(.PerformDefaultHandling, nil)
    }

    public func URLSessionDidFinishEventsForBackgroundURLSession(
        session: NSURLSession
    ) {
    }
}