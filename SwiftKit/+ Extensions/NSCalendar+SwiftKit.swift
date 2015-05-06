import Foundation

public extension NSCalendar {
    static var sharedInstance: NSCalendar {
        return self.sharedCalendar()
    }
    
    static func sharedCalendar() -> NSCalendar {
        return self.autoupdatingCurrentCalendar()
    }
}

