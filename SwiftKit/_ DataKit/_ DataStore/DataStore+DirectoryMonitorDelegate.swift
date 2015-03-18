import CoreData

extension DataStore: DirectoryMonitorDelegate {
    internal func setupStoreMonitor() {
        if self.dataStoreType != DataStoreType.None {
            self.fileManager.createDirectory(path: self.storeNotifyFolderURL.path!)
            self.directoryMonitor = DirectoryMonitor(directoryURL: self.storeNotifyFolderURL)
            self.directoryMonitor?.startMonitoring(delegate: self)
        }
    }
    
    internal func sendPersistentStoreSavedNotification() {
        if self.dataStoreType != DataStoreType.None {
            self.fileManager.createFile(URL: self.storeNotifyFileURL)
            self.fileManager.setAttributes([NSFileModificationDate:NSDate()], ofItemAtPath: self.storeNotifyFolderURL.path!, error: nil)
        }
    }
    
    public func directoryMonitorDidObserveChange(#directoryMonitor: DirectoryMonitor, filePath: String) {
        if filePath != self.dataStoreType.notifyFilename {
            self.resetContexts()
        }
    }
}
