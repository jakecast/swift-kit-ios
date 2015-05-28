import UIKit

internal class NetworkRequestDelegateDataTask: NetworkRequestDelegate, NSURLSessionDataDelegate {
    var dataTaskDidReceiveResponse: NetworkDataTaskReceivedResponseBlock?
    var dataTaskDidBecomeDownloadTask: NetworkDataTaskBecameDownloadTaskBlock?
    var dataTaskDidReceiveData: NetworkDataTaskReceivedDataBlock?
    var dataTaskWillCacheResponse: NetworkDataTaskWillCacheResponseBlock?
    var dataTaskProgressed: NetworkDataTaskProgressedBlock?
    var expectedContentLength: Int64?

    lazy private var mutableData = NSMutableData()

    override var data: NSData? {
        return self.mutableData
    }

    var dataTask: NSURLSessionDataTask {
        return self.task as! NSURLSessionDataTask
    }

    internal func URLSession(
        session: NSURLSession,
        dataTask: NSURLSessionDataTask,
        didReceiveResponse response: NSURLResponse,
        completionHandler: (NSURLSessionResponseDisposition) -> (Void)
    ) {
        self.expectedContentLength = response.expectedContentLength

        if let dataTaskDidReceiveResponseBlock = self.dataTaskDidReceiveResponse {
            completionHandler(dataTaskDidReceiveResponseBlock(session, dataTask, response))
        }
        else {
            completionHandler(NSURLSessionResponseDisposition.Allow)
        }
    }

    internal func URLSession(
        session: NSURLSession,
        dataTask: NSURLSessionDataTask,
        didBecomeDownloadTask downloadTask: NSURLSessionDownloadTask
    ) {
        self.dataTaskDidBecomeDownloadTask?(session, dataTask)
    }

    internal func URLSession(
        session: NSURLSession,
        dataTask: NSURLSessionDataTask,
        didReceiveData data: NSData
    ) {
        self.mutableData.appendData(data)
        self.dataTaskDidReceiveData?(session, dataTask, data)

        if let expectedContentLength = dataTask.response?.expectedContentLength {
            self.dataTaskProgressed?(data.length.int64, mutableData.length.int64, expectedContentLength)
        }
    }

    internal func URLSession(
        session: NSURLSession,
        dataTask: NSURLSessionDataTask,
        willCacheResponse proposedResponse: NSCachedURLResponse,
        completionHandler: (NSCachedURLResponse!) -> (Void)
    ) {
        if let dataTaskWillCacheResponseBlock = self.dataTaskWillCacheResponse {
            completionHandler(dataTaskWillCacheResponseBlock(session, dataTask, proposedResponse))
        }
        else {
            completionHandler(proposedResponse)
        }
    }
}