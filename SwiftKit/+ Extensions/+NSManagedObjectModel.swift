import CoreData

public extension NSManagedObjectModel {
    convenience init?(modelName: String, bundle: NSBundle) {
        self.init(contentsOfURL: bundle.resourceURL(name: modelName, ext: "momd") ?? NSURL.null)
    }
    
    func fetchRequest(#templateName: String, mutable: Bool=false) -> NSFetchRequest {
        var fetchRequest: NSFetchRequest?
        if mutable == false {
            fetchRequest = self.fetchRequestTemplateForName(templateName)
        }
        else {
            fetchRequest = self.fetchRequestFromTemplateWithName(templateName, substitutionVariables: [:])
        }

        return fetchRequest ?? NSFetchRequest()
    }
}
