import Foundation
import CoreLocation

public extension CLAuthorizationStatus {
    var isAuthorized: Bool {
        return (self == .AuthorizedAlways || self == .AuthorizedWhenInUse)
    }
    
    var isUnauthorized: Bool {
        return (self == .Denied || self == .Restricted)
    }
}
