import CoreLocation

public extension CLGeocoder {
    static func reverseGeocode(#location: CLLocation) -> ([CLPlacemark]?, NSError?) {
        return GeocodeOperation()
            .set(coordinates: location)
            .startOperation()
            .waitOperation()
            .geocodeResults()
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
}
