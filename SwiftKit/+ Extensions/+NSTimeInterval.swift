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
    
    func asDate() -> NSDate {
        return NSDate(timeIntervalSinceReferenceDate: self)
    }
}
