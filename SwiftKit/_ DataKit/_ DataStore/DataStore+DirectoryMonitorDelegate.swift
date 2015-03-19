import CoreData

extension DataStore: DirectoryMonitorDelegate {
    internal var dataStoreFileManager: NSFileManager {
        return Class.dataStoreFileManager
    }
    
    internal var dataStoreMonitorQueue: NSOperationQueue {
        return Class.dataStoreMonitorQueue
    }

    internal func setupStoreMonitor() {
        if self.dataStoreType != DataStoreType.None {
            self.dataStoreMonitorQueue.dispatch {
                self.dataStoreFileManager.createDirectory(path: self.storeNotifyFolderURL.path!)
                self.directoryMonitor = DirectoryMonitor(
                    directoryURL: self.storeNotifyFolderURL,
                    queue: self.dataStoreMonitorQueue,
                    fileManager: self.dataStoreFileManager
                )
                self.directoryMonitor?.startMonitoring(delegate: self)
            }
        }
    }
    
    internal func sendPersistentStoreSavedNotification() {
        if self.dataStoreType != DataStoreType.None {
            self.dataStoreMonitorQueue.dispatchSync {
                self.dataStoreFileManager.createFile(URL: self.storeNotifyFileURL)
                self.dataStoreFileManager.setAttributes([NSFileModificationDate:NSDate()], ofItemAtPath: self.storeNotifyFolderURL.path!, error: nil)
            }
        }
    }
    
    public func directoryMonitorDidObserveChange(#directoryMonitor: DirectoryMonitor, filePath: String) {
        if filePath != self.dataStoreType.notifyFilename {
            self.resetContexts()
        }
    }
}
