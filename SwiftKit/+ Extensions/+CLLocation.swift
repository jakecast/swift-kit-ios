import CoreLocation

public extension CLLocation {
    var latitude: CLLocationDegrees {
        return self.coordinate.latitude
    }

    var longitude: CLLocationDegrees {
        return self.coordinate.longitude
    }

    convenience init(coordinates: CLLocationCoordinate2D) {
        self.init(latitude: coordinates.latitude, longitude: coordinates.longitude)
    }
    
    func reverseGeocode() -> CLPlacemark? {
        var locationPlacemark: CLPlacemark?
        let semaphore = Semaphore(initialValue: 0)
        self.reverseGeocode(completionHandler: {(placemark: CLPlacemark?) -> (Void) in
            locationPlacemark = placemark
            semaphore.signal()
        })
        semaphore.wait()
        return locationPlacemark
    }
    
    func reverseGeocode(#completionHandler: (CLPlacemark?) -> (Void)) {
        CLGeocoder.reverseGeocode(location: self, completionHandler: completionHandler)
    }
}