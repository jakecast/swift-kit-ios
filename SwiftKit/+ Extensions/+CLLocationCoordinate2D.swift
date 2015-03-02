import CoreLocation
import UIKit

extension CLLocationCoordinate2D: Hashable, Equatable {
    public var hashValue: Int {
        return String("\(self.latitude),\(self.longitude)").hashValue
    }
}

public func ==(lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
    return lhs.hashValue == rhs.hashValue
}