import CoreData

public extension NSManagedObjectModel {
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
