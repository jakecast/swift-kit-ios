import UIKit

public extension UIBarButtonItem {
    var itemView: UIView? {
        return self.valueForKey("view") as? UIView
    }

    var itemFrame: CGRect {
        return self.itemView?.frame ?? CGRect.null
    }
}
