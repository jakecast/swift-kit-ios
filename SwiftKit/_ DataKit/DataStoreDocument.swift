import CoreData
import UIKit

public class DataStoreDocument: UIManagedDocument {
    private static var dataStoreModel: NSManagedObjectModel? = nil
    private static var dataStoreOptions: [NSObject:AnyObject]? = nil

    public override var managedObjectModel: NSManagedObjectModel {
        return DataStoreDocument.dataStoreModel ?? NSManagedObjectModel()
    }

    public override var persistentStoreOptions: [NSObject:AnyObject]? {
        get {
            return DataStoreDocument.dataStoreOptions
        }
        set(newValue) {
            self.persistentStoreOptions = newValue
        }
    }

    public override class func persistentStoreName() -> String {
        return "store"
    }

    public convenience init(dataStorePath: String, dataStoreModel: NSManagedObjectModel, dataStoreOptions: [NSObject:AnyObject]?=nil) {
        DataStoreDocument.dataStoreModel = dataStoreModel
        DataStoreDocument.dataStoreOptions = dataStoreOptions
        self.init(fileURL: dataStorePath.asFileURL() ?? NSURL.null)

        if NSFileManager.defaultManager().fileExistsAtPath(dataStorePath) {
            self.openDatabase()
        }
        else {
            self.saveToURL(self.fileURL, forSaveOperation: UIDocumentSaveOperation.ForCreating, completionHandler: {(success) -> Void in
                self.openDatabase()
            })
        }
    }

    public override func configurePersistentStoreCoordinatorForURL(
        storeURL: NSURL!,
        ofType fileType: String!,
        modelConfiguration configuration: String?,
        storeOptions: [NSObject : AnyObject]?,
        error: NSErrorPointer
    ) -> Bool {
        println(storeURL)
        return super.configurePersistentStoreCoordinatorForURL(storeURL, ofType: fileType, modelConfiguration: configuration, storeOptions: storeOptions, error: error)
    }

    private func openDatabase() {
        self.openWithCompletionHandler(nil)
    }
}
