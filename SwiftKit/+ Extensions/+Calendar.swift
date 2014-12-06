import UIKit


extension NSCalendar {
    class var currentInstance: NSCalendar {
        return self.currentCalendar()
    }

    class func dateFromComponents(date: Date=Date(), components: DateComponents) -> Date? {
        return self
            .currentCalendar()
            .dateByAddingComponents(components, toDate: date, options: nil)
    }
}