import UIKit


public extension NetworkRequest {
    private class func responseSerializerString(
        encoding: NSStringEncoding=NSUTF8StringEncoding
    ) -> NetworkSerializerBlock {
        let stringSerializer: NetworkSerializerBlock = {(_, _, data) -> NetworkSerializerResponse in
            return (NSString(data: data!, encoding: encoding), nil)
        }

        return stringSerializer
    }

    func responseString(
        encoding: NSStringEncoding=NSUTF8StringEncoding,
        queueInfo: (queue: OperationQueue, sync: Bool)?=nil,
        completion: (NSURLRequest, NSHTTPURLResponse?, String?, NSError?) -> (Void)
    ) -> Self {
        return self.response(
            serializer: NetworkRequest.responseSerializerString(encoding: encoding),
            queueInfo: queueInfo,
            completion: {(request, response, string, error) -> (Void) in
                completion(request, response, string as? String, error)
        })
    }

    func responseString(
        encoding: NSStringEncoding=NSUTF8StringEncoding,
        queueInfo: (queue: OperationQueue, sync: Bool)?=nil,
        completion: (String?) -> (Void)
    ) -> Self {
        return self.response(
            serializer: NetworkRequest.responseSerializerString(encoding: encoding),
            queueInfo: queueInfo,
            completion: {(_, _, string, _) -> (Void) in
                completion(string as? String)
        })
    }
}
