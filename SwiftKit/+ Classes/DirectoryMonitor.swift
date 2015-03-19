import Foundation

public class DirectoryMonitor {
    let directoryURL: NSURL
    
    var directoryDescriptor: CInt?
    var directoryMonitorSource: dispatch_source_t?

    weak var fileManager: NSFileManager?
    weak var delegate: DirectoryMonitorDelegate?

    public init(directoryURL: NSURL, queue: NSOperationQueue, fileManager: NSFileManager) {
        self.directoryURL = directoryURL
        self.directoryDescriptor = open(self.directoryURL.path!, OpenFlag.Event.rawValue)
        self.directoryMonitorSource = dispatch_source_create(
            DispatchSourceType.Vnode.rawValue,
            UInt(self.directoryDescriptor!),
            DispatchSourceMask.Attrib.rawValue | DispatchSourceMask.Delete.rawValue,
            queue.underlyingQueue
        )
        self.fileManager = fileManager
        dispatch_source_set_event_handler(self.directoryMonitorSource!, self.directoryDidChange)
        dispatch_source_set_cancel_handler(self.directoryMonitorSource!, self.directoryMonitorDidStop)
    }

    deinit {
        self.stopMonitoring()
    }
    
    public func startMonitoring(#delegate: DirectoryMonitorDelegate) {
        if let directorySource = self.directoryMonitorSource {
            self.delegate = delegate
            dispatch_resume(directorySource)
        }
    }
    
    func stopMonitoring() {
        if let directorySource = self.directoryMonitorSource {
            dispatch_source_cancel(directorySource)
        }
    }

    func directoryDidChange() {
        if let filePath = self.fileManager?.lastModifiedFile(directoryURL: self.directoryURL) {
            self.delegate?.directoryMonitorDidObserveChange(directoryMonitor: self, filePath: filePath)
        }
    }

    func directoryMonitorDidStop() {
        if let directoryDescriptor = self.directoryDescriptor, let directorySource = self.directoryMonitorSource {
            close(directoryDescriptor)
            
            self.directoryDescriptor = nil
            self.directoryMonitorSource = nil
        }
    }
}
