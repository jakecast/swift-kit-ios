import Foundation

internal class NotificationObserver {
    private let isDarwinNotification: Bool
    private let notificationName: String
    private let observer: NSObjectProtocol

    private weak var manager: NotificationManager? = nil

    deinit {
        NSNotificationCenter
            .defaultCenter()
            .removeObserver(self.observer)

        if self.isDarwinNotification {
            self.manager?.removeDarwinNotification(
                notificationName: self.notificationName,
                observer: self
            )
        }
    }

    internal init(
        manager: NotificationManager,
        notificationName: String,
        isDarwinNotification: Bool,
        object: NSObject?,
        queue: NSOperationQueue?,
        block: (NSNotification!)->Void
    ) {
        self.isDarwinNotification = isDarwinNotification
        self.manager = manager
        self.notificationName = notificationName
        self.observer = NSNotificationCenter
            .defaultCenter()
            .addObserverForName(notificationName, object: object, queue: queue, usingBlock: block)

        if self.isDarwinNotification {
            self.manager?.addDarwinNotification(
                notificationName: notificationName,
                observer: self
            )
        }
    }
}
