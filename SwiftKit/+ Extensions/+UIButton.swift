import UIKit

public extension UIButton {
    var titleText: String? {
        get {
            return self.titleForState(UIControlState.Normal)
        }
        set(newValue) {
            self.setTitle(newValue, forState: UIControlState.Normal)
        }
    }
    
    func update(#titleText: String) {
        if titleText != self.titleText {
            self.titleText = titleText
        }
    }
}