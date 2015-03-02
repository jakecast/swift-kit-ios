import UIKit

public extension Date {
    var year: Int {
        return self.components.year
    }

    var month: Int {
        return self.components.month
    }

    var weekday: Int {
        return self.components.weekday
    }

    var weekdayString: String {
        return DateFormatter
            .defaultFormatter(dateFormat: "EEEE")
            .stringFromDate(self)
    }

    var day: Int {
        return self.components.day
    }

    var hour: Int {
        return self.components.hour
    }

    var minute: Int {
        return self.components.minute
    }

    var second: Int {
        return self.components.second
    }

    var components: DateComponents {
        return Calendar
            .currentCalendar()
            .components(CalendarUnit.mainDateUnits,fromDate: self)
    }

    convenience init(
        date: Date,
        seconds: Int=0,
        minutes: Int=0,
        hours: Int=0,
        days: Int=0,
        months: Int=0,
        years: Int=0
    ) {
        let dateComponents = DateComponents(
            seconds: seconds,
            minutes: minutes,
            hours: hours,
            days: days, 
            months: months,
            years: years
        )

        if let newDate = NSCalendar.dateFromComponents(date: date, components: dateComponents) {
            self.init(timeIntervalSinceReferenceDate: newDate.timeIntervalSinceReferenceDate)
        }
        else {
            self.init()
        }
    }

    func shortTimeString() -> String {
        return DateFormatter
            .shortTimeFormatter()
            .stringFromDate(self)
    }

    func add(#components: DateComponents) -> Date? {
        return NSCalendar
            .currentCalendar()
            .dateByAddingComponents(components, toDate: self, options: nil)
    }
}
