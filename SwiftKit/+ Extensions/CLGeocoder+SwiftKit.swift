import CoreLocation

public extension CLGeocoder {
    public static func reverseGeocode(#location: CLLocation) -> ([CLPlacemark]?, NSError?) {
        return GeocodeOperation()
            .set(coordinates: location)
            .runOperation()
            .completeOperation()
            .geocodeResults()
    }

    public func geocodeAddress(#string: String, completionHandler: ([CLPlacemark]?, NSError?)->(Void)) {
        self.geocodeAddressString(string, completionHandler: {
            self.handleGeocoderResponse(($0, $1), completionHandler: completionHandler)
        })
    }
    
    public func reverseGeocode(#location: CLLocation, completionHandler: ([CLPlacemark]?, NSError?)->(Void)) {
        self.reverseGeocodeLocation(location, completionHandler: {
            self.handleGeocoderResponse(($0, $1), completionHandler: completionHandler)
        })
    }
    
    private func handleGeocoderResponse(
        response: (placemarks: [AnyObject], error: NSError?),
        completionHandler: ([CLPlacemark]?, NSError?)->(Void)
    ) {
        if let geocodeError = response.error {
            completionHandler(nil, geocodeError)
        }
        else {
            let placemarkResults = response.placemarks
                .map({ return $0 as? CLPlacemark })
                .filter({ return $0 != nil })
                .map({ return $0! })
            completionHandler(placemarkResults, nil)
        }
    }
}
