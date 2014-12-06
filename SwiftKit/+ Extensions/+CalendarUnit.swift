import UIKit


public extension CalendarUnit {
    static var mainDateUnits: CalendarUnit {
        let mainUnits =
            CalendarUnit.YearCalendarUnit |
            CalendarUnit.MonthCalendarUnit |
            CalendarUnit.WeekdayCalendarUnit |
            CalendarUnit.DayCalendarUnit |
            CalendarUnit.HourCalendarUnit |
            CalendarUnit.MinuteCalendarUnit |
            CalendarUnit.SecondCalendarUnit

        return mainUnits
    }
}
