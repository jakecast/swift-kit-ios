import Foundation

public extension NSQualityOfService {
    public var qosClass: dispatch_qos_class_t {
        let qosClass: dispatch_qos_class_t
        switch self {
        case .Background:
            qosClass = QOS_CLASS_BACKGROUND
        case .Default:
            qosClass = QOS_CLASS_DEFAULT
        case .UserInteractive:
            qosClass = QOS_CLASS_USER_INTERACTIVE
        case .UserInitiated:
            qosClass = QOS_CLASS_USER_INITIATED
        case .Utility:
            qosClass = QOS_CLASS_UTILITY
        }
        return qosClass
    }
}
