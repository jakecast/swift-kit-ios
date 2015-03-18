import UIKit

public extension NSFileManager {
    class var defaultInstance: NSFileManager {
        return self.defaultManager()
    }

    func contents(
        #directoryURL: NSURL,
        propertyKeys: [AnyObject]?=nil,
        options: NSDirectoryEnumerationOptions=NSDirectoryEnumerationOptions.SkipsHiddenFiles
    ) -> [NSURL]? {
        var directoryContents: [AnyObject]?
        self.debugOperation {(error) -> (Void) in
            directoryContents = self.contentsOfDirectoryAtURL(directoryURL, includingPropertiesForKeys: propertyKeys, options: options, error: error)
        }
        return directoryContents as? [NSURL]
    }
    
    func createDirectory(#path: String, createIntermediates: Bool=true, attributes: [NSObject : AnyObject]?=nil) {
        self.debugOperation {(error) -> (Void) in
            self.createDirectoryAtPath(path, withIntermediateDirectories: createIntermediates, attributes: attributes, error: error)
        }
    }

    func createDirectory(#url: NSURL, createIntermediates: Bool=true, attributes: [NSObject : AnyObject]?=nil) {
        self.debugOperation {(error) -> (Void) in
            self.createDirectoryAtURL(url, withIntermediateDirectories: createIntermediates, attributes: attributes, error: error)
        }
    }

    func createFile(#URL: NSURL, contents: NSData?=nil, attributes: [NSObject : AnyObject]?=nil) {
        self.createFileAtPath(URL.path!, contents: contents, attributes: attributes)
    }

    func deleteFile(#URL: NSURL) {
        self.debugOperation {(error) -> (Void) in
            self.removeItemAtURL(URL, error: error)
        }
    }

    func groupContainerURL(#groupIdentifier: String) -> NSURL {
        return self.containerURLForSecurityApplicationGroupIdentifier(groupIdentifier)!
    }

    func groupContainerPath(#groupIdentifier: String) -> String {
        return self
            .groupContainerURL(groupIdentifier: groupIdentifier)
            .asString()
    }

    func lastModifiedFile(#directoryURL: NSURL) -> String? {
        var lastModifiedFile: NSURL? = self
            .contents(directoryURL: directoryURL, propertyKeys: [NSURLContentModificationDateKey, ])?
            .sorted({(firstURL, secondURL) -> Bool in
                let isBefore: Bool
                if let firstModified = firstURL[NSURLContentModificationDateKey] as? NSDate, let secondModified = secondURL[NSURLContentModificationDateKey] as? NSDate {
                    isBefore = (firstModified.compare(secondModified) == NSComparisonResult.OrderedDescending)
                }
                else {
                    isBefore = false
                }
                return isBefore
            })
            .firstItem()
        return lastModifiedFile?.lastPathComponent
    }
}
