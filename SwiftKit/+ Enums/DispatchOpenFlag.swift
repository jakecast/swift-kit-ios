import Foundation

public enum OpenFlag {
    case Event
    case Create
    case Directory

    var rawValue: CInt {
        let rawValue: CInt
        switch self {
        case .Event:
            rawValue = O_EVTONLY
        case .Create:
            rawValue = O_CREAT
        case .Directory:
            rawValue = O_DIRECTORY
        }
        return rawValue
    }
}
