import CoreLocation

public extension CLLocationAccuracy {
    static var twoKilometersAccuracy: CLLocationAccuracy {
        return CLLocationAccuracy(kilometersAccuracy: 2)
    }

    static var threeKilometersAccuracy: CLLocationAccuracy {
        return CLLocationAccuracy(kilometersAccuracy: 3)
    }

    init(metersAccuracy: Double) {
        self = metersAccuracy
    }

    init(kilometersAccuracy: Double) {
        self = kilometersAccuracy * 1000
    }
}
