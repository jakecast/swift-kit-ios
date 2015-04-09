import Foundation

public enum DispatchSourceMask {
    case Attrib
    case Delete
    case Extend
    case Link
    case Rename
    case Revoke
    case Write

    var rawValue: UInt {
        let rawValue: UInt
        switch self {
        case .Attrib:
            rawValue = DISPATCH_VNODE_ATTRIB
        case .Delete:
            rawValue = DISPATCH_VNODE_DELETE
        case .Extend:
            rawValue = DISPATCH_VNODE_EXTEND
        case .Link:
            rawValue = DISPATCH_VNODE_LINK
        case .Rename:
            rawValue = DISPATCH_VNODE_RENAME
        case .Revoke:
            rawValue = DISPATCH_VNODE_REVOKE
        case .Write:
            rawValue = DISPATCH_VNODE_WRITE
        }
        return rawValue
    }
}