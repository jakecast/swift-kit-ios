import UIKit


public extension NetworkRequest {
    private class func responseSerializerData() -> NetworkSerializerBlock {
        let dataSerializer: NetworkSerializerBlock = {(request, response, data) -> NetworkSerializerResponse in
            return (data, nil)
        }
        
        return dataSerializer
    }

    func responseData(
        queueInfo: (queue: OperationQueue, sync: Bool)?=nil,
        completion: (NSURLRequest, NSHTTPURLResponse?, AnyObject?, NSError?) -> (Void)
    ) -> Self {
        return self.response(
            serializer: NetworkRequest.responseSerializerData(),
            queueInfo: queueInfo,
            completion: completion
        )
    }

    func responseData(
        queueInfo: (queue: OperationQueue, sync: Bool)?=nil,
        completion: (AnyObject?) -> (Void)
    ) -> Self {
        return self.response(
            serializer: NetworkRequest.responseSerializerData(),
            queueInfo: queueInfo,
            completion: {(_, _, data, _) -> (Void) in
                completion(data)
        })
    }
}
