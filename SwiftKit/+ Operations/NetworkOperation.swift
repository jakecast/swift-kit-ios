import Foundation

public class NetworkOperation: BaseOperation {
    private var request: NetworkRequest? = nil
    private var serializer: NetworkSerializerBlock? = nil
    private var url: NSURL? = nil
    private var responseData: AnyObject? = nil
    private var responseError: NSError? = nil

    public override func main() {
        self.startRequest()

        if self.request == nil {
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

    private func startRequest() {
        if let serializer = self.serializer {
            self.request?.response(serializer: serializer, completionHandler: {[weak self] (request, response, data, error) -> (Void) in
                self?.responseData = data
                self?.responseError = error

                self?.request = nil
                self?.finishOperation()
            })
        }
    }
}
