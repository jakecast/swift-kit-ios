import UIKit

public extension URLSession {
    convenience init(configuration: NSURLSessionConfiguration, delegate: NSURLSessionDelegate) {
        self.init(configuration: configuration, delegate: delegate, delegateQueue: nil)
    }
}