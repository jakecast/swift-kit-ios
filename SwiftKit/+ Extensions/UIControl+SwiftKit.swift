import UIKit

public extension UIControl {
    func update(#enabled: Bool) {
        if enabled != self.enabled {
            self.enabled = enabled
        }
    }
}