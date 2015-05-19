import Foundation

public protocol StringRepresentable {
    var stringValue: String { get }
    
    func asString() -> String
}
