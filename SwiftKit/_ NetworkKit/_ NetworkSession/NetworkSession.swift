import UIKit


public class NetworkSession {
    private let delegate: NetworkSessionDelegate
    private let urlSession: NSURLSession

    lazy private var queue = OperationQueue(serial: true)

    public required init(configuration: NSURLSessionConfiguration) {
        self.delegate = NetworkSessionDelegate()
        self.urlSession = NSURLSession(
            configuration: configuration,
            delegate: self.delegate)
    }

    deinit {
        self.urlSession.invalidateAndCancel()
    }

    internal func request(#urlRequest: NSURLRequest) -> NetworkRequest {
        let dataTask = self.urlSession.dataTask(
            urlRequest: urlRequest,
            queue: self.queue
        )
        let request = NetworkRequest(
            session: self.urlSession,
            task: dataTask
        )
        return request
    }

    internal func prepareNetworkRequest(#request: NetworkRequest) -> Self {
        self.delegate[request.delegate.task] = request.delegate
        return self
    }

    internal func startNetworkRequest(#request: NetworkRequest) -> Self {
        request.resumeTask()
        return self
    }

    public func request(#method: NetworkMethod, url: NSURL) -> NetworkRequest {
        let urlRequest = NSMutableURLRequest(
            url: url,
            httpMethod: method.rawValue
        )

        let networkRequest = self
            .request(urlRequest: urlRequest)

        self.prepareNetworkRequest(request: networkRequest)
            .startNetworkRequest(request: networkRequest)

        return networkRequest
    }

    public func request(#method: NetworkMethod, urlString: String) -> NetworkRequest {
        return self.request(
            method: method,
            url: NSURL(string: urlString)!
        )
    }
}
