import Foundation

public class NetworkOperation: BaseOperation {
    private var request: NetworkRequest? = nil
    private var serializer: NetworkSerializerBlock? = nil
    private var url: NSURL? = nil
    private var responseData: AnyObject? = nil
    private var responseError: NSError? = nil

    public override func start() {
        super.start()

        self.startRequest()
            .updateExecutingStatus()
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

    private func startRequest() -> Self {
        if let networkRequest = self.request, networkSerializer = self.serializer {
            networkRequest.response(serializer: networkSerializer, queue: nil, completionHandler: { self.finishRequest($0, $1, $2, $3) })
        }
        return self
    }

    private func finishRequest(request: NSURLRequest, _ response: NSHTTPURLResponse?, _ dataObject: AnyObject?, _ error: NSError?) {
        if self.cancelled == false {
            self.responseData = dataObject
            self.responseError = error
        }

        self.request = nil
        self.updateExecutingStatus()
    }

    private func updateExecutingStatus() {
        self.set(executing: self.request != nil)
    }
}
