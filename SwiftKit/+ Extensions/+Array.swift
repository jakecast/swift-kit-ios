import Foundation

extension Array {
    internal func firstItem() -> Element? {
        return self.first
    }

    internal func lastItem() -> Element? {
        return self.last
    }

    internal func contains<AnyObject>(item: AnyObject) -> Bool {
        return contains(self, item)
    }

    internal func each(block: ((Element)->(Void))) {
        for element in self {
            block(element)
        }
    }

    internal func each(call: ((Int, Element)->(Void))) {
        for (index, item) in enumerate(self) {
            call(index, item)
        }
    }

    internal mutating func remove<T: Equatable>(removeElement: T) {
        self = self.filter { return ($0 as? T != removeElement) }
    }
}
