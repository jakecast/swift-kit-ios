import UIKit

public extension FileManager {
    class var defaultInstance: FileManager {
        return self.defaultManager()
    }

    func groupContainerURL(#groupIdentifier: String) -> URL {
        return self.containerURLForSecurityApplicationGroupIdentifier(groupIdentifier)!
    }

    func groupContainerPath(#groupIdentifier: String) -> String {
        return self
            .groupContainerURL(groupIdentifier: groupIdentifier)
            .asString()
    }
}