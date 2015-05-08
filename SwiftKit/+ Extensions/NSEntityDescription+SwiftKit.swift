import CoreData

public extension NSEntityDescription {
    static var null: NSEntityDescription {
        return NSEntityDescription()
    }
    
    static func entityDescription(#name: String, context: NSManagedObjectContext) -> NSEntityDescription {
        return self.entityForName(name, inManagedObjectContext: context) ?? NSEntityDescription.null
    }
}
