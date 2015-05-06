import Foundation
import UIKit

public extension NSError {
    static var isDebugMode: Bool {
        return UIDevice.isSimulator
    }

    static func debugError(isDebugging: Bool?=nil, error: NSError?) {
        if error != nil && (isDebugging ?? self.isDebugMode) == true {
            if let localizedDescription = error?.localizedDescription {
                println("an error occured: \(localizedDescription)")
            }
            else if let domain = error?.domain, let code = error?.code {
                println("an error occured: \(domain) with code: \(code)")
            }
            else {
                println("an error occured")
            }
        }
    }

    static func performOperation(isDebugging: Bool?=nil, _ operation: (NSErrorPointer)->(Void)) {
        var error: NSError?
        self.performOperation({ operation(&error) })
            .debugError(isDebugging: isDebugging, error: error)
    }

    static private func performOperation(operation: (Void)->(Void)) -> NSError.Type {
        operation()
        return self
    }
}
