import Foundation
import CoreLocation

public extension CLAuthorizationStatus {
    public var isAuthorized: Bool {
        return (self == .AuthorizedAlways || self == .AuthorizedWhenInUse)
    }
    
    public var isUnauthorized: Bool {
        return (self == .Denied || self == .Restricted)
    }
    
    public var intValue: Int {
        return self.rawValue.intValue
    }
    
    public init(int: Int?) {
        if let intValue = int {
            self = CLAuthorizationStatus(rawValue: intValue.int32) ?? CLAuthorizationStatus.NotDetermined
        }
        else {
            self = CLAuthorizationStatus.NotDetermined
        }
    }
}
