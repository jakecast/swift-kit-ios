import UIKit

public func - (left: NSIndexPath, right: NSIndexPath) -> NSIndexPath {
    return NSIndexPath(forItem: (left.item - right.item), inSection: (left.section - right.section))
}

public func + (left: NSIndexPath, right: NSIndexPath) -> NSIndexPath {
    return NSIndexPath(forItem: (left.item + right.item), inSection: (left.section + right.section))
}

public func > (left: NSIndexPath, right: NSIndexPath) -> Bool {
    let greaterThan: Bool
    if left.section > right.section {
        greaterThan = true
    }
    else if right.section > left.section {
        greaterThan = false
    }
    else if left.item > right.item {
        greaterThan = true
    }
    else {
        greaterThan = false
    }
    return greaterThan
}

public func >= (left: NSIndexPath, right: NSIndexPath) -> Bool {
    return (left > right || left == right)
}

public func < (left: NSIndexPath, right: NSIndexPath) -> Bool {
    let lessThan: Bool
    if left.section < right.section {
        lessThan = true
    }
    else if right.section < left.section {
        lessThan = false
    }
    else if left.item < right.item {
        lessThan = true
    }
    else {
        lessThan = false
    }
    return lessThan
}

public func <= (left: NSIndexPath, right: NSIndexPath) -> Bool {
    return (left < right || left == right)
}
