import Foundation

public class NetworkOperation: BaseOperation {
    private var request: NetworkRequest? = nil
    private var serializer: NetworkSerializerBlock? = nil
    private var url: NSURL? = nil
    private var responseData: AnyObject? = nil
    private var responseError: NSError? = nil

    public override func main() {
        if let request = self.request, let serializer = self.serializer {
            let requestSemaphore: dispatch_semaphore_t = dispatch_semaphore_create(0);
            request.response(serializer: serializer, completionHandler: {(request, response, data, error) -> (Void) in
                self.responseData = data
                self.responseError = error

                dispatch_semaphore_signal(requestSemaphore)
            })

            dispatch_semaphore_wait(requestSemaphore, DISPATCH_TIME_FOREVER)
            self.finishOperation()
        }
        else {
            self.finishOperation()
        }
    }

    public func networkResponse() -> (AnyObject?, NSError?) {
        return (self.responseData, self.responseError)
    }

    public func set(#request: NetworkRequest) -> Self {
        self.request = request
        return self
    }

    public func set(#serializer: NetworkSerializerBlock) -> Self {
        self.serializer = serializer
        return self
    }
}
