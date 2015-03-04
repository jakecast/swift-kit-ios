import Foundation

public extension NSLocale {
    class var currentInstance: NSLocale {
        return self.currentLocale()
    }
    
    class var usesMetric: Bool {
        let usesMetric = self
            .currentLocale()
            .objectForKey(NSLocaleUsesMetricSystem) as? Bool
        return usesMetric ?? true
    }
}
