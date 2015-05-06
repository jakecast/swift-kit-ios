import UIKit

public extension NetworkRequest {
    private static func responseSerializerData() -> NetworkSerializerBlock {
        let dataSerializer: NetworkSerializerBlock = {(request, response, data) -> NetworkSerializerResponse in
            return (data, nil)
        }
        return dataSerializer
    }

    func responseData(
        queue: NSOperationQueue=NSOperationQueue.mainQueue(),
        completionHandler: NetworkResponseBlock
    ) -> Self {
        return self.response(
            serializer: NetworkRequest.responseSerializerData(),
            queue: queue,
            completionHandler: completionHandler
        )
    }
}
