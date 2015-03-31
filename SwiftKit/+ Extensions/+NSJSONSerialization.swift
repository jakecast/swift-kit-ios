import Foundation

public extension NSJSONSerialization {
    class func JSONObject(data: AnyObject?) -> AnyObject? {
        var jsonObject: AnyObject?
        if let jsonData = data as? NSData {
            jsonObject = self.JSONObject(data: jsonData)
        }
        else {
            jsonObject = nil
        }
        return jsonObject
    }

    class func JSONObject(#data: NSData) -> AnyObject? {
        var jsonObject: AnyObject?
        self.debugOperation {(error) -> (Void) in
            jsonObject = self.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: error)
        }
        return jsonObject
    }
}
