import UIKit

public extension NKNetworkRequest {
    private class func responseSerializerData() -> NKNetworkSerializerBlock {
        let dataSerializer: NKNetworkSerializerBlock = {(request, response, data) -> NKNetworkSerializerResponse in
            return (data, nil)
        }

        return dataSerializer
    }

    func responseData(
        queueInfo: (queue: NSOperationQueue, sync: Bool)?=nil,
        completion: (NSURLRequest, NSHTTPURLResponse?, AnyObject?, NSError?) -> (Void)
    ) -> Self {
        return self.response(
            serializer: NKNetworkRequest.responseSerializerData(),
            queueInfo: queueInfo,
            completion: completion
        )
    }

    func responseData(
        queueInfo: (queue: NSOperationQueue, sync: Bool)?=nil,
        completion: (AnyObject?) -> (Void)
    ) -> Self {
        return self.response(
            serializer: NKNetworkRequest.responseSerializerData(),
            queueInfo: queueInfo,
            completion: {(_, _, data, _) -> (Void) in
                completion(data)
        })
    }
}
