import UIKit

public extension NetworkRequest {
    private static func responseSerializerString(encoding: NSStringEncoding=NSUTF8StringEncoding) -> NetworkSerializerBlock {
        let stringSerializer: NetworkSerializerBlock = {(_, _, data) -> NetworkSerializerResponse in
            let response: (serializedData: AnyObject?, serializerError: NSError?)
            if let stringData = data {
                response = (NSString(data: stringData, encoding: encoding), nil)
            }
            else {
                response = (nil, nil)
            }
            return response
        }
        return stringSerializer
    }

    func responseString(
        encoding: NSStringEncoding=NSUTF8StringEncoding,
        queue: NSOperationQueue=NSOperationQueue.mainQueue(),
        completionHandler: (NSURLRequest, NSHTTPURLResponse?, String?, NSError?) -> (Void)
    ) -> Self {
        return self.response(
            serializer: NetworkRequest.responseSerializerString(encoding: encoding),
            queue: queue,
            completionHandler: {(request, response, string, error) -> (Void) in
                completionHandler(request, response, string as? String, error)
        })
    }
}
