import UIKit

public extension NSURLSessionConfiguration {
    static var appAcceptEncodingHeader: String {
        return "gzip;q=1.0,compress;q=0.5"
    }

    static var appAcceptLanguageHeader: String {
        var languageComponents: [String] = []
        for (index, languageCode) in enumerate(NSLocale.preferredLanguages() as! [String]) {
            let q = 1.0 - (Double(index) * 0.1)
            languageComponents += ["\(languageCode);q=\(q)", ]

            if q <= 0.5 {
                break
            }
        }
        return join(",", languageComponents)
    }

    static var appUserAgentHeader: String {
        let infoDictionary = NSBundle.mainBundle().infoDictionary ?? [:]
        let executable: AnyObject = infoDictionary[kCFBundleExecutableKey] ?? "Unknown"
        let bundle: AnyObject = infoDictionary[kCFBundleIdentifierKey] ?? "Unknown"
        let version: AnyObject = infoDictionary[kCFBundleVersionKey] ?? "Unknown"
        let os: AnyObject = NSProcessInfo.processInfo().operatingSystemVersionString ?? "Unknown"
        
        return "\(executable)/\(bundle) (\(version); OS \(os))"
    }

    static func defaultSessionConfiguration(#additionalHeaders: [NSObject:AnyObject]) -> NSURLSessionConfiguration {
        let defaultSessionConfiguration = self.defaultSessionConfiguration()
        defaultSessionConfiguration.HTTPAdditionalHeaders = additionalHeaders

        return defaultSessionConfiguration
    }

    static func ephemeralSessionConfiguration(#additionalHeaders: [NSObject:AnyObject]) -> NSURLSessionConfiguration {
        let ephemeralSessionConfiguration = self.ephemeralSessionConfiguration()
        ephemeralSessionConfiguration.HTTPAdditionalHeaders = additionalHeaders

        return ephemeralSessionConfiguration
    }

    static func backgroundSessionConfiguration(#additionalHeaders: [NSObject:AnyObject], identifier: String) -> NSURLSessionConfiguration {
        let backgroundSessionConfiguration = self.backgroundSessionConfigurationWithIdentifier(identifier)
        backgroundSessionConfiguration.HTTPAdditionalHeaders = additionalHeaders
        
        return backgroundSessionConfiguration
    }
}
