import Foundation

public extension NSExpression {
    convenience init(function: String, keyPath: String, value: AnyObject) {
        self.init(forFunction: function, arguments: [NSExpression(forKeyPath: keyPath), NSExpression(forConstantValue: value), ])
    }
}
