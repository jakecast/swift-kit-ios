import CoreLocation

public extension CLLocationCoordinate2D {
    static var nullLocation: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
    }
    
    func isNull() -> Bool {
        return self == CLLocationCoordinate2D.nullLocation
    }
}
