import Foundation

class NotificationObserver {
    let observer: NSObjectProtocol

    init(notification: String, object: AnyObject?=nil, queue: NSOperationQueue?=nil, block: (NSNotification!) -> (Void)) {
        self.observer = NSNotificationCenter
            .defaultCenter()
            .addObserverForName(notification, object: object, queue: queue, usingBlock: block)
    }

    deinit {
        NSNotificationCenter
            .defaultCenter()
            .removeObserver(self.observer)
    }
}
