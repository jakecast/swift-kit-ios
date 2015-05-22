import Foundation

public enum OperationState {
    case Ready
    case Executing
    case Finished

    public var keyPath: String {
        switch self {
        case .Ready:
            return "isReady"
        case .Executing:
            return "isExecuting"
        case .Finished:
            return "isFinished"
        }
    }
}
