import Foundation

public enum OperationState: Printable {
    case Ready
    case Executing
    case Finished
    
    public var description: String {
        return self.keyPath
    }

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
