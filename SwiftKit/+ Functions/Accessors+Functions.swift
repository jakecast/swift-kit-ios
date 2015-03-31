import Foundation

public func get<S: CollectionType where S.Index: Comparable>(source: S?, index: S.Index) -> S.Generator.Element? {
    var element: S.Generator.Element?
    if let sourceCollection = source {
        if sourceCollection.endIndex > index {
            element = sourceCollection[index]
        }
    }
    return element
}

public func perform<S: CollectionType>(source: S, block: ((S.Generator.Element)->(Void))) {
    for item in source {
        block(item)
    }
}

public func pop<S: _ArrayType>(inout source: S) -> S.Generator.Element? {
    var element: S.Generator.Element?
    if source.isEmpty == false {
        element = removeAtIndex(&source, source.startIndex)
    }
    return element
}

public func pop<S: RangeReplaceableCollectionType where S.Index: Comparable>(inout source: S, index: S.Index) -> S.Generator.Element? {
    var element: S.Generator.Element?
    if source.endIndex > index {
        element = removeAtIndex(&source, index)
    }
    return element
}
