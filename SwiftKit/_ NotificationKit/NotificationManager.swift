import Foundation

public final class NotificationManager {
    private static let sharedInstance: NotificationManager = NotificationManager()
    private static var mapTableKey: String = "NotificationMapTable"

    private let groupDirectory: String = "Notifications"
    private var groupIdentifier: String? = nil
    private lazy var darwinObserverMonitor: [String:Int] = [:]

    deinit {
        CFNotificationCenter
            .darwinNotificationCenter()
            .remove(observer: self)
    }

    public static func sharedManager() -> NotificationManager {
        return self.sharedInstance
    }

    public func set(#groupIdentifier: String?) -> Self {
        self.groupIdentifier = groupIdentifier
        return self
    }

    public func add<T: AnyObject>(
        #observer: T,
        notification: StringRepresentable,
        isDarwinNotification: Bool=false,
        object: NSObject?=nil,
        queue: NSOperationQueue?=nil,
        function: (T) -> (NSNotification!) -> (Void)
    ) {
        if let observerMapTable = self.getObserverMapTable(observer) {
            observerMapTable[notification.stringValue] = NotificationObserver(
                manager: self,
                notificationName: notification.stringValue,
                isDarwinNotification: isDarwinNotification,
                object: object,
                queue: queue,
                block: methodPointer(observer, function)
            )
        }
    }

    public func post(
        #notificationName: StringRepresentable,
        isDarwinNotification: Bool=false,
        userInfo: [NSObject:AnyObject]?=nil
    ) {
        if isDarwinNotification {
            self.postGlobalNotification(notificationName: notificationName.stringValue, userInfo: userInfo)
        }
        else {
            self.postLocalNotification(notificationName: notificationName.stringValue, userInfo: userInfo)
        }
    }

    internal func addDarwinNotification(#notificationName: String, observer: NotificationObserver) {
        if self.darwinObserverMonitor[notificationName] == nil {
            self.setupDarwinNotification(notificationName: notificationName)
        }

        self.darwinObserverMonitor[notificationName] = (self.darwinObserverMonitor[notificationName] ?? 0) + 1
    }

    internal func receiveDarwinNotification(#notificationName: String) {
        var darwinUserInfo: [String:AnyObject]?
        if let notificationFileURL = self.getDarwinNotificationFileURL(notificationName) {
            darwinUserInfo = NSFileManager
                .defaultManager()
                .getObjectData(fileURL: notificationFileURL) as? [String:AnyObject]
        }
        else {
            darwinUserInfo = nil
        }

        self.postLocalNotification(notificationName: notificationName, userInfo: darwinUserInfo)
    }

    internal func removeDarwinNotification(#notificationName: String, observer: NotificationObserver) {
        self.darwinObserverMonitor[notificationName] = (self.darwinObserverMonitor[notificationName] ?? 0) - 1

        if self.darwinObserverMonitor[notificationName] == 0 {
            self.removeDarwinNotification(notificationName: notificationName)
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

    private func getDarwinNotificationFileURL(notificationName: String) -> NSURL? {
        var notificationFileURL: NSURL?
        if let appGroupIdentifier = self.groupIdentifier {
            notificationFileURL = NSFileManager
                .defaultManager()
                .groupContainerPath(groupIdentifier: appGroupIdentifier)
                .stringByAppendingPathComponent(self.groupDirectory)
                .stringByAppendingPathComponent("\(notificationName).notification")
                .asURL()
        }
        else {
            notificationFileURL = nil
        }
        return notificationFileURL
    }

    private func setupDarwinNotification(#notificationName: String) {
        self.darwinObserverMonitor[notificationName] = 0

        CFNotificationCenter
            .darwinNotificationCenter()
            .add(observer: self, notification: notificationName, callback: { self.receiveDarwinNotification(notificationName: $0) })
    }

    private func removeDarwinNotification(#notificationName: String) {
        self.darwinObserverMonitor[notificationName] = nil

        CFNotificationCenter
            .darwinNotificationCenter()
            .remove(observer: self, notification: notificationName)
    }

    private func postGlobalNotification(#notificationName: String, userInfo: [NSObject:AnyObject]?=nil) {
        if let globalUserInfo = userInfo, let notificationFileURL = self.getDarwinNotificationFileURL(notificationName) {
            NSFileManager
                .defaultManager()
                .writeObjectData(object: globalUserInfo, fileURL: notificationFileURL)
        }

        CFNotificationCenter
            .darwinNotificationCenter()
            .post(notification: notificationName)
    }

    private func postLocalNotification(#notificationName: String, userInfo: [NSObject:AnyObject]?=nil) {
        NSNotificationCenter
            .defaultCenter()
            .post(notificationName: notificationName, userInfo: userInfo)
    }
}
