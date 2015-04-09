import Foundation

public enum DispatchSourceType {
    case DataAdd
    case DataOr
    case MachRecv
    case MachSend
    case Proc
    case Read
    case Signal
    case Timer
    case Vnode
    case Write
    case Memorypressure
    
    var rawValue: dispatch_source_type_t {
        let rawValue: dispatch_source_type_t
        switch self {
        case .DataAdd:
            rawValue = DISPATCH_SOURCE_TYPE_DATA_ADD
        case .DataOr:
            rawValue = DISPATCH_SOURCE_TYPE_DATA_OR
        case .MachRecv:
            rawValue = DISPATCH_SOURCE_TYPE_MACH_RECV
        case .MachSend:
            rawValue = DISPATCH_SOURCE_TYPE_MACH_SEND
        case .Proc:
            rawValue = DISPATCH_SOURCE_TYPE_PROC
        case .Read:
            rawValue = DISPATCH_SOURCE_TYPE_READ
        case .Signal:
            rawValue = DISPATCH_SOURCE_TYPE_SIGNAL
        case .Timer:
            rawValue = DISPATCH_SOURCE_TYPE_TIMER
        case .Vnode:
            rawValue = DISPATCH_SOURCE_TYPE_VNODE
        case .Write:
            rawValue = DISPATCH_SOURCE_TYPE_WRITE 
        case .Memorypressure:
            rawValue = DISPATCH_SOURCE_TYPE_MEMORYPRESSURE
        }
        return rawValue
    }
}
