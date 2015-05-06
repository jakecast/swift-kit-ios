import Foundation

public extension NSTimeInterval {
    static var nowTimeInterval: NSTimeInterval {
        return NSTimeInterval(date: NSDate.dateNow)
    }
    
    static var referenceDateTimeInterval: NSTimeInterval {
        return NSDate(timeIntervalSinceReferenceDate: 0).asTimeInterval()
    }

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
        self = (minutes.doubleValue * 60)
    }
    
    func asDate() -> NSDate {
        return NSDate(timeIntervalSinceReferenceDate: self)
    }
    
    func timeSince() -> NSTimeInterval {
        return (NSTimeInterval.nowTimeInterval - self)
    }
}
