import CoreLocation

public extension CLLocationDistance {
    init(meters: Double) {
        self = meters
    }
    
    init(kilometers: Double) {
        self = kilometers * 1000
    }
}
