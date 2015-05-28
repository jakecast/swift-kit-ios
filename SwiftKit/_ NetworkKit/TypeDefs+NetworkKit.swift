import UIKit

public typealias NetworkSerializerResponse = (
    (serializedData: AnyObject?, serializerError: NSError?)
)

public typealias NetworkSerializerBlock = (
    (request: NSURLRequest, response: NSHTTPURLResponse?, data: NSData?) -> NetworkSerializerResponse
)

public typealias NetworkResponseBlock = (
    (request: NSURLRequest, response: NSHTTPURLResponse?, dataObject: AnyObject?, error: NSError?) -> (Void)
)

public typealias NetworkSessionBecameInvalidBlock = (
    (NSURLSession, NSError?) -> (Void)
)
public typealias NetworkSessionFinishedBackgroundEventsBlock = (
    (NSURLSession!) -> (Void)
)
public typealias NetworkSessionReceivedChallengeBlock = (
    (NSURLSession, NSURLAuthenticationChallenge) -> (NSURLSessionAuthChallengeDisposition, NSURLCredential!)
)

public typealias NetworkTaskWillPerformRedirectBlock = (
    (NSURLSession, NSURLSessionTask, NSHTTPURLResponse, NSURLRequest!) -> (NSURLRequest!)
)
public typealias NetworkTaskReceivedChallengeBlock = (
    (NSURLSession, NSURLSessionTask, NSURLAuthenticationChallenge) ->
    (NSURLSessionAuthChallengeDisposition, NSURLCredential?)
)
public typealias NetworkTaskSentBodyDataBlock = (
    (NSURLSession, NSURLSessionTask, Int64, Int64, Int64) -> (Void)
)
public typealias NetworkTaskNeedsBodyStreamBlock = (
    (NSURLSession, NSURLSessionTask!) -> (NSInputStream!)
)

public typealias NetworkDataTaskReceivedResponseBlock = (
    (NSURLSession, NSURLSessionDataTask, NSURLResponse!) -> (NSURLSessionResponseDisposition)
)
public typealias NetworkDataTaskBecameDownloadTaskBlock = (
    (NSURLSession, NSURLSessionDataTask!) -> (Void)
)
public typealias NetworkDataTaskReceivedDataBlock = (
    (NSURLSession, NSURLSessionDataTask, NSData!) -> (Void)
)
public typealias NetworkDataTaskWillCacheResponseBlock = (
    (NSURLSession, NSURLSessionDataTask, NSCachedURLResponse!) -> (NSCachedURLResponse)
)
public typealias NetworkDataTaskProgressedBlock = (
    (Int64, Int64, Int64) -> (Void)
)

public typealias NetworkDownloadTaskFinishedBlock = (
    (NSURLSession, NSURLSessionDownloadTask, NSURL) -> (NSURL)
)
public typealias NetworkDownloadTaskWroteDataBlock = (
    (NSURLSession, NSURLSessionDownloadTask, Int64, Int64, Int64) -> (Void)
)
public typealias NetworkDownloadTaskDidResumeBlock = (
    (NSURLSession, NSURLSessionDownloadTask, Int64, Int64) -> (Void)
)
