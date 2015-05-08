import Foundation
import CoreData

public class EntityOperation: BaseOperation {
    public var context: NSManagedObjectContext? = nil
    public var objectID: NSManagedObjectID? = nil
    public var saveContext: Bool? = nil

    public init(
        context: NSManagedObjectContext,
        objectID: NSManagedObjectID,
        saveContext: Bool=true,
        asynchronousOperation: Bool=true
    ) {
        super.init()
        self.asynchronousOperation = asynchronousOperation
        self.context = context
        self.objectID = objectID
        self.saveContext = saveContext
    }

    public override func operationWillEnd() {
        super.operationWillEnd()

        if self.saveContext == true {
            self.context?.saveContext()
        }
    }
}
