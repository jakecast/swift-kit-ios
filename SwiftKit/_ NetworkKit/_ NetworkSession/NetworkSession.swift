import UIKit

public class NetworkSession {
    let delegate: NetworkSessionDelegate
    let urlSession: NSURLSession

    lazy private var queue = NSOperationQueue(name: "com.network-kit.network-session", serial: true)

    public required init(configuration: NSURLSessionConfiguration) {
        self.delegate = NetworkSessionDelegate()
        self.urlSession = NSURLSession(
            configuration: configuration,
            delegate: self.delegate
        )
    }

    deinit {
        self.urlSession.invalidateAndCancel()
    }

    public func request(#urlRequest: NSURLRequest) -> NetworkRequest {
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
    
    public func prepareNetworkRequest(#request: NetworkRequest) -> Self {
        self.delegate[request.delegate.task] = request.delegate
        return self
    }
    
    public func startNetworkRequest(#request: NetworkRequest) -> Self {
        request.resumeTask()
        return self
    }
}