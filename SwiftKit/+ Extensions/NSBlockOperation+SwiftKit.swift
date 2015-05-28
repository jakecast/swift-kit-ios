import Foundation

public extension NSBlockOperation {
    private struct Extension {
        static var asynchronousKey = "asynchronous"
    }

    public override var asynchronous: Bool {
        get {
            return self.getAssociatedObject(key: &Extension.asynchronousKey) as? Bool ?? false
        }
        set(newValue) {
            self.setAssociatedObject(key: &Extension.asynchronousKey, object: newValue)
        }
    }

    public override var concurrent: Bool {
        return self.asynchronous
    }

    public convenience init(blocks: [((Void)->(Void))]) {
        self.init()
        self.add(blocks: blocks)
    }

    public func add(#block: ((Void)->(Void))) {
        self.addExecutionBlock(block)
    }

    public func add(#blocks: [((Void)->(Void))]) {
        blocks.each { self.addExecutionBlock($0) }
    }
}
