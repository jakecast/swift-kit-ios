import UIKit

public extension UILabel {
    func update(#text: String) {
        if text != self.text {
            self.text = text
        }
    }
}