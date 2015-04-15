import CoreLocation

public extension CLLocation {
    var latitude: CLLocationDegrees {
        return self.coordinate.latitude
    }

    var longitude: CLLocationDegrees {
        return self.coordinate.longitude
    }
    
    convenience init(coordinates: (CLLocationDegrees, CLLocationDegrees)) {
        self.init(latitude: coordinates.0, longitude: coordinates.1)
    }

    convenience init(coordinates: CLLocationCoordinate2D) {
        self.init(latitude: coordinates.latitude, longitude: coordinates.longitude)
    }
    
    func round(precision: Int=0) -> CLLocation {
        return CLLocation(latitude: self.latitude.round(precision: precision), longitude: self.longitude.round(precision: precision))
    }
}