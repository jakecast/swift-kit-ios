import Foundation

public extension NSCharacterSet {
    static var null: NSCharacterSet {
        return self.nullSet()
    }
    
    static func nullSet() -> NSCharacterSet {
        return NSCharacterSet()
    }
}
