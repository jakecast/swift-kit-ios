import CoreLocation

public extension CLLocation {
    func reverseGeocode(#completionBlock: (CLPlacemark?) -> (Void)) {
        CLGeocoder.reverseGeocode(location: self, completionHandler: completionBlock)
    }
}