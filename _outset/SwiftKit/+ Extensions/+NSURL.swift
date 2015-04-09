import UIKit

public extension NSURL {
    convenience init?(groupIdentifier: String, filename: String) {
        let containerPath = NSFileManager
            .defaultManager()
            .groupContainerPath(groupIdentifier: groupIdentifier)
        let filePath = containerPath.append(pathComponent: filename)

        self.init(string: filePath)
    }

    convenience init?(managedObjectHost: String, managedObjectPath: String) {
        self.init(scheme: "x-coredata", host: managedObjectHost, path: managedObjectPath)
    }

    var components: [String]? {
        return self.pathComponents?
            .map{ return $0 as? String }
            .filter { return $0 != nil }
            .map { return $0! }
    }

    func asString() -> String {
        return self.absoluteString ?? String.null
    }

    func resourceValue(#key: String) -> AnyObject? {
        return self.resourceValues(keys: [key, ])?[key]
    }

    func resourceValues(#keys: [String]) -> [String:AnyObject]? {
        var resourceValues: [String:AnyObject]?
        NSError.performOperation {(error) -> (Void) in
            resourceValues = self.resourceValuesForKeys(keys, error: error) as? [String:AnyObject]
        }
        return resourceValues
    }

    subscript(resourceKey: String) -> AnyObject? {
        return self.resourceValue(key: resourceKey)
    }
}
