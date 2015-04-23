import CoreData

extension DataStore: DirectoryMonitorDelegate {
    internal var dataStoreNotifyFolderURL: NSURL {
        return NSURL(string: self.dataStorePath.stringByAppendingPathComponent("notify")) ?? NSURL()
    }

    internal var dataStoreNotifyFilename: String {
        return "\(self.appContext.rawValue).notify"
    }

    internal var dataStoreNotifyFileURL: NSURL {
        return NSURL(string: self.dataStoreNotifyFolderURL.path!.stringByAppendingPathComponent(self.dataStoreNotifyFilename)) ?? NSURL()
    }

    internal func setupExtensionMonitor() {
        if self.appContext != AppContext.None {
            self.dataStoreQueue.dispatch {
                self.dataStoreFileManager.createDirectory(
                    path: self.dataStoreNotifyFolderURL.path!
                )
                self.directoryMonitor = DirectoryMonitor(
                    directoryURL: self.dataStoreNotifyFolderURL,
                    queue: self.dataStoreQueue,
                    fileManager: self.dataStoreFileManager
                )
                self.directoryMonitor?.startMonitoring(
                    delegate: self
                )
            }
        }
    }
    
    internal func sendPersistentStoreSavedNotification() {
        if self.appContext != AppContext.None {
            self.dataStoreQueue.dispatch {
                self.dataStoreFileManager.createFile(URL: self.dataStoreNotifyFileURL)
                self.dataStoreFileManager.set(attributes: [NSFileModificationDate:NSDate()], filePath: self.dataStoreNotifyFolderURL.path)
            }
        }
    }
    
    public func directoryMonitorDidObserveChange(#directoryMonitor: DirectoryMonitor, filePath: String) {
        if filePath != self.dataStoreNotifyFilename {
            self.resetContexts()
        }
    }
}
