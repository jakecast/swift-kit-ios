import UIKit

public extension NSURLSessionConfiguration {
    public static var appAcceptEncodingHeader: String {
        return "gzip;q=1.0,compress;q=0.5"
    }

    public static var appAcceptLanguageHeader: String {
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

    public static var appUserAgentHeader: String {
        let infoDictionary = NSBundle.mainBundle().infoDictionary ?? [:]
        let executable: AnyObject = infoDictionary[kCFBundleExecutableKey] ?? "Unknown"
        let bundle: AnyObject = infoDictionary[kCFBundleIdentifierKey] ?? "Unknown"
        let version: AnyObject = infoDictionary[kCFBundleVersionKey] ?? "Unknown"
        let os: AnyObject = NSProcessInfo.processInfo().operatingSystemVersionString ?? "Unknown"
        
        return "\(executable)/\(bundle) (\(version); OS \(os))"
    }

    public static func defaultSessionConfiguration(#additionalHeaders: [NSObject:AnyObject]) -> NSURLSessionConfiguration {
        return NSURLSessionConfiguration
            .defaultSessionConfiguration()
            .set(HTTPAdditionalHeaders: additionalHeaders)
            .set(HTTPShouldUsePipelining: true)
    }

    public static func ephemeralSessionConfiguration(#additionalHeaders: [NSObject:AnyObject]) -> NSURLSessionConfiguration {
        return NSURLSessionConfiguration
            .ephemeralSessionConfiguration()
            .set(HTTPAdditionalHeaders: additionalHeaders)
            .set(HTTPShouldUsePipelining: true)
    }

    public static func backgroundSessionConfiguration(#additionalHeaders: [NSObject:AnyObject], identifier: String) -> NSURLSessionConfiguration {
        return NSURLSessionConfiguration
            .backgroundSessionConfigurationWithIdentifier(identifier)
            .set(HTTPAdditionalHeaders: additionalHeaders)
            .set(HTTPShouldUsePipelining: true)
    }

    public func set(#HTTPAdditionalHeaders: [NSObject:AnyObject]) -> Self {
        self.HTTPAdditionalHeaders = HTTPAdditionalHeaders
        return self
    }

    public func set(#HTTPShouldUsePipelining: Bool) -> Self {
        self.HTTPShouldUsePipelining = HTTPShouldUsePipelining
        return self
    }
}
