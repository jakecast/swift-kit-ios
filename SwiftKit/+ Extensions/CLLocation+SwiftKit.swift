import CoreLocation

public extension CLLocation {
    public static var null: CLLocation {
        return CLLocation(latitude: 0, longitude: 0)
    }
    
    public static func latestLocation(#locations: [AnyObject]) -> CLLocation? {
        return locations
            .map({ return $0 as? CLLocation })
            .filter({ return $0 != nil })
            .map({ return $0! })
            .sorted({ return $0.timestamp.timeInterval < $1.timestamp.timeInterval })
            .lastItem()
    }
}

public extension CLLocation {
    public var latitude: CLLocationDegrees {
        return self.coordinate.latitude
    }

    public var longitude: CLLocationDegrees {
        return self.coordinate.longitude
    }
    
    public convenience init(coordinates: (CLLocationDegrees, CLLocationDegrees), round: Int?=nil) {
        if let precision = round {
            self.init(
                latitude: coordinates.0.round(precision: precision),
                longitude: coordinates.1.round(precision: precision)
            )
        }
        else {
            self.init(
                latitude: coordinates.0,
                longitude: coordinates.1
            )
        }
    }

    public convenience init(coordinates: CLLocationCoordinate2D) {
        self.init(latitude: coordinates.latitude, longitude: coordinates.longitude)
    }

    public convenience init(latitude: CLLocationDegrees, longitude: CLLocationDegrees, round: Int) {
        self.init(coordinates: (latitude, longitude), round: round)
    }

    public func round(precision: Int=0) -> CLLocation {
        return CLLocation(latitude: self.latitude.round(precision: precision), longitude: self.longitude.round(precision: precision))
    }
}