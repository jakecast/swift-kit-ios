import Foundation

public extension NSCalendarUnit {
    static var DateUnits: NSCalendarUnit {
        return self.CalendarUnitDay | self.CalendarUnitMonth | self.CalendarUnitYear
    }
}
