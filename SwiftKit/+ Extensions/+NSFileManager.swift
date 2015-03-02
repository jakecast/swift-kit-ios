import UIKit

public extension NSFileManager {
    class var defaultInstance: NSFileManager {
        return self.defaultManager()
    }

    func groupContainerURL(#groupIdentifier: String) -> NSURL {
        return self.containerURLForSecurityApplicationGroupIdentifier(groupIdentifier)!
    }

    func groupContainerPath(#groupIdentifier: String) -> String {
        return self
            .groupContainerURL(groupIdentifier: groupIdentifier)
            .asString()
    }
}
