import UIKit


internal extension NetworkRequest {
    func response(
        #serializer: NetworkSerializerBlock,
        queueInfo: (queue: OperationQueue, sync: Bool)?,
        completion: NetworkResponseBlock
    ) -> Self {
        self.delegate.queue.async {
            let serializerTuple = serializer(
                request: self.request,
                response: self.response,
                data: self.delegate.data
            )

            OperationQueue.dispatch(
                queueInfo: (
                    queue: queueInfo?.queue ?? OperationQueue.mainInstance,
                    sync: queueInfo?.sync ?? false
                ),
                dispatchBlock: {(Void) -> (Void) in
                    completion(
                        request: self.request,
                        response: self.response,
                        dataObject: serializerTuple.serializedData,
                        error: self.delegate.error ?? serializerTuple.serializerError
                    )
            })
        }

        return self
    }
}
