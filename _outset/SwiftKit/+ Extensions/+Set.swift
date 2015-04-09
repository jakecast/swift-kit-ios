import UIKit

extension Set {
    var arrayValue: [Element] {
        return self.asArray()
    }

    func asArray() -> [Element] {
        return Array(self)
    }
}