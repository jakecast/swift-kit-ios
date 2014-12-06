import UIKit


public class NetworkRequest {
    let session: NSURLSession
    let delegate: NetworkRequestDelegate

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

    func resumeTask() {
        self.task.resume()
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
}
