import CoreLocation

public extension CLGeocoder {
    static func reverseGeocode(#location: CLLocation) -> ([CLPlacemark]?, NSError?) {
        let geocodeOperation = GeocodeOperation()
        geocodeOperation.set(coordinates: location)
        geocodeOperation.start()
        geocodeOperation.waitUntilFinished()
        return geocodeOperation.geocodeResults()
//            .startOperation()
//            .waitOperation()
//            .geocodeResults()
    }

    func geocodeAddress(#string: String, completionHandler: ([CLPlacemark]?, NSError?)->(Void)) {
        self.geocodeAddressString(string, completionHandler: {(results, error) -> Void in
            if error == nil {
                let placemarkResults = results
                    .map({ return $0 as? CLPlacemark })
                    .filter({ return $0 != nil })
                    .map({ return $0! })
                completionHandler(placemarkResults, error)
            }
            else {
                completionHandler(nil, error)
            }
        })
    }
    
    func reverseGeocode(#location: CLLocation, completionHandler: ([CLPlacemark]?, NSError?)->(Void)) {
        self.reverseGeocodeLocation(location, completionHandler: {(results, error) -> Void in
            if let geocodeError = error {
                completionHandler(nil, geocodeError)
            }
            else {
                let placemarkResults = results
                    .map({ return $0 as? CLPlacemark })
                    .filter({ return $0 != nil })
                    .map({ return $0! })
                completionHandler(placemarkResults, nil)
            }
        })
    }
}
