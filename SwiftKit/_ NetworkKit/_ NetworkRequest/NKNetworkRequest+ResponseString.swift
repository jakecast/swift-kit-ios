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
        queueInfo: (queue: NSOperationQueue, sync: Bool)?=nil,
        completion: (NSURLRequest, NSHTTPURLResponse?, String?, NSError?) -> (Void)
    ) -> Self {
        return self.response(
            serializer: NKNetworkRequest.responseSerializerString(encoding: encoding),
            queueInfo: queueInfo,
            completion: {(request, response, string, error) -> (Void) in
                completion(request, response, string as? String, error)
        })
    }

    func responseString(
        encoding: NSStringEncoding=NSUTF8StringEncoding,
        queueInfo: (queue: NSOperationQueue, sync: Bool)?=nil,
        completion: (String?) -> (Void)
    ) -> Self {
        return self.response(
            serializer: NKNetworkRequest.responseSerializerString(encoding: encoding),
            queueInfo: queueInfo,
            completion: {(_, _, string, _) -> (Void) in
                completion(string as? String)
        })
    }
}
