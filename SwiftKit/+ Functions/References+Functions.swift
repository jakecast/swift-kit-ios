import Foundation

public func methodPointer<T: AnyObject>(obj: T, method: (T) -> (NSNotification!) -> (Void)) -> ((NSNotification!) -> (Void)) {
    return {[weak obj] notification in
        method(obj!)(notification)
    }
}

public func methodPointer<T: AnyObject>(obj: T, method: (T) -> (Bool) -> (Void)) -> ((Bool) -> (Void)) {
    return {[weak obj] bool in
        method(obj!)(bool)
    }
}
