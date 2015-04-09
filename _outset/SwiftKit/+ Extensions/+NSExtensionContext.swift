import UIKit

public extension NSExtensionContext {
    func open(#url: NSURL, completion: (Bool -> Void)?=nil) {
        self.openURL(url, completionHandler: completion)
    }
}
