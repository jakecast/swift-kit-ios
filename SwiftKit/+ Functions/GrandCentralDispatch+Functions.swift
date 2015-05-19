import Foundation

public func dispatch_underlying_queue_create(
    name: String,
    serial: Bool,
    qualityOfService: NSQualityOfService
) -> dispatch_queue_t {
    return dispatch_queue_create(
        name,
        dispatch_queue_attr_make_with_qos_class(serial == true ? DISPATCH_QUEUE_SERIAL : DISPATCH_QUEUE_CONCURRENT, qualityOfService.qosClass, 0)
    )
}
