import Foundation

public extension NSDate {
    static var dateNow: NSDate {
        return NSDate()
    }
    
    var dateComponents: NSDateComponents {
        return NSCalendar
            .sharedCalendar()
            .components(NSCalendarUnit.DateUnits, fromDate: self)
    }
    
    var isToday: Bool {
        return self.dateComponents == NSDate.dateNow.dateComponents
    }
    
    var timeInterval: NSTimeInterval {
        return self.asTimeInterval()
    }
    
    var timeIntervalSince: NSTimeInterval {
        return self
            .asTimeInterval()
            .timeSince()
    }
    
    var shortTimeString: String {
        return self.asShortTimeString()
    }
    
    var shortDateString: String {
        return self.asShortDateString()
    }
    
    var mediumDateTimeString: String {
        return self.asMediumDateTimeString()
    }
    
    func asTimeInterval() -> NSTimeInterval {
        return self.timeIntervalSinceReferenceDate
    }
    
    func asShortTimeString() -> String {
        return NSDateFormatter
            .shortTimeFormatter()
            .stringFromDate(self)
    }
    
    func asShortDateString() -> String {
        return NSDateFormatter
            .shortDateFormatter()
            .stringFromDate(self)
    }
    
    func asMediumDateTimeString() -> String {
        return NSDateFormatter
            .mediumDateTimeFormatter()
            .stringFromDate(self)
    }
}
