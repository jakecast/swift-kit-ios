import CoreGraphics

public extension CGFloat {
    static let null: CGFloat = 0
    static let PI: CGFloat = CGFloat(M_PI)
    static let PI_4: CGFloat = CGFloat(M_PI_4)

    func roundIntegral() -> CGFloat {
        return rint(self)
    }
}
