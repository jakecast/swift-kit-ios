import UIKit

public class EventCenter {
    private lazy var notificationObservers: [AnyObject] = []
    
    private var notificationCenter: NSNotificationCenter {
        return NSNotificationCenter.defaultCenter()
    }
    
    public init() {}
    
    deinit {
        self.removeNotifications()
    }
    
    public func watchNotification(#name: String, object: AnyObject?=nil, block: (NSNotification!) -> (Void)) {
        self.notificationObservers += [
            self.notificationCenter.addObserverForName(name, object: object, queue: nil, usingBlock: block),
        ]
    }
    
    public func removeNotifications() {
        for observer in notificationObservers {
            self.notificationCenter.remove(observer: observer)
        }
    }
}