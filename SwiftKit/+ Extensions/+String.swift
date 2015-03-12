import UIKit

public extension String {
    var length: Int {
        return count(self)
    }

    func append(#pathComponent: String) -> String {
        return self.stringByAppendingPathComponent(pathComponent)
    }

    func toNumber() -> Float? {
        return (self.toInt() != nil) ? (self as NSString).floatValue : nil
    }

    func urlPathEncode() -> String {
        return self.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLPathAllowedCharacterSet()) ?? ""
    }
}
