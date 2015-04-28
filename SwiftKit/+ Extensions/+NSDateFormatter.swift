import Foundation

public extension NSDateFormatter {
    static var shortTime: NSDateFormatter {
        return self.shortTimeFormatter()
    }
    
    static var shortDate: NSDateFormatter {
        return self.shortDateFormatter()
    }
    
    static var mediumDateTime: NSDateFormatter {
        return self.mediumDateTimeFormatter()
    }
    
    static var longDateTime: NSDateFormatter {
        return self.longDateTimeFormatter()
    }
    
    static func shortTimeFormatter() -> NSDateFormatter {
        return Extension.shortTimeFormatter
    }
    
    static func shortDateFormatter() -> NSDateFormatter {
        return Extension.shortDateFormatter
    }
    
    static func mediumDateTimeFormatter() -> NSDateFormatter {
        return Extension.mediumDateTimeFormatter
    }
    
    static func longDateTimeFormatter() -> NSDateFormatter {
        return Extension.longDateTimeFormatter
    }
    
    static func timeIntervalSinceReferenceDate(#dateString: String, format: String) -> NSTimeInterval {
        return NSDateFormatter()
            .set(dateFormat: format)
            .timeIntervalSinceReferenceDate(string: dateString)
    }
}

public extension NSDateFormatter {
    private struct Extension {
        static let shortTimeFormatter = NSDateFormatter(
            dateStyle: NSDateFormatterStyle.NoStyle,
            timeStyle: NSDateFormatterStyle.ShortStyle
        )
        
        static let shortDateFormatter = NSDateFormatter(
            dateStyle: NSDateFormatterStyle.ShortStyle,
            timeStyle: NSDateFormatterStyle.NoStyle
        )
        
        static let mediumDateTimeFormatter = NSDateFormatter(
            dateStyle: NSDateFormatterStyle.MediumStyle,
            timeStyle: NSDateFormatterStyle.MediumStyle
        )
        
        static let longDateTimeFormatter = NSDateFormatter(
            dateStyle: NSDateFormatterStyle.LongStyle,
            timeStyle: NSDateFormatterStyle.LongStyle
        )
    }
    
    convenience init(dateStyle: NSDateFormatterStyle, timeStyle: NSDateFormatterStyle) {
        self.init()
        self.dateStyle = dateStyle
        self.timeStyle = timeStyle
    }
    
    func set(#dateFormat: String) -> Self {
        self.dateFormat = dateFormat
        return self
    }
    
    func set(#dateStyle: NSDateFormatterStyle) -> Self {
        self.dateStyle = dateStyle
        return self
    }
    
    func set(#timeStyle: NSDateFormatterStyle) -> Self {
        self.timeStyle = timeStyle
        return self
    }
    
    func date(#string: String) -> NSDate? {
        return self.dateFromString(string)
    }
    
    func string(#timeinterval: NSTimeInterval) -> String {
        return self.stringFromDate(timeinterval.date)
    }
    
    func timeIntervalSinceReferenceDate(#string: String) -> NSTimeInterval {
        return self.date(string: string)?.timeIntervalSinceReferenceDate ?? 0
    }
}
