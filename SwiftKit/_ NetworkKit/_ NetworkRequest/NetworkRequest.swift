import UIKit

public class NetworkRequest {
    let session: NSURLSession
    let delegate: NetworkRequestDelegate

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

    public var taskIdentifier: Int {
        return self.task.taskIdentifier
    }

    public var taskState: NSURLSessionTaskState {
        return self.task.state
    }

    var progress: NSProgress {
        return self.delegate.progress
    }
    
    var response: NSHTTPURLResponse? {
        return self.task.response as? NSHTTPURLResponse
    }
    
    var request: NSURLRequest {
        return self.task.originalRequest
    }
    
    var task: NSURLSessionTask {
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

    func progress(progressBlock: ((Int64, Int64, Int64) -> (Void))?=nil) -> Self {
        if let dataDelegate = self.delegate as? NetworkRequestDelegateDataTask {
            dataDelegate.dataTaskProgressed = progressBlock
        }
        if let downloadDelegate = self.delegate as? NetworkRequestDelegateDownloadTask {

        }
        if let uploadDelegate = self.delegate as? NetworkRequestDelegateUploadTask {
            
        }
        
        return self
    }

    func response(
        #serializer: NetworkSerializerBlock,
        queue: NSOperationQueue?,
        completionHandler: NetworkResponseBlock
    ) -> Self {
        self.delegate.queue.dispatch {
            let serializedData = serializer(
                request: self.request,
                response: self.response,
                data: self.delegate.data
            )

            (queue ?? NSOperationQueue.mainQueue()).dispatch {
                completionHandler(
                    request: self.request,
                    response: self.response,
                    dataObject: serializedData.serializedData,
                    error: self.delegate.error ?? serializedData.serializerError
                )
            }
        }
        return self
    }
}
