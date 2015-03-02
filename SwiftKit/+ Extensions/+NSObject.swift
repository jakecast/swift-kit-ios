import UIKit

public extension NSObject {
    func debugOperation(operationBlock: (NSErrorPointer)->(Void)) {
        var errorPointer: NSError?
        operationBlock(&errorPointer)
        
        if let error = errorPointer {
            println("an error occured: \(error)")
        }
    }

    func isClass(#classType: AnyClass!) -> Bool {
        return self.isMemberOfClass(classType)
    }

    func isKind(#classKind: AnyClass!) -> Bool {
        return self.isKindOfClass(classKind)
    }
}
