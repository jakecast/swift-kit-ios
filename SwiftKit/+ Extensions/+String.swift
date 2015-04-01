import Foundation
import UIKit

public extension String {
    static let null: String = ""

    static func debugOperation(operationBlock: (NSErrorPointer) -> (Void)) {
        var errorPointer: NSError?
        operationBlock(&errorPointer)
        
        if errorPointer != nil && UIDevice.isSimulator == true {
            if let localizedDescription = errorPointer?.localizedDescription {
                println("an error occured: \(localizedDescription)")
            }
            else if let domain = errorPointer?.domain, let code = errorPointer?.code {
                println("an error occured: \(domain) with code: \(code)")
            }
            else {
                println("an error occured")
            }
        }
    }
    
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

    func append(#pathComponent: String) -> String {
        return self.stringByAppendingPathComponent(pathComponent)
    }

    func asUTF16() -> String.UTF16View {
        return self.utf16
    }

    func characterAtIndex(index: Int) -> Character {
        return Character(self[index])
    }
    
    func countOfSubstring(substring: String) -> Int {
        return (self.length - self.replace(substring: substring, replaceString: String.null).length) / substring.length
    }

    func replace(#substring: String, replaceString: String, limit: Int?=nil) -> String {
        let selfComponents = self.componentsSeparatedByString(substring)
        let resultString: String
        if limit != nil && limit < self.countOfSubstring(substring) {
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
        String.debugOperation {(error) -> (Void) in
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
