import Foundation
import CoreLocation

public class GeocodeOperation: BaseOperation {
    private var coordinates: CLLocation? = nil
    private var geocodePlacemarks: [CLPlacemark]? = nil
    private var geocodeError: NSError? = nil
    private lazy var geocoder: CLGeocoder = CLGeocoder()

    public override func main() {
        if let location = self.coordinates {
            let geocodeSemaphore: dispatch_semaphore_t = dispatch_semaphore_create(0);
            self.geocoder.reverseGeocode(location: location, completionHandler: {(placemarks, error) -> (Void) in
                self.geocodePlacemarks = placemarks
                self.geocodeError = error

                dispatch_semaphore_signal(geocodeSemaphore)
            })
            dispatch_semaphore_wait(geocodeSemaphore, DISPATCH_TIME_FOREVER)
            self.finishOperation()
        }
        else {
            self.finishOperation()
        }
    }

    public func geocodeResults() -> ([CLPlacemark]?, NSError?) {
        return (self.geocodePlacemarks, self.geocodeError)
    }

    public func set(#coordinates: CLLocation) -> Self {
        self.coordinates = coordinates
        return self
    }
}
