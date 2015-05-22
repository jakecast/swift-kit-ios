import Foundation

public extension NSBlockOperation {
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
