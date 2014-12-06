import UIKit


public extension ManagedObjectModel {
    convenience init?(modelName: String, bundle: Bundle) {
        self.init(contentsOfURL: bundle.resourceURL(name: modelName, ext: "momd")!)
    }
}
