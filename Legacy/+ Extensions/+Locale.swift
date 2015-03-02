import UIKit

public extension Locale {
    class var currentInstance: Locale {
        return self.currentLocale()
    }
}