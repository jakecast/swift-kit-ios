import UIKit

public class NetworkSession {
    private let delegate: NetworkSessionDelegate
    private let urlSession: NSURLSession
    private let sessionQueue: Queue

    deinit {
        self.urlSession.invalidateAndCancel()
    }

    public required init(configuration: NSURLSessionConfiguration) {
        self.delegate = NetworkSessionDelegate()
        self.sessionQueue = Queue.Custom(dispatch_queue_create(nil, DISPATCH_QUEUE_SERIAL))
        self.urlSession = NSURLSession(
            configuration: configuration,
            delegate: self.delegate
        )
    }

    public func request(#method: NetworkMethod, url: NSURL) -> NetworkRequest {
        let urlRequest = NSMutableURLRequest(
            url: url,
            httpMethod: method.rawValue
        )
        let networkRequest = self.request(
            urlRequest: urlRequest
        )

        self.prepareNetworkRequest(request: networkRequest)
            .startNetworkRequest(request: networkRequest)

        return networkRequest
    }

    private func request(#urlRequest: NSURLRequest) -> NetworkRequest {
        var dataTask: NSURLSessionDataTask?
        self.sessionQueue.sync {
            dataTask = self.urlSession.dataTask(urlRequest: urlRequest)
        }
        
        return NetworkRequest(
            session: self.urlSession,
            task: dataTask!
        )
    }

    private func prepareNetworkRequest(#request: NetworkRequest) -> Self {
        self.delegate[request.delegate.task] = request.delegate
        return self
    }
    
    private func startNetworkRequest(#request: NetworkRequest) -> Self {
        request.resumeTask()
        return self
    }
}