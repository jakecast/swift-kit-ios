import QuartzCore

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

public func += (inout left: [AnyObject], right: [AnyObject]) {
    left = left + right
}

public func + (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x + right.x, y: left.y + right.y)
}

public func - (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x - right.x, y: left.y - right.y)
}
