import UIKit

public extension NKNetworkRequest {
    private class func responseSerializerData() -> NKNetworkSerializerBlock {
        let dataSerializer: NKNetworkSerializerBlock = {(request, response, data) -> NKNetworkSerializerResponse in
            return (data, nil)
        }

        return dataSerializer
    }

    func responseData(
        queue: NSOperationQueue=NSOperationQueue.mainQueue(),
        completionHandler: (NSURLRequest, NSHTTPURLResponse?, AnyObject?, NSError?) -> (Void)
    ) -> Self {
        return self.response(
            serializer: NKNetworkRequest.responseSerializerData(),
            queue: queue,
            completionHandler: completionHandler
        )
    }

    func responseData(
        queue: NSOperationQueue=NSOperationQueue.mainQueue(),
        completionHandler: (AnyObject?) -> (Void)
    ) -> Self {
        return self.response(
            serializer: NKNetworkRequest.responseSerializerData(),
            queue: queue,
            completionHandler: {(_, _, data, _) -> (Void) in
                completionHandler(data)
        })
    }
}
