import UIKit

public extension NSRange {
    public init(location: Int, length: Int) {
        self = NSMakeRange(location, length)
    }

    func asRange(#string: String) -> Range<String.Index> {
        return Range(
            start: advance(string.startIndex, self.location),
            end: advance(string.startIndex, self.location + self.length)
        )
    }
}
