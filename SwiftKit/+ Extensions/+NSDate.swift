import Foundation

public extension NSDate {
    class var now: NSDate {
        return self.dateNow()
    }
    
    class func dateNow() -> NSDate {
        return self()
    }
    
    var dateComponents: NSDateComponents {
        return NSCalendar
            .sharedCalendar()
            .components(NSCalendarUnit.DateUnits, fromDate: self)
    }
    
    var isToday: Bool {
        return self.dateComponents == NSDate.now.dateComponents
    }
    
    var timeInterval: NSTimeInterval {
        return self.asTimeInterval()
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
