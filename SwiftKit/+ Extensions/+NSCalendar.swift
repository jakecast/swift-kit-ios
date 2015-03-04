import Foundation

public extension NSCalendar {
    class var sharedInstance: NSCalendar {
        return self.sharedCalendar()
    }
    
    class func sharedCalendar() -> NSCalendar {
        return self.autoupdatingCurrentCalendar()
    }
}

