import UIKit

public extension String {
    var length: Int {
        return count(self)
    }

    static func debugOperation(operationBlock: (NSErrorPointer) -> (Void)) {
        var errorPointer: NSError?
        operationBlock(&errorPointer)
        
        if errorPointer != nil && UIDevice.isSimulator == true {
            if let localizedDescription = errorPointer?.localizedDescription {
                println("an error occured: \(localizedDescription)")
            }
            else if let domain = errorPointer?.domain, let code = errorPointer?.code {
                println("an error occured: \(domain) with code: \(code)")
            }
            else {
                println("an error occured")
            }
        }
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

    func write(#fileURL: NSURL, atomically: Bool=true, encoding: NSStringEncoding=NSUTF8StringEncoding) {
        String.debugOperation {(error) -> (Void) in
            self.writeToURL(fileURL, atomically: atomically, encoding: encoding, error: error)
        }
    }
}
