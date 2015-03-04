import CoreLocation

public extension CLLocation {

    
    convenience init(coordinates: CLLocationCoordinate2D) {
        self.init(latitude: coordinates.latitude, longitude: coordinates.longitude)
    }
    
    func reverseGeocode(#completionBlock: (CLPlacemark?) -> (Void)) {
        CLGeocoder.reverseGeocode(location: self, completionHandler: completionBlock)
    }
}