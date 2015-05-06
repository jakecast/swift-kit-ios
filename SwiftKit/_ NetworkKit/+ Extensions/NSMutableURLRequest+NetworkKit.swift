import UIKit

public extension NSMutableURLRequest {
    convenience init(url: NSURL, httpMethod: String) {
        self.init(URL: url)
        self.HTTPMethod = httpMethod
    }
}