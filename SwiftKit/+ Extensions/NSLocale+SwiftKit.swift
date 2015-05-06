import Foundation

public extension NSLocale {
    static var currentInstance: NSLocale {
        return self.currentLocale()
    }
    
    static var usesMetric: Bool {
        let usesMetric = self
            .currentLocale()
            .objectForKey(NSLocaleUsesMetricSystem) as? Bool
        return usesMetric ?? true
    }
}
