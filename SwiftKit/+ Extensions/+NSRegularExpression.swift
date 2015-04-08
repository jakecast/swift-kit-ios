import Foundation

public extension NSRegularExpression {
    static var zipCodePattern: String {
        return "^(\\d{5}(-\\d{4})?|[a-z]\\d[a-z][- ]*\\d[a-z]\\d)$"
    }

    convenience init?(pattern: String, options: NSRegularExpressionOptions=NSRegularExpressionOptions.allZeros) {
        var error: NSError?
        self.init(pattern: pattern, options: options, error: &error)
        NSError.debugError(error: error)
    }

    convenience init?(pattern: String, ignoreCase: Bool=false) {
        self.init(
            pattern: pattern,
            options: (ignoreCase == true) ? NSRegularExpressionOptions.CaseInsensitive : NSRegularExpressionOptions.allZeros
        )
    }

    func matchesExist(#string: String, options: NSMatchingOptions=NSMatchingOptions(rawValue: 0), range: NSRange?=nil) -> Bool {
        return self.matchesCount(string: string, options: options, range: range) != 0
    }

    func matches(#string: String, options: NSMatchingOptions=NSMatchingOptions(rawValue: 0), range: NSRange?=nil) -> [NSTextCheckingResult] {
        return self
            .matchesInString(string, options: options, range: range ?? string.range)
            .map({ return $0 as? NSTextCheckingResult })
            .filter({ return $0 != nil })
            .map({ return $0! })
    }

    func matchesCount(#string: String, options: NSMatchingOptions=NSMatchingOptions(rawValue: 0), range: NSRange?=nil) -> Int {
        return self.numberOfMatchesInString(string, options: options, range: range ?? string.range)
    }
}
