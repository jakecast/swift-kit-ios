import UIKit

public extension PersistentStoreCoordinator {
    convenience init(
        modelName: String,
        modelBundle: Bundle,
        storeName: String,
        storeType: String,
        groupIdentifier: String
    ) {
        let managedObjectModel = ManagedObjectModel(
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
            URL: URL(groupIdentifier: groupIdentifier, filename: storeName)!,
            options: nil,
            error: nil
        )
    }
}