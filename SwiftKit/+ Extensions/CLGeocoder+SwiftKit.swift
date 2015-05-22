import CoreLocation

public extension CLGeocoder {
    public static func reverseGeocode(#location: CLLocation) -> ([CLPlacemark]?, NSError?) {
        let geocodeOperation = GeocodeOperation()
        geocodeOperation.set(coordinates: location)
        geocodeOperation.start()
        geocodeOperation.waitUntilFinished()
        return geocodeOperation.geocodeResults()
    }

    public func geocodeAddress(#string: String, queue: Queue?=nil, completionHandler: ([CLPlacemark]?, NSError?)->(Void)) {
        self.geocodeAddressString(string, completionHandler: {
            self.handleGeocoderResponse(($0, $1), queue: queue, completionHandler: completionHandler)
        })
    }
    
    public func reverseGeocode(#location: CLLocation, queue: Queue?=nil, completionHandler: ([CLPlacemark]?, NSError?)->(Void)) {
        self.reverseGeocodeLocation(location, completionHandler: {
            self.handleGeocoderResponse(($0, $1), queue: queue, completionHandler: completionHandler)
        })
    }
    
    private func handleGeocoderResponse(
        response: (placemarks: [AnyObject], error: NSError?),
        queue: Queue?=nil,
        completionHandler: ([CLPlacemark]?, NSError?)->(Void)
    ) {
        (queue ?? Queue.Utility).async {
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
}
