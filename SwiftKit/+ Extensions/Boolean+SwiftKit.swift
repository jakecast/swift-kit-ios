import Foundation

public extension Boolean {
    init(bool: Bool) {
        self = bool == true ? 1 : 0
    }
}