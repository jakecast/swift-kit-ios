import CoreLocation

public func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
    return (lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude)
}
