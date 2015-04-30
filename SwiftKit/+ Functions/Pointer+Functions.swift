import Foundation

public func unsafePointer(object: AnyObject?) -> UnsafePointer<Void>? {
    var unsafePointer: UnsafePointer<Void>?
    if let pointerObject: AnyObject = object {
        unsafePointer = unsafeAddressOf(pointerObject)
    }
    else {
        unsafePointer = nil
    }
    
    return unsafePointer
}
