import Foundation
import CoreLocation

public class GeocodeOperation: BaseOperation {
    private var coordinates: CLLocation? = nil
    private var geocodePlacemarks: [CLPlacemark]? = nil
    private var geocodeError: NSError? = nil
    private lazy var geocoder: CLGeocoder = CLGeocoder()

    public override func main() {
        self.startGeocode()

        if self.coordinates == nil {
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

    private func startGeocode() {
        if let location = self.coordinates {
            self.geocoder.reverseGeocode(location: location, completionHandler: {[weak self] (placemarks, error) -> (Void) in
                self?.geocodePlacemarks = placemarks
                self?.geocodeError = error

                self?.finishOperation()
            })
        }
    }
}
