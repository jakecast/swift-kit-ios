import Foundation

public protocol DirectoryMonitorDelegate: class {
    func directoryMonitorDidObserveChange(#directoryMonitor: DirectoryMonitor, filePath: String)
}
