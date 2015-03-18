import CoreData
import UIKit

public extension NSPersistentStoreCoordinator {
    class var defaultStoreOptions: [NSObject:AnyObject] {
        return [
            NSInferMappingModelAutomaticallyOption: true,
            NSMigratePersistentStoresAutomaticallyOption: true,
        ]
    }

    func setupStore(#storeType: String, storeURL: NSURL, storeOptions: [NSObject:AnyObject]?=nil) {
        self.debugOperation {(error) -> (Void) in
            self.performBlockAndWait {
                self.addPersistentStoreWithType(storeType, configuration: nil, URL: storeURL, options: storeOptions, error: error)
            }
        }
    }
}
