import UIKit


public enum JavascriptObject {
    case NumberObject(Number)
    case StringObject(String)
    case ArrayObject([AnyObject])
    case DictionaryObject([String:AnyObject])
    case Nil(Error?)

    public init(_ jsonObject: AnyObject) {
        switch jsonObject {
        case let number as Number:
            self = JavascriptObject.NumberObject(number)
        case let string as String:
            if let number = string.toNumber() {
                self = JavascriptObject.NumberObject(number)
            }
            else {
                self = JavascriptObject.StringObject(string)
            }
        case let array as [AnyObject]:
            self = JavascriptObject.ArrayObject(array)
        case let dictionary as [String:AnyObject]:
            self = JavascriptObject.DictionaryObject(dictionary)
        default:
            self = JavascriptObject.Nil(nil)
        }
    }

    public init?(jsonObject: AnyObject?) {
        if let json: AnyObject = jsonObject {
            self = JavascriptObject(json)
        }
        else {
            return nil
        }
    }
}


extension JavascriptObject: SequenceType {
    public var isEmpty: Bool {
        switch self {
        case .ArrayObject(let array):
            return array.isEmpty
        case .DictionaryObject(let dictionary):
            return dictionary.isEmpty
        default:
            return false
        }
    }

    public var first: JavascriptObject? {
        switch self {
        case .ArrayObject(let array):
            return JavascriptObject(jsonObject: array.first)
        default:
            return nil
        }
    }

    public var last: JavascriptObject? {
        switch self {
        case .ArrayObject(let array):
            return JavascriptObject(jsonObject: array.last)
        default:
            return nil
        }
    }

    public func generate() -> GeneratorOf<JavascriptObject> {
        switch self {
        case .ArrayObject(let array):
            var arrayGenerator = array.generate()
            return GeneratorOf<JavascriptObject> {
                if let element: AnyObject = arrayGenerator.next() {
                    return JavascriptObject(element)
                }
                else {
                    return nil
                }
            }
        case .DictionaryObject(let dictionary):
            var dictionaryGenerator = dictionary.generate()
            return GeneratorOf<JavascriptObject> {
                if let (key: String, value: AnyObject) = dictionaryGenerator.next() {
                    return JavascriptObject([key: value])
                }
                else {
                    return nil
                }
            }
        default:
            return GeneratorOf<JavascriptObject> {
                return nil
            }
        }
    }
}


public extension JavascriptObject {
    subscript(idx: Int) -> JavascriptObject? {
        get {
            switch self {
            case .ArrayObject(let array) where array.count > idx:
                return JavascriptObject(array[idx])
            default:
                return nil
            }
        }
    }

    subscript(key: String) -> JavascriptObject? {
        get {
            switch self {
            case .DictionaryObject(let dictionary) where dictionary[key] != nil:
                return JavascriptObject(dictionary[key]!)
            default:
                return nil
            }
        }
    }
}


public extension JavascriptObject {
    var objectValue: AnyObject? {
        switch self {
        case .NumberObject(let number):
            return number
        case .StringObject(let string):
            return string
        case .ArrayObject(let array):
            return array
        case .DictionaryObject(let dictionary):
            return dictionary
        default:
            return nil
        }
    }

    var stringValue: String? {
        switch self {
        case .NumberObject(let number):
            return number.stringValue
        case .StringObject(let string):
            return string
        default:
            return nil
        }
    }

    var integerValue: Int? {
        switch self {
        case .NumberObject(let number):
            return number.integerValue
        default:
            return nil
        }
    }
}