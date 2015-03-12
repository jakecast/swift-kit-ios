import Foundation

public func getElement<S: CollectionType>(source: S, index: S.Index) -> S.Generator.Element? {
    var element: S.Generator.Element?
    if count(source) > 1 {
        element = source[index]
    }
    return element
}
