import UIKit

extension Predicate {
    convenience init(attributes: [String: AnyObject]) {
        self.init(
            format: join(" AND ", map(attributes, {(key, value) in "\(key) == \(value)"})),
            argumentArray: nil
        )
    }
}