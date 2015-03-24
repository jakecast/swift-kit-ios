import Foundation

public func + <KeyType, ValueType>(left: [KeyType:ValueType], right: [KeyType:ValueType]) -> [KeyType:ValueType] {
    var result: [KeyType:ValueType] = [:]
    for (k, v) in left {
        result[k] = v
    }
    for (k, v) in right {
        result[k] = v
    }

    return result
}
