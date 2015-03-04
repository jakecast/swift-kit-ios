import Foundation

public extension NSPredicate {
    convenience init(attributes: [String: AnyObject]) {
        self.init(
            format: join(" AND ", map(attributes, {(key, value) in "\(key) == \(value)"})),
            argumentArray: nil
        )
    }
}

