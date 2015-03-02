import UIKit

public class NKNetworkRequestDelegateDataTask: NKNetworkRequestDelegate, NSURLSessionDataDelegate {
    var dataTaskDidReceiveResponse: NKNetworkDataTaskReceivedResponseBlock? = nil
    var dataTaskDidBecomeDownloadTask: NKNetworkDataTaskBecameDownloadTaskBlock? = nil
    var dataTaskDidReceiveData: NKNetworkDataTaskReceivedDataBlock? = nil
    var dataTaskWillCacheResponse: NKNetworkDataTaskWillCacheResponseBlock? = nil
    var dataTaskProgressed: NKNetworkDataTaskProgressedBlock? = nil
    var expectedContentLength: Int64? = nil

    lazy private var mutableData = NSMutableData()

    override var data: NSData? {
        return self.mutableData
    }

    var dataTask: NSURLSessionDataTask {
        return self.task as! NSURLSessionDataTask
    }

    public func URLSession(
        session: NSURLSession,
        dataTask: NSURLSessionDataTask,
        didReceiveResponse response: NSURLResponse,
        completionHandler: (NSURLSessionResponseDisposition) -> (Void)
    ) {
        self.expectedContentLength = response.expectedContentLength

        if let dataTaskDidReceiveResponseBlock = dataTaskDidReceiveResponse {
            completionHandler(dataTaskDidReceiveResponseBlock(session, dataTask, response))
        }
        else {
            completionHandler(NSURLSessionResponseDisposition.Allow)
        }
    }

    public func URLSession(
        session: NSURLSession,
        dataTask: NSURLSessionDataTask,
        didBecomeDownloadTask downloadTask: NSURLSessionDownloadTask
    ) {
        self.dataTaskDidBecomeDownloadTask?(session, dataTask)
    }

    public func URLSession(
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

    public func URLSession(
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