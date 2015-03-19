import Foundation

public func getElement<S: CollectionType where S.Index: Comparable>(source: S?, index: S.Index) -> S.Generator.Element? {
    var element: S.Generator.Element?
    if let sourceCollection = source {
        if sourceCollection.endIndex > index {
            element = sourceCollection[index]
        }
    }
    return element
}

public func popElement<S: _ArrayType>(inout source: S) -> S.Generator.Element? {
    var element: S.Generator.Element?
    if source.isEmpty == false {
        element = removeAtIndex(&source, source.startIndex)
    }
    return element
}

public func popElement<S: RangeReplaceableCollectionType where S.Index: Comparable>(inout source: S, index: S.Index) -> S.Generator.Element? {
    var element: S.Generator.Element?
    if source.endIndex > index {
        element = removeAtIndex(&source, index)
    }
    return element
}
