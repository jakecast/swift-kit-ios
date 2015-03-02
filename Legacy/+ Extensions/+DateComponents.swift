import UIKit

public extension DateComponents {
    convenience init(seconds: Int, minutes: Int, hours: Int, days: Int, months: Int, years: Int) {
        self.init()
        self.second = seconds
        self.minute = minutes
        self.hour = hours
        self.day = days
        self.month = months
        self.year = years
    }
}