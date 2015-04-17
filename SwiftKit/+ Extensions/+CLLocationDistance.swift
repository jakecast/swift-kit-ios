import CoreLocation

public extension CLLocationDistance {
    static var twoKilometers: CLLocationDistance {
        return CLLocationDistance(kilometers: 2)
    }
    
    init(meters: Double) {
        self = meters
    }
    
    init(kilometers: Double) {
        self = kilometers * 1000
    }
}
