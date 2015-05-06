import CoreLocation

public extension CLLocationDistance {
    static var oneKilometersDistance: CLLocationDirection {
        return CLLocationDistance(kilometersDistance: 1)
    }
    
    static var twoKilometersDistance: CLLocationDistance {
        return CLLocationDistance(kilometersDistance: 2)
    }

    static var threeKilometersDistance: CLLocationDistance {
        return CLLocationDistance(kilometersDistance: 3)
    }

    init(metersDistance: Double) {
        self = metersDistance
    }
    
    init(kilometersDistance: Double) {
        self = kilometersDistance * 1000
    }
}
