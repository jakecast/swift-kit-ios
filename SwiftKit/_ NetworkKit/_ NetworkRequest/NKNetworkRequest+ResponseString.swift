import UIKit

public extension NKNetworkRequest {
    private class func responseSerializerString(
        encoding: NSStringEncoding=NSUTF8StringEncoding
    ) -> NKNetworkSerializerBlock {
        let stringSerializer: NKNetworkSerializerBlock = {(_, _, data) -> NKNetworkSerializerResponse in
            return (NSString(data: data!, encoding: encoding), nil)
        }
        return stringSerializer
    }

    func responseString(
        encoding: NSStringEncoding=NSUTF8StringEncoding,
        queue: NSOperationQueue=NSOperationQueue.mainQueue(),
        completionHandler: (NSURLRequest, NSHTTPURLResponse?, String?, NSError?) -> (Void)
    ) -> Self {
        return self.response(
            serializer: NKNetworkRequest.responseSerializerString(encoding: encoding),
            queue: queue,
            completionHandler: {(request, response, string, error) -> (Void) in
                completionHandler(request, response, string as? String, error)
        })
    }

    func responseString(
        encoding: NSStringEncoding=NSUTF8StringEncoding,
        queue: NSOperationQueue=NSOperationQueue.mainQueue(),
        completionHandler: (String?) -> (Void)
    ) -> Self {
        return self.response(
            serializer: NKNetworkRequest.responseSerializerString(encoding: encoding),
            queue: queue,
            completionHandler: {(_, _, string, _) -> (Void) in
                completionHandler(string as? String)
        })
    }
}
