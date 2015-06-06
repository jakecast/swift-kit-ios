import Foundation

public enum AppContext: String {
    case None = "None"
    case MainApp = "MainApp"
    case TodayExtension = "Today"

    public static var appGroupIdentifier: String? = nil

    public init(context: AppContext, appGroupIdentifier: String) {
        self = context
        self.set(appGroupIdentifier: appGroupIdentifier)
    }

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

    private func set(#appGroupIdentifier: String) {
        AppContext.appGroupIdentifier = appGroupIdentifier
    }
}