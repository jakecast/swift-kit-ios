import UIKit

public class NKNetworkSession {
    let delegate: NKNetworkSessionDelegate
    let urlSession: NSURLSession

    lazy private var queue = NSOperationQueue(serial: true)

    public required init(configuration: NSURLSessionConfiguration) {
        self.delegate = NKNetworkSessionDelegate()
        self.urlSession = NSURLSession(
            configuration: configuration,
            delegate: self.delegate
        )
    }

    deinit {
        self.urlSession.invalidateAndCancel()
    }

    public func request(#urlRequest: NSURLRequest) -> NKNetworkRequest {
        let dataTask = self.urlSession.dataTask(
            urlRequest: urlRequest,
            queue: self.queue
        )
        let request = NKNetworkRequest(
            session: self.urlSession,
            task: dataTask
        )
        return request
    }

    public func prepareNetworkRequest(#request: NKNetworkRequest) -> Self {
        self.delegate[request.delegate.task] = request.delegate
        return self
    }

    public func startNetworkRequest(#request: NKNetworkRequest) -> Self {
        request.resumeTask()
        return self
    }

    public func request(#method: NKNetworkMethod, url: NSURL) -> NKNetworkRequest {
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

    public func request(#method: NKNetworkMethod, urlString: String) -> NKNetworkRequest {
        return self.request(
            method: method,
            url: NSURL(string: urlString)!
        )
    }
}