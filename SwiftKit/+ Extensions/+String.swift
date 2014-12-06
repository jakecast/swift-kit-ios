import UIKit


public extension String {
    func toNumber() -> Float? {
        return (self.toInt() != nil) ? (self as NSString).floatValue : nil
    }

    func append(#pathComponent: String) -> String {
        return self.stringByAppendingPathComponent(pathComponent)
    }


}