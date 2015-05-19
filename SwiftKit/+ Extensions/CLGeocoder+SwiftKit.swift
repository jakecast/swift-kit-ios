import CoreLocation

public extension CLGeocoder {
    func geocodeAddress(#string: String, queue: NSOperationQueue?=nil, completionHandler: ([CLPlacemark]?, NSError?)->(Void)) {
        self.geocodeAddressString(string, completionHandler: {(results, error) -> Void in
            (queue ?? NSOperationQueue.mainQueue()).dispatch {
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
            }
        })
    }

    func reverseGeocode(#location: CLLocation, queue: NSOperationQueue?=nil, completionHandler: ([CLPlacemark]?, NSError?)->(Void)) {
        self.reverseGeocodeLocation(location, completionHandler: {(results, error) -> Void in
            (queue ?? NSOperationQueue.mainQueue()).dispatch {
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
            }
        })
    }
}
