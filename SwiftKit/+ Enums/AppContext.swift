import Foundation

public enum AppContext: String {
    case None = "None"
    case MainApp = "MainApp"
    case TodayExtension = "Today"

    public var isExtension: Bool {
        let isExtension: Bool
        switch self {
        case .TodayExtension:
            isExtension = true
        case .MainApp, .None:
            isExtension = false
        }
        return isExtension
    }

    public var isMainApp: Bool {
        let isMainApp: Bool
        switch self {
        case .MainApp:
            isMainApp = true
        case .TodayExtension, .None:
            isMainApp = false
        }
        return isMainApp
    }
}