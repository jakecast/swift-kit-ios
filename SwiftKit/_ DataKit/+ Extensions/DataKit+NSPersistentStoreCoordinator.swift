import CoreData
import UIKit

public extension NSPersistentStoreCoordinator {
    convenience init(
        modelName: String,
        modelBundle: NSBundle,
        storeName: String,
        storeType: String,
        groupIdentifier: String
    ) {
            let managedObjectModel = NSManagedObjectModel(
                modelName: modelName,
                bundle: modelBundle
            )!
            self.init(managedObjectModel: managedObjectModel)
            self.setupStore(
                storeName: storeName,
                storeType: storeType,
                groupIdentifier: groupIdentifier
            )
    }

    func setupStore(#storeName: String, storeType: String, groupIdentifier: String) {
        self.addPersistentStoreWithType(
            storeType,
            configuration: nil,
            URL: NSURL(groupIdentifier: groupIdentifier, filename: storeName)!,
            options: nil,
            error: nil
        )
    }
}
