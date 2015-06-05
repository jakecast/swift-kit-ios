import Foundation

internal class NotificationObserver {
    private let isDarwinNotification: Bool
    private let notificationName: String
    private let observer: NSObjectProtocol

    deinit {
        NSNotificationCenter
            .defaultCenter()
            .removeObserver(self.observer)
    }

    internal init(
        notificationName: String,
        isDarwinNotification: Bool,
        object: NSObject?,
        queue: NSOperationQueue?,
        block: (NSNotification!)->Void
    ) {
        self.isDarwinNotification = isDarwinNotification
        self.notificationName = notificationName
        self.observer = NSNotificationCenter
            .defaultCenter()
            .addObserverForName(notificationName, object: object, queue: queue, usingBlock: block)
    }
}
