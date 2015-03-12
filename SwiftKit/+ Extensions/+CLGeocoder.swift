import CoreLocation
import UIKit

public extension CLGeocoder {
    class func batchGeocode(
        #locations: [CLLocationCoordinate2D],
        completionHandler: ([CLLocationCoordinate2D:CLPlacemark])->(Void)
    ) {
        var placemarks: [CLLocationCoordinate2D:CLPlacemark] = [:]
        for coordinates in locations {
            let locationCoordinates = (coordinates.latitude, coordinates.longitude)
            self.reverseGeocode(location: locationCoordinates, completionHandler: {(pm: CLPlacemark?) -> (Void) in
                if let placemark = pm {
                    placemarks[coordinates] = placemark
                }
                else {
                    placemarks[coordinates] = CLPlacemark()
                }

                if placemarks.count == locations.count {
                    completionHandler(placemarks)
                }
            })
        }
    }
    
    class func reverseGeocode(#location: (CLLocationDegrees, CLLocationDegrees), completionHandler: (CLPlacemark?) -> (Void)) {
        CLGeocoder().reverseGeocode(location: location, completionHandler: completionHandler)
    }

    class func reverseGeocode(#location: CLLocation, completionHandler: (CLPlacemark?) -> (Void)) {
        CLGeocoder().reverseGeocode(
            location: location,
            completionHandler: completionHandler
        )
    }

    func reverseGeocode(#location: (CLLocationDegrees, CLLocationDegrees), completionHandler: (CLPlacemark?) -> (Void)) {
        self.reverseGeocode(
            location: CLLocation(latitude: location.0, longitude: location.1),
            completionHandler: completionHandler
        )
    }

    func reverseGeocode(#location: CLLocation, completionHandler: (CLPlacemark?) -> (Void)) {
        self.reverseGeocodeLocation(location, completionHandler: {(locationDetails, error) -> Void in
            if error == nil {
                completionHandler(locationDetails.firstItem() as? CLPlacemark ?? nil)
            }
            else {
                completionHandler(nil)
            }
        })
    }
}
