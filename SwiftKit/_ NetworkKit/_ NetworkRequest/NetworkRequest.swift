import Foundation

public class NetworkRequest: Printable {
    internal let delegate: NetworkRequestDelegate
    private let session: NSURLSession
    
    public var state: NSURLSessionTaskState {
        return self.delegate.state
    }

    public required init(
        session: NSURLSession,
        task: NSURLSessionTask
    ) {
        self.session = session

        switch task {
        case is NSURLSessionDataTask:
            self.delegate = NetworkRequestDelegateDataTask(task: task)
        case is NSURLSessionDownloadTask:
            self.delegate = NetworkRequestDelegateDownloadTask(task: task)
        case is NSURLSessionUploadTask:
            self.delegate = NetworkRequestDelegateUploadTask(task: task)
        default:
            self.delegate = NetworkRequestDelegate(task: task)
        }
    }
    
    public var description: String {
        var descriptionComponents: [String] = []
        if let HTTPMethod = self.request.HTTPMethod {
            descriptionComponents += [HTTPMethod, ]
        }
        if let URLString = self.request.URL?.absoluteString {
            descriptionComponents += [URLString, ]
        }
        if let responseCode = self.response?.statusCode.stringValue {
            descriptionComponents += [responseCode, ]
        }
        return join(" ", descriptionComponents)
    }

    public var taskIdentifier: Int {
        return self.task.taskIdentifier
    }

    public var taskState: NSURLSessionTaskState {
        return self.task.state
    }

    private var progress: NSProgress {
        return self.delegate.progress
    }
    
    private var response: NSHTTPURLResponse? {
        return self.task.response as? NSHTTPURLResponse
    }
    
    private var request: NSURLRequest {
        return self.task.originalRequest
    }
    
    private var task: NSURLSessionTask {
        return self.delegate.task
    }
    
    public func suspendTask() {
        self.task.suspend()
    }

    public func resumeTask() {
        self.task.resume()
    }
    
    public func cancelTask() {
        if let downloadDelegate = self.delegate as? NetworkRequestDelegateDownloadTask {
            
        }
        else {
            self.task.cancel()
        }
    }

    public func progress(progressBlock: ((Int64, Int64, Int64) -> (Void))?=nil) -> Self {
        if let dataDelegate = self.delegate as? NetworkRequestDelegateDataTask {
            dataDelegate.dataTaskProgressed = progressBlock
        }
        if let downloadDelegate = self.delegate as? NetworkRequestDelegateDownloadTask {

        }
        if let uploadDelegate = self.delegate as? NetworkRequestDelegateUploadTask {
            
        }
        
        return self
    }

    public func response(
        #serializer: NetworkSerializerBlock,
        completionHandler: NetworkResponseBlock
    ) -> Self {
        self.delegate.queue.async {
            let serializedData = serializer(
                request: self.request,
                response: self.response,
                data: self.delegate.data
            )

            completionHandler(
                request: self.request,
                response: self.response,
                dataObject: serializedData.serializedData,
                error: self.delegate.error ?? serializedData.serializerError
            )
        }
        return self
    }
}
