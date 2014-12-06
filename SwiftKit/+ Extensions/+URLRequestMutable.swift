import UIKit


public extension URLRequestMutable {
    convenience init(url: NSURL, httpMethod: String) {
        self.init(URL: url)
        self.HTTPMethod = httpMethod
    }
}