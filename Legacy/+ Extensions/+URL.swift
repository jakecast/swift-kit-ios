import UIKit

public extension URL {
    convenience init?(groupIdentifier: String, filename: String) {
        let containerPath = NSFileManager
            .defaultManager()
            .groupContainerPath(groupIdentifier: groupIdentifier)
        let filePath = containerPath.append(pathComponent: filename)

        self.init(string: filePath)
    }

    func asString() -> String {
        return self.absoluteString ?? String()
    }
}