import Foundation

public enum DataStoreType: String {
    case None = "none"
    case App = "app"
    case TodayExtension = "today"
    
    var notifyFilename: String {
        return "\(self.rawValue).notify"
    }
}
