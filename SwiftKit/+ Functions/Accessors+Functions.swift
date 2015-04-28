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

public func all<A, B>(a: A?, b: B?) -> (A, B)? {
    switch (a, b) {
    case let (.Some(a), .Some(b)):
        return .Some((a, b))
    default:
        return .None
    }
}

public func all<A, B, C>(a: A?, b: B?, c: C?) -> (A, B, C)? {
    switch (a, b, c) {
    case let (.Some(a), .Some(b), .Some(c)):
        return .Some((a, b, c))
    default:
        return .None
    }
}

public func all<A, B, C, D>(a: A?, b: B?, c: C?, d: D?) -> (A, B, C, D)? {
    switch (a, b, c, d) {
    case let (.Some(a), .Some(b), .Some(c), .Some(d)):
        return .Some((a, b, c, d))
    default:
        return .None
    }
}
