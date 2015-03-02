import UIKit

public extension NKNetworkRequest {
    private class func responseSerializerJSON(
        options: NSJSONReadingOptions=NSJSONReadingOptions.AllowFragments
    ) -> NKNetworkSerializerBlock {
        let jsonSerializer: NKNetworkSerializerBlock = {(request, response, data) -> NKNetworkSerializerResponse in
            var json: AnyObject? = nil
            var serializationError: NSError? = nil
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
        queueInfo: (queue: NSOperationQueue, sync: Bool)?=nil,
        completion: NKNetworkResponseBlock
    ) -> Self {
        return self.response(
            serializer: NKNetworkRequest.responseSerializerJSON(options: options),
            queueInfo: queueInfo,
            completion: completion
        )
    }

    func responseJSON(
        options: NSJSONReadingOptions=NSJSONReadingOptions.AllowFragments,
        queueInfo: (queue: NSOperationQueue, sync: Bool)?=nil,
        completion: ((AnyObject?) -> (Void))
    ) -> Self {
        return self.response(
            serializer: NKNetworkRequest.responseSerializerJSON(options: options),
            queueInfo: queueInfo,
            completion: {(_, _, json, _) -> (Void) in
                completion(json)
        })
    }
}
