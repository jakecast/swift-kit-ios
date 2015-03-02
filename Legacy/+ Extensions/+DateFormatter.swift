import UIKit

public extension DateFormatter {
    private struct Shared {
        static let localDateFormatter = DateFormatter(locale: Locale.currentInstance)
    }

    class func defaultFormatter(dateFormat: String?=nil) -> DateFormatter {
        if let dateFormatString = dateFormat {
            Shared.localDateFormatter.dateStyle = DateFormatterStyle.NoStyle
            Shared.localDateFormatter.timeStyle = DateFormatterStyle.NoStyle
            Shared.localDateFormatter.dateFormat = dateFormatString
        }

        return Shared.localDateFormatter
    }

    class func shortDateFormatter() -> DateFormatter {
        return self
            .defaultFormatter()
            .updateStyle(dateStyle: DateFormatterStyle.ShortStyle, timeStyle: DateFormatterStyle.NoStyle)
    }

    class func shortTimeFormatter() -> DateFormatter {
        return self
            .defaultFormatter()
            .updateStyle(dateStyle: DateFormatterStyle.NoStyle, timeStyle: DateFormatterStyle.ShortStyle)
    }

    convenience init(locale: Locale) {
        self.init()
        self.locale = locale
    }

    convenience init(dateStyle: DateFormatterStyle, timeStyle: DateFormatterStyle) {
        self.init(locale: Locale.currentInstance)
        self.dateStyle = dateStyle
        self.timeStyle = timeStyle
    }

    var style: (dateStyle: DateFormatterStyle, timeStyle: DateFormatterStyle) {
        get {
            return (
                dateStyle: self.dateStyle,
                timeStyle: self.timeStyle
            )
        }
        set(newStyle) {
            self.dateStyle = newStyle.dateStyle
            self.timeStyle = newStyle.timeStyle
        }
    }

    func updateStyle(
        #dateStyle: DateFormatterStyle,
        timeStyle: DateFormatterStyle
    ) -> DateFormatter {
        self.dateStyle = dateStyle
        self.timeStyle = timeStyle
        return self
    }
}