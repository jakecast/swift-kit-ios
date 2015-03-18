import UIKit

public extension NSURL {
    convenience init?(groupIdentifier: String, filename: String) {
        let containerPath = NSFileManager
            .defaultManager()
            .groupContainerPath(groupIdentifier: groupIdentifier)
        let filePath = containerPath.append(pathComponent: filename)

        self.init(string: filePath)
    }

    var directory: String? {
        return self.path?.stringByDeletingLastPathComponent
    }

    func asString() -> String {
        return self.absoluteString ?? ""
    }

    func resourceValue(#key: String) -> AnyObject? {
        return self.resourceValues(keys: [key, ])?[key]
    }

    func resourceValues(#keys: [String]) -> [String:AnyObject]? {
        var resourceValues: [String:AnyObject]?
        self.debugOperation {(error) -> (Void) in
            resourceValues = self.resourceValuesForKeys(keys, error: error) as? [String:AnyObject]
        }
        return resourceValues
    }

    subscript(resourceKey: String) -> AnyObject? {
        return self.resourceValue(key: resourceKey)
    }
}
