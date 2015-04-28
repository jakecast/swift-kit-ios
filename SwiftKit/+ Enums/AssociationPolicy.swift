import Foundation

public enum AssociationPolicy {
    case Assign
    case CopyAtomic
    case CopyNonAtomic
    case RetainAtomic
    case RetainNonAtomic

    var intValue: Int {
        let intValue: Int
        switch self {
        case .Assign:
            intValue = OBJC_ASSOCIATION_ASSIGN
        case .CopyAtomic:
            intValue = OBJC_ASSOCIATION_COPY
        case .CopyNonAtomic:
            intValue = OBJC_ASSOCIATION_COPY_NONATOMIC
        case .RetainAtomic:
            intValue = OBJC_ASSOCIATION_RETAIN
        case .RetainNonAtomic:
            intValue = OBJC_ASSOCIATION_RETAIN_NONATOMIC
        }
        return intValue
    }

    var uintValue: UInt {
        return UInt(self.intValue)
    }
}
