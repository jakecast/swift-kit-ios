import UIKit


public extension NetworkRequest {
    private class func responseSerializerJSON(
        options: NSJSONReadingOptions=NSJSONReadingOptions.AllowFragments
    ) -> NetworkSerializerBlock {
        let jsonSerializer: NetworkSerializerBlock = {(request, response, data) -> NetworkSerializerResponse in
            var json: AnyObject? = nil
            var serializationError: NSError? = nil
            if data != nil {
                json = NSJSONSerialization.JSONObjectWithData(
                    data!,
                    options: options,
                    error: &serializationError)
            }

            return (json, serializationError)
        }
        
        return jsonSerializer
    }

    func responseJSON(
        options: NSJSONReadingOptions=NSJSONReadingOptions.AllowFragments,
        queueInfo: (queue: OperationQueue, sync: Bool)?=nil,
        completion: NetworkResponseBlock
    ) -> Self {
        return self.response(
            serializer: NetworkRequest.responseSerializerJSON(options: options),
            queueInfo: queueInfo,
            completion: completion
        )
    }

    func responseJSON(
        options: NSJSONReadingOptions=NSJSONReadingOptions.AllowFragments,
        queueInfo: (queue: OperationQueue, sync: Bool)?=nil,
        completion: ((AnyObject?) -> (Void))
    ) -> Self {
        return self.response(
            serializer: NetworkRequest.responseSerializerJSON(options: options),
            queueInfo: queueInfo,
            completion: {(_, _, json, _) -> (Void) in
                completion(json)
        })
    }
}