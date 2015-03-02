import CoreData
import UIKit

public extension NSManagedObjectModel {
    convenience init?(modelName: String, bundle: NSBundle) {
        self.init(contentsOfURL: bundle.resourceURL(name: modelName, ext: "momd")!)
    }
}
