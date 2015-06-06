import UIKit

public extension NSFileManager {
    func contents(
        #directoryURL: NSURL,
        propertyKeys: [AnyObject]?=nil,
        options: NSDirectoryEnumerationOptions=NSDirectoryEnumerationOptions.SkipsHiddenFiles
    ) -> [NSURL]? {
        var directoryContents: [AnyObject]?
        NSError.performOperation {(error) -> (Void) in
            directoryContents = self.contentsOfDirectoryAtURL(directoryURL, includingPropertiesForKeys: propertyKeys, options: options, error: error)
        }
        return directoryContents as? [NSURL]
    }
    
    func createDirectory(#path: String, createIntermediates: Bool=true, attributes: [NSObject : AnyObject]?=nil) {
        NSError.performOperation {(error) -> (Void) in
            self.createDirectoryAtPath(path, withIntermediateDirectories: createIntermediates, attributes: attributes, error: error)
        }
    }

    func createDirectory(#url: NSURL, createIntermediates: Bool=true, attributes: [NSObject : AnyObject]?=nil) {
        NSError.performOperation {(error) -> (Void) in
            self.createDirectoryAtURL(url, withIntermediateDirectories: createIntermediates, attributes: attributes, error: error)
        }
    }
    
    func createFile(#filePath: String, contents: NSData?=nil, attributes: [NSObject : AnyObject]?=nil) {
        self.createFileAtPath(filePath, contents: contents, attributes: attributes)
    }

    func createFile(#URL: NSURL, contents: NSData?=nil, attributes: [NSObject : AnyObject]?=nil) {
        if let filePath = URL.path {
            self.createFile(filePath: filePath, contents: contents, attributes: attributes)
        }
    }

    func deleteFile(#filePath: String) {
        NSError.performOperation {(error) -> (Void) in
            self.removeItemAtPath(filePath, error: error)
        }
    }

    func deleteFile(#URL: NSURL) {
        NSError.performOperation {(error) -> (Void) in
            self.removeItemAtURL(URL, error: error)
        }
    }
    
    func fileExists(#url: NSURL) -> Bool {
        let fileExists: Bool
        if let path = url.path {
            fileExists = self.fileExistsAtPath(path)
        }
        else {
            fileExists = false
        }
        return fileExists
    }

    func getObjectData(#fileURL: NSURL) -> AnyObject? {
        var fileContents: AnyObject?
        if let filePath = fileURL.path, let fileData = self.contentsAtPath(filePath) {
            fileContents = NSKeyedUnarchiver.unarchiveObjectWithData(fileData)
        }
        else {
            fileContents = nil
        }
        return fileContents
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

    func set(#attributes: [NSObject:AnyObject], filePath: String?) {
        if let path = filePath {
            NSError.performOperation {(error) -> (Void) in
                self.setAttributes(attributes, ofItemAtPath: path, error: error)
            }
        }
    }

    func writeObjectData(#object: AnyObject, fileURL: NSURL) {
        if let filePath = fileURL.path, let folderURL = filePath.stringByDeletingLastPathComponent.asURL(), let folderPath = folderURL.path {
            if self.fileExistsAtPath(folderPath) == false {
                self.createDirectory(url: fileURL, createIntermediates: true)
            }
        }

        if self.fileExists(url: fileURL) {
            self.deleteFile(URL: fileURL)
        }

        self.createFile(URL: fileURL, contents: NSKeyedArchiver.archivedDataWithRootObject(object))
    }
}
