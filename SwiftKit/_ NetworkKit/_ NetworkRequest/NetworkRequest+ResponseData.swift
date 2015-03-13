import UIKit

public extension NetworkRequest {
    private class func responseSerializerData() -> NetworkSerializerBlock {
        let dataSerializer: NetworkSerializerBlock = {(request, response, data) -> NetworkSerializerResponse in
            return (data, nil)
        }

        return dataSerializer
    }

    func responseData(
        queue: NSOperationQueue=NSOperationQueue.mainQueue(),
        completionHandler: (NSURLRequest, NSHTTPURLResponse?, AnyObject?, NSError?) -> (Void)
    ) -> Self {
        return self.response(
            serializer: NetworkRequest.responseSerializerData(),
            queue: queue,
            completionHandler: completionHandler
        )
    }

    func responseData(
        queue: NSOperationQueue=NSOperationQueue.mainQueue(),
        completionHandler: (AnyObject?) -> (Void)
    ) -> Self {
        return self.response(
            serializer: NetworkRequest.responseSerializerData(),
            queue: queue,
            completionHandler: {(_, _, data, _) -> (Void) in
                completionHandler(data)
        })
    }
}
