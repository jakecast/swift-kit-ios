import UIKit

public extension NetworkRequest {
    private static func responseSerializerJSON(
        options: NSJSONReadingOptions=NSJSONReadingOptions.AllowFragments
    ) -> NetworkSerializerBlock {
        let jsonSerializer: NetworkSerializerBlock = {(request, response, data) -> NetworkSerializerResponse in
            var json: AnyObject?
            var serializationError: NSError?
            if let jsonData = data {
                json = NSJSONSerialization.JSONObjectWithData(jsonData, options: options, error: &serializationError)
            }
            return (json, serializationError)
        }
        return jsonSerializer
    }

    func responseJSON(
        options: NSJSONReadingOptions=NSJSONReadingOptions.AllowFragments,
        queue: NSOperationQueue=NSOperationQueue.mainQueue(),
        completionHandler: NetworkResponseBlock
    ) -> Self {
        return self.response(
            serializer: NetworkRequest.responseSerializerJSON(options: options),
            queue: queue,
            completionHandler: completionHandler
        )
    }
}
