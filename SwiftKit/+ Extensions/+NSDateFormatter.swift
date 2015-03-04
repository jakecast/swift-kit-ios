import Foundation

public extension NSDateFormatter {
    private struct Class {
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
        return Class.shortTimeFormatter
    }
    
    class func shortDateFormatter() -> NSDateFormatter {
        return Class.shortDateFormatter
    }
    
    class func mediumDateTimeFormatter() -> NSDateFormatter {
        return Class.mediumDateTimeFormatter
    }
    
    class func longDateTimeFormatter() -> NSDateFormatter {
        return Class.longDateTimeFormatter
    }
    
    convenience init(dateStyle: NSDateFormatterStyle, timeStyle: NSDateFormatterStyle) {
        self.init()
        self.dateStyle = dateStyle
        self.timeStyle = timeStyle
    }
}
