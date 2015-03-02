import UIKit

public extension NSURLSession {
    convenience init(configuration: NSURLSessionConfiguration, delegate: NSURLSessionDelegate) {
        self.init(configuration: configuration, delegate: delegate, delegateQueue: nil)
    }

    func defaultCredential(#protectionSpace: NSURLProtectionSpace) -> NSURLCredential? {
        return self.configuration.URLCredentialStorage?.defaultCredentialForProtectionSpace(protectionSpace)
    }

    func dataTask(#urlRequest: NSURLRequest, queue: NSOperationQueue) -> NSURLSessionDataTask {
        var dataTask: NSURLSessionDataTask? = nil
        queue.sync {
            dataTask = self.dataTaskWithRequest(urlRequest)
        }

        return dataTask!
    }

    func taskRecievedChallenge(
        #task: NSURLSessionTask,
        challenge: NSURLAuthenticationChallenge,
        completionHandler: ((NSURLSessionAuthChallengeDisposition, NSURLCredential!) -> (Void)),
        credential: NSURLCredential?=nil
    ) {
        var urlCredential: NSURLCredential? = nil
        var disposition = NSURLSessionAuthChallengeDisposition.PerformDefaultHandling

        if challenge.previousFailureCount > 0 {
            disposition = NSURLSessionAuthChallengeDisposition.CancelAuthenticationChallenge
        }
        else {
            switch challenge.protectionSpace.authenticationMethod! {
            case NSURLAuthenticationMethodServerTrust:
                urlCredential = NSURLCredential(forTrust: challenge.protectionSpace.serverTrust)
            default:
                urlCredential = credential ?? self.defaultCredential(protectionSpace: challenge.protectionSpace)
            }

            disposition = (urlCredential != nil) ? NSURLSessionAuthChallengeDisposition.UseCredential : disposition
        }
        
        completionHandler(disposition, urlCredential)
    }
}