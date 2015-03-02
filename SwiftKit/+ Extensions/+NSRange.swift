import UIKit

public extension NSRange {
    public init(location: Int, length: Int) {
        self = NSMakeRange(location, length)
    }
}