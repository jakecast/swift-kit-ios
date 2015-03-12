import CoreData
import UIKit

public extension NSPersistentStoreCoordinator {
    func setupStore(#storeType: String, storeURL: NSURL) {
        self.debugOperation {(error) -> (Void) in
            self.addPersistentStoreWithType(
                storeType,
                configuration: nil,
                URL: storeURL,
                options: nil,
                error: error
            )
        }
    }
}
