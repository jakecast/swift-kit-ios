import Foundation

public func methodPointer<T: AnyObject>(obj: T, method: (T) -> (Void)->(Void)) -> ((Void)->(Void)) {
    return {[weak obj] in
        method(obj!)()
    }
}

public func methodPointer<T: AnyObject>(obj: T, method: (T) -> (Bool) -> (Void)) -> ((Bool) -> (Void)) {
    return {[weak obj] bool in
        method(obj!)(bool)
    }
}

public func methodPointer<T: AnyObject>(obj: T, method: (T) -> (NSNotification!) -> (Void)) -> ((NSNotification!) -> (Void)) {
    return {[weak obj] notification in
        method(obj!)(notification)
    }
}
