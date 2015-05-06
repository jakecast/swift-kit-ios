import Foundation

public extension String.UTF16View {
    func unicharAtIndex(index: Int) -> unichar {
        return self[advance(self.startIndex, index)]
    }
}
