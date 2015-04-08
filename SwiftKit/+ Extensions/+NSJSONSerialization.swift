import Foundation

public extension NSJSONSerialization {
    static func JSONObject(data: AnyObject?) -> AnyObject? {
        var jsonObject: AnyObject?
        if let jsonData = data as? NSData {
            jsonObject = self.JSONObject(data: jsonData)
        }
        else {
            jsonObject = nil
        }
        return jsonObject
    }

    static func JSONObject(#data: NSData) -> AnyObject? {
        var jsonObject: AnyObject?
        NSError.performOperation {(error) -> (Void) in
            jsonObject = self.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: error)
        }
        return jsonObject
    }

    static func dataObject(json: AnyObject?) -> NSData? {
        var dataObject: NSData?
        if let jsonData: AnyObject = json {
            dataObject = self.dataObject(json: jsonData)
        }
        else {
            dataObject = nil
        }
        return dataObject
    }

    static func dataObject(#json: AnyObject) -> NSData? {
        var dataObject: NSData?
        NSError.performOperation {(error) -> (Void) in
            dataObject = self.dataWithJSONObject(json, options: NSJSONWritingOptions.allZeros, error: error)
        }
        return dataObject
    }
}
