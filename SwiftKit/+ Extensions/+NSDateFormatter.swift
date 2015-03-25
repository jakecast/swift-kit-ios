import Foundation

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
    
    class var shortTime: NSDateFormatter {
        return self.shortTimeFormatter()
    }
    
    class var shortDate: NSDateFormatter {
        return self.shortDateFormatter()
    }
    
    class var mediumDateTime: NSDateFormatter {
        return self.mediumDateTimeFormatter()
    }
    
    class var longDateTime: NSDateFormatter {
        return self.longDateTimeFormatter()
    }
    
    class func shortTimeFormatter() -> NSDateFormatter {
        return Extension.shortTimeFormatter
    }
    
    class func shortDateFormatter() -> NSDateFormatter {
        return Extension.shortDateFormatter
    }
    
    class func mediumDateTimeFormatter() -> NSDateFormatter {
        return Extension.mediumDateTimeFormatter
    }
    
    class func longDateTimeFormatter() -> NSDateFormatter {
        return Extension.longDateTimeFormatter
    }
    
    convenience init(dateStyle: NSDateFormatterStyle, timeStyle: NSDateFormatterStyle) {
        self.init()
        self.dateStyle = dateStyle
        self.timeStyle = timeStyle
    }
}
