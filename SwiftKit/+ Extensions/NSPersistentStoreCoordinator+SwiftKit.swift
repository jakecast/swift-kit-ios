import CoreData

public extension NSPersistentStoreCoordinator {
    static var defaultStoreOptions: [NSObject:AnyObject] {
        return [
            NSInferMappingModelAutomaticallyOption: true,
            NSMigratePersistentStoresAutomaticallyOption: true,
        ]
    }

    func setupStore(#storeType: String, storeURL: NSURL?, storeOptions: [NSObject:AnyObject]?=nil) {
        NSError.performOperation {(error) -> (Void) in
            if self.persistentStores.isEmpty == true {
                self.addPersistentStoreWithType(storeType, configuration: nil, URL: storeURL, options: storeOptions, error: error)
            }
        }
    }

    func getPersistentStore(#storeURL: NSURL, options: [NSObject:AnyObject]?=nil) -> NSPersistentStore {
        return NSPersistentStore(persistentStoreCoordinator: self, configurationName: nil, URL: storeURL, options: options)
    }
    
    func storeExists(#storeURL: NSURL) -> Bool {
        return NSFileManager
            .defaultManager()
            .fileExists(url: storeURL)
    }

    subscript(objectURI: NSURL) -> NSManagedObjectID? {
        return self.managedObjectIDForURIRepresentation(objectURI)
    }
}
