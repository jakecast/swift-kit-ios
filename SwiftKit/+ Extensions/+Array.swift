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

    internal mutating func removeItem<T: Equatable>(removeItem: T) {
        for (idx, item) in enumerate(self) {
            if let arrItem = item as? T {
                if arrItem == removeItem {
                    self.removeAtIndex(idx)
                }
            }
        }
    }

    func test() -> String {
        return "hello"
    }
}
