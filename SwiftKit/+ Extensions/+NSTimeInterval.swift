import Foundation

public extension NSTimeInterval {
    var date: NSDate {
        return self.asDate()
    }
    
    var isToday: Bool {
        return self.date.isToday
    }
    
    init(date: NSDate) {
        self = date.timeIntervalSinceReferenceDate
    }
    
    init(minutes: Int) {
        self = (minutes.double * 60)
    }
    
    func asDate() -> NSDate {
        return NSDate(timeIntervalSinceReferenceDate: self)
    }
    
    func timeSince() -> NSTimeInterval {
        return (NSTimeInterval(date: NSDate.now) - self)
    }
}
