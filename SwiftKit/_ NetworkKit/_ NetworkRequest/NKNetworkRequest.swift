import UIKit

public class NKNetworkRequest {
    let session: NSURLSession
    let delegate: NKNetworkRequestDelegate

    public required init(
        session: NSURLSession,
        task: NSURLSessionTask
    ) {
        self.session = session

        switch task {
        case is NSURLSessionDataTask:
            self.delegate = NKNetworkRequestDelegateDataTask(task: task)
        case is NSURLSessionDownloadTask:
            self.delegate = NKNetworkRequestDelegateDownloadTask(task: task)
        case is NSURLSessionUploadTask:
            self.delegate = NKNetworkRequestDelegateUploadTask(task: task)
        default:
            self.delegate = NKNetworkRequestDelegate(task: task)
        }
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

    var taskIdentifier: Int {
        return self.task.taskIdentifier
    }
    
    public func suspendTask() {
        self.task.suspend()
    }

    public func resumeTask() {
        self.task.resume()
    }
    
    public func cancelTask() {
        if let downloadDelegate = self.delegate as? NKNetworkRequestDelegateDownloadTask {
            
        }
        else {
            self.task.cancel()
        }
    }

    func progress(progressBlock: ((Int64, Int64, Int64) -> (Void))?=nil) -> Self {
        if let dataDelegate = self.delegate as? NKNetworkRequestDelegateDataTask {
            dataDelegate.dataTaskProgressed = progressBlock
        }
        if let downloadDelegate = self.delegate as? NKNetworkRequestDelegateDownloadTask {

        }
        if let uploadDelegate = self.delegate as? NKNetworkRequestDelegateUploadTask {
            
        }
        
        return self
    }

    func response(
        #serializer: NKNetworkSerializerBlock,
        queue: NSOperationQueue=NSOperationQueue.mainQueue(),
        completionHandler: NKNetworkResponseBlock
    ) -> Self {
        self.delegate.queue.dispatchAsync {
            let serializedData = serializer(
                request: self.request,
                response: self.response,
                data: self.delegate.data
            )
            
            queue.dispatchAsync {
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