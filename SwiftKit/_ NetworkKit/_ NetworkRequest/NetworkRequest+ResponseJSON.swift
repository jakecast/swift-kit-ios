import UIKit

public extension NetworkRequest {
    private class func responseSerializerJSON(
        options: NSJSONReadingOptions=NSJSONReadingOptions.AllowFragments
    ) -> NetworkSerializerBlock {
        let jsonSerializer: NetworkSerializerBlock = {(request, response, data) -> NetworkSerializerResponse in
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
        queue: NSOperationQueue=NSOperationQueue.mainQueue()
    ) -> AnyObject? {
        var responseJSON: AnyObject?
        let semaphore = DispatchSemaphore(initialValue: 0)
        self.responseJSON(options: options, queue: queue, completionHandler: {(json: AnyObject?) -> (Void) in
            responseJSON = json
            semaphore.signal()
        })
        semaphore.wait()
        return responseJSON
    }

    func responseJSON(
        options: NSJSONReadingOptions=NSJSONReadingOptions.AllowFragments,
        queue: NSOperationQueue=NSOperationQueue.mainQueue(),
        completionHandler: ((AnyObject?) -> (Void))
    ) -> Self {
        return self.response(
            serializer: NetworkRequest.responseSerializerJSON(options: options),
            queue: queue,
            completionHandler: {(_, _, json, _) -> (Void) in
                completionHandler(json)
        })
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
