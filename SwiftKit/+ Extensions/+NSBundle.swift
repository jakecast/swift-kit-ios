import UIKit

public extension NSBundle {
    static var mainInstance: NSBundle {
        return self.mainBundle()
    }

    func resourceURL(#name: String, ext: String) -> NSURL? {
        return self.URLForResource(name, withExtension: ext)
    }
    
    func resourcePath(#name: String, ext: String) -> String? {
        return self.pathForResource(name, ofType: ext)
    }
}
