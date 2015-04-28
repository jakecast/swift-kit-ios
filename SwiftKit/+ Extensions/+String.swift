import Foundation

public extension String {
    static let null: String = ""
    static let ellipsis: String = String.ellipsis
    
    static func join(joinString: String, _ strings: [String]) -> String {
        return joinString.join(strings)
    }

    var isCapitalized: Bool {
        return NSCharacterSet
            .uppercaseLetterCharacterSet()
            .characterIsMember(self.unicharAtIndex(0))
    }

    var length: Int {
        return count(self)
    }

    var range: NSRange {
        return NSRange(location: 0, length: self.length)
    }
    
    init(timeinterval: NSTimeInterval, dateStyle: NSDateFormatterStyle?, timeStyle: NSDateFormatterStyle?) {
        self = NSDateFormatter()
            .set(dateStyle: dateStyle ?? NSDateFormatterStyle.NoStyle)
            .set(timeStyle: timeStyle ?? NSDateFormatterStyle.NoStyle)
            .string(timeinterval: timeinterval)
    }
    
    init(timeinterval: NSTimeInterval, formatter: NSDateFormatter) {
        self = formatter.string(timeinterval: timeinterval)
    }

    func append(#pathComponent: String) -> String {
        return self.stringByAppendingPathComponent(pathComponent)
    }

    func asUTF16() -> String.UTF16View {
        return self.utf16
    }
    
    func capitalized(locale: NSLocale=NSLocale.currentInstance) -> String {
        return self.capitalizedStringWithLocale(locale)
    }

    func characterAtIndex(index: Int) -> Character {
        return Character(self[index])
    }
    
    func countSubstring(substring: String) -> Int {
        return (self.length - self.replace(substring: substring, replaceString: String.null).length) / substring.length
    }

    func matchesExist(#regexPattern: String, ignoreCase: Bool=false) -> Bool {
        return self.matchesExist(regex: NSRegularExpression(pattern: regexPattern, ignoreCase: ignoreCase))
    }

    func matchesExist(#regex: NSRegularExpression?) -> Bool {
        return regex?.matchesExist(string: self) ?? false
    }

    func matches(#regexPattern: String, ignoreCase: Bool=false) -> [NSTextCheckingResult]? {
        return self.matches(regex: NSRegularExpression(pattern: regexPattern, ignoreCase: ignoreCase))
    }

    func matches(#regex: NSRegularExpression?) -> [NSTextCheckingResult]? {
        return regex?.matches(string: self)
    }

    func replace(#substring: String, replaceString: String, limit: Int?=nil) -> String {
        let resultString: String
        let selfComponents = self.split(substring)
        if limit != nil && limit < self.countSubstring(substring) {
            resultString = String.join("", [
                String.join(replaceString, Array(selfComponents[0...limit!])),
                substring,
                String.join(substring, Array(selfComponents[limit! + 1...selfComponents.count - 1])),
            ])
        }
        else {
            resultString = String.join(replaceString, selfComponents)
        }
        return resultString
    }

    func replace(#range: NSRange, replaceString: String) -> String {
        return self.stringByReplacingCharactersInRange(range.asRange(string: self), withString: replaceString)
    }

    func split(splitString: String) -> [String] {
        return self.componentsSeparatedByString(splitString)
    }

    func substring(#startIndex: String.Index, endIndex: String.Index) -> String {
        return self.substringWithRange(Range(start: startIndex, end: endIndex))
    }

    func substring(#start: Int?, end: Int?) -> String {
        let startPosition: Int = (start < 0) ? (self.length + (start ?? 0)) : (start ?? 0)
        let endPosition: Int = (end < 0) ? (self.length + (end ?? 0)) : (end ?? self.length)
        return self.substring(
            startIndex: advance(self.startIndex, startPosition),
            endIndex: advance(self.startIndex, startPosition + (endPosition - startPosition))
        )
    }

    func substringAtIndex(index: Int) -> String {
        let substring: String
        if index >= 0 {
            substring = self.substring(start: index, end: index + 1)
        }
        else {
            substring = self.substringAtIndex(self.length - (-1 * index))
        }
        return substring
    }

    func toNumber() -> Float? {
        return (self.toInt() != nil) ? (self as NSString).floatValue : nil
    }

    func unicharAtIndex(index: Int) -> unichar {
        return self
            .substringAtIndex(index)
            .asUTF16()
            .unicharAtIndex(0)
    }

    func urlPathEncode() -> String {
        return self.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet()) ?? String.null
    }

    func write(#fileURL: NSURL, atomically: Bool=true, encoding: NSStringEncoding=NSUTF8StringEncoding) {
        NSError.performOperation {(error) -> (Void) in
            self.writeToURL(fileURL, atomically: atomically, encoding: encoding, error: error)
        }
    }

    subscript(location: Int) -> String {
        return self.substringAtIndex(location)
    }

    subscript(location: (Int?, Int?)) -> String {
        return self.substring(start: location.0, end: location.1)
    }
}
