import UIKit

public extension NKNetworkRequest {
    private class func responseSerializerJSON(
        options: NSJSONReadingOptions=NSJSONReadingOptions.AllowFragments
    ) -> NKNetworkSerializerBlock {
        let jsonSerializer: NKNetworkSerializerBlock = {(request, response, data) -> NKNetworkSerializerResponse in
            var json: AnyObject?
            var serializationError: NSError?
            if data != nil {
                json = NSJSONSerialization.JSONObjectWithData(
                    data!,
                    options: options,
                    error: &serializationError
                )
            }
            return (json, serializationError)
        }
        return jsonSerializer
    }
    
    func responseJSON(
        options: NSJSONReadingOptions=NSJSONReadingOptions.AllowFragments,
        queue: NSOperationQueue=NSOperationQueue.mainQueue(),
        completionHandler: ((AnyObject?) -> (Void))
    ) -> Self {
        return self.response(
            serializer: NKNetworkRequest.responseSerializerJSON(options: options),
            queue: queue,
            completionHandler: {(_, _, json, _) -> (Void) in
                completionHandler(json)
        })
    }

    func responseJSON(
        options: NSJSONReadingOptions=NSJSONReadingOptions.AllowFragments,
        queue: NSOperationQueue=NSOperationQueue.mainQueue(),
        completionHandler: NKNetworkResponseBlock
    ) -> Self {
        return self.response(
            serializer: NKNetworkRequest.responseSerializerJSON(options: options),
            queue: queue,
            completionHandler: completionHandler
        )
    }
}
