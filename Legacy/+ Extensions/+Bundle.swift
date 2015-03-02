import UIKit

public extension Bundle {
    class var mainInstance: Bundle {
        return self.mainBundle()
    }

    func resourceURL(#name: String, ext: String) -> URL? {
        return self.URLForResource(name, withExtension: ext)
    }
}