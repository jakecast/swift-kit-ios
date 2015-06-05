import Foundation

public class NotificationManager {
    private static let sharedInstance: NotificationManager = NotificationManager()
    private static var mapTableKey: String = "NotificationMapTable"

    public static func add<T: AnyObject>(
        #observer: T,
        notification: StringRepresentable,
        isDarwinNotification: Bool=false,
        object: NSObject?=nil,
        queue: NSOperationQueue?=nil,
        function: (T) -> (NSNotification!) -> (Void)
    ) {
        self.sharedInstance.add(
            observer: observer,
            notification: notification,
            isDarwinNotification: isDarwinNotification,
            object: object,
            queue: queue,
            block: methodPointer(observer, function)
        )
    }

    private func add(
        #observer: AnyObject,
        notification: StringRepresentable,
        isDarwinNotification: Bool,
        object: NSObject?,
        queue: NSOperationQueue?,
        block: (NSNotification!)->Void
    ) {
        if let observerMapTable = self.getObserverMapTable(observer) {
            observerMapTable[notification.stringValue] = NotificationObserver(
                notificationName: notification.stringValue,
                isDarwinNotification: isDarwinNotification,
                object: object,
                queue: queue,
                block: block
            )
        }
    }

    private func getObserverMapTable(observer: AnyObject) -> NSMapTable? {
        if objc_getAssociatedObject(observer, &NotificationManager.mapTableKey) is NSMapTable == false {
            objc_setAssociatedObject(
                observer,
                &NotificationManager.mapTableKey,
                NSMapTable(keyValueOptions: PointerOptions.StrongMemory),
                AssociationPolicy.RetainNonAtomic.uintValue
            )
        }
        return objc_getAssociatedObject(observer, &NotificationManager.mapTableKey) as? NSMapTable
    }
}
